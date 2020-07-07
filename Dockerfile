FROM puckel/docker-airflow

ARG AIRFLOW_VERSION=1.10.10

USER root

RUN pip3 install -U apache-airflow[kubernetes,snowflake]==${AIRFLOW_VERSION} psycopg2-binary

