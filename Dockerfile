FROM puckel/docker-airflow

USER root

RUN pip install -U apache-airflow[kubernetes] psycopg2-binary

#COPY airflow.cfg /usr/local/airflow
