# -*- coding: utf-8 -*-
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
"""
This is an example dag for using the Kubernetes Executor.
"""
import os

import airflow
from airflow.models import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.contrib.operators.kubernetes_pod_operator import KubernetesPodOperator
from airflow.operators.bash_operator import BashOperator

args = {
    'owner': 'Airflow',
    'start_date': airflow.utils.dates.days_ago(2)
}

with DAG(
    dag_id='example_kubernetes_executor',
    default_args=args,
    schedule_interval='0 0 * * *'
) as dag:

    tolerations = [{
        'key': 'dedicated',
        'operator': 'Equal',
        'value': 'airflow'
    }]

    def print_stuff():  # pylint: disable=missing-docstring
        print("stuff!")

    # Use the zip binary, which is only found in this special docker image
    two_task = BashOperator(
        task_id='two_task',
        bash_command='echo "run_id={{ run_id }} | dag_run={{ dag_run }}"',
        executor_config={"KubernetesExecutor": {"image": "ci-dump-dcr.mfb.io/data/airflow:latest"}},
    )


    # Limit resources on this operator/task with node affinity & tolerations
    threetask = KubernetesPodOperator(namespace='data-flux-dev',
        image="dcr.mfb.io/data/spark-runner-image:latest",
        cmds=["kubectl"],
        env_vars={'KUBECONFIG':""},
        arguments=["get","pod"],
        service_account_name="spark",
        image_pull_policy="IfNotPresent",
        labels={"foo": "bar"},
        name="threetask",
        task_id="threetask",
        is_delete_operator_pod=True,
        in_cluster=True,
        hostnetwork=False
    )
    two_task >> threetask