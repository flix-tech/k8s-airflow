FROM puckel/docker-airflow AS builder

FROM dcr.mfb.io/data/spark-runner-image:latest

ENV AIRFLOW_HOME=/usr/local/airflow

ENV KUBECONFIG=""

USER root

RUN apk add postgresql-dev gcc libffi-dev

RUN pip3 install -U apache-airflow[kubernetes] psycopg2-binary

COPY --from=builder /entrypoint.sh /entrypoint.sh
COPY --from=builder ${AIRFLOW_HOME}/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

EXPOSE 8080 5555 8793

WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["/entrypoint.sh"]
CMD ["webserver"] # set default arg for entrypoint
