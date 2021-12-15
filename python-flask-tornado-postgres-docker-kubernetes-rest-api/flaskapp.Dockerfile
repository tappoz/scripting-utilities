# Python on Alpine doesn't work very well with
# DB packages like PyODBC or Psycopg2
# FROM python:3.8.12-alpine3.14
FROM python:3.8

# for the `isql` command
RUN apt update && \
    apt install --yes --quiet \ 
        odbc-postgresql \
        unixodbc

# Cache the Pip requirements when they don't change
WORKDIR /usr/local/
COPY requirements.txt .
RUN pip install -r requirements.txt

# DATABASE tests
#
# 1. DIAGNOSTIC
RUN cat /etc/odbcinst.ini ; \
    printf "\n---\n" ; \
    odbcinst -j ; \
    printf "\n---\n" ; \
    ls -lah /usr/lib/x86_64-linux-gnu/odbc/
# 2. TESTING THE DATABASE SETUP FROM THE OPERATING SYSTEM POINT OF VIEW (ODBC)
#    The connection details are for the "Docker network" setup from "test.ini"
#
#    To run this manually:
#    - `sudo apt install unixodbc` (otherwise "Command 'isql' not found")
#    - `sudo apt install odbc-postgresql` (othewise "Can't open lib 'PostgreSQL Unicode' : file not found")
#    - replace the host "flaskapp-db" with "localhost" as we are using the Postgres DB from outside the Docker network
RUN echo "SELECT NOW();" | isql -v -k -b "DRIVER={PostgreSQL Unicode};DATABASE=flaskapp;UID=postgres;PWD=pass01;SERVER=flaskapp-db;PORT=5432;"
# 3. TESTING THE DATABASE SETUP FROM THE PYTHON POINT OF VIEW 
#    library psycopg2, see Pip requirements.txt
#
#    To run this manually:
#    - replace the host "flaskapp-db" with "localhost" as we are using the Postgres DB from outside the Docker network
RUN python -c "import psycopg2;conn = psycopg2.connect(database='flaskapp',user='postgres',password='pass01',host='flaskapp-db',port='5432');cur = conn.cursor();cur.execute('SELECT NOW();');cur.close();conn.close()"

# The source code for the HTTP server (App: Flask+Tornado)
COPY src ./src/

# ENV CONFENV=test # see `--env CONFENV=test` instead
CMD ["python", "/usr/local/src/main.py"]
