FROM python:3.8

WORKDIR /usr/local/src
COPY cj_sample.py ./

CMD ["python", "/usr/local/src/cj_sample.py"]
