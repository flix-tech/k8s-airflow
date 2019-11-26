FROM puckel/docker-airflow

USER root

RUN pip3 install -U apache-airflow[kubernetes] psycopg2-binary
