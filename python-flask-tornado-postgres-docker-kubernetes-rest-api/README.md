# Flask REST API in Python part 0/6: introduction

We're going to see how to setup a project end to end. 
This is both a bottom-up and top-down journey to go back and forth the 
challenges of:

- writing Python code for an HTTP API using the Flask and Tornado `pip` packages,
- configuring this API adopting best practice for the source code 
  (linters, modularity, integration tests, dependency injection), 
- involve a Postgres DB to store the state of the application, 
- making the application ready for a cloud solution with Docker or a Kubernetes cluster (Minikube),
- orchestrating all the moving parts with Makefiles (GUN Make) for e.g. a CI/CD environment (Continuous Improvement, Continuous Delivery).

We'll start simple with a "main file" invoked with the `python` command 
and tested by hand with the `curl` command.

Then we'll introduce a Database Docker container (Postgres).

Then we'll introduce proper integration tests, linters, 
dockerize all the moving parts, and finally introduce them 
to a local Kubernetes cluster with Minikube.

# Flask REST API in Python part 1/6: how to write the HTTP server

Let's write the Python code to serve HTTP GET (and later HTTP POST) endpoints,
and how to use the `curl` command to troubleshoot them. 

We're going to see how we validate HTTP path and query parameters.

We're also going to see some rules of thumb for Python development on how to set:

- configuration files,
- logs,
- usage of environment variables to drive choices on file system paths and similar e.g. test/stage/prod environments,
- general dependency injection principles, and so on.

Tags: #rest #flask #api 

# Flask REST API in Python part 2/6: how to connect to Postgres DB with psycopg2 and Docker

Let's include a Postgres SQL database executed as a Docker container.
Our Python API will connect to the Database to send and retrieve rows 
based on the HTTP API requests.

- https://github.com/psycopg/psycopg2
- https://hub.docker.com/_/postgres/?tab=tags&page=1&name=12.6-alpine

Tags: #flask #postgres #docker

# Flask REST API in Python part 3/6: how to write unit and integration tests

Let's explore how the `unittest` package works, 
how we could write some simple HTTP interactions with the `curl` command,
and how we can test the HTTP layer with the help of the Python `requests` library.

- https://docs.python.org/3/library/unittest.html
- https://docs.python-requests.org/en/latest/

Tags: #flask #api #integration-test

# Flask REST API in Python part 4/6: how to lint the code

Let's see how to lint the code with Black, Flake8, Pylint, Pytype, Bandit, Isort, and Sqlfluff. We're going to use a combination of code formatters, linters, type checkers
and static code analyzers.

- https://github.com/psf/black
- https://flake8.pycqa.org/en/latest/user/error-codes.html
- https://pylint.pycqa.org/en/latest/technical_reference/features.html
- https://github.com/google/pytype
- https://github.com/PyCQA/bandit
- https://github.com/PyCQA/isort
- https://github.com/sqlfluff/sqlfluff
- https://yamllint.readthedocs.io/en/stable/
- https://www.kubeval.com/
- https://polaris.docs.fairwinds.com/infrastructure-as-code/#running-in-a-ci-pipeline

Tags: #python #linter #flake8

# Flask REST API in Python part 5/6: setup a Docker solution as API, Postgres, networks, volumes

Let's see how we can take advantage of Docker to provide a complete solution with both the 
database and the backend API running as a Docker container.
We're going to use a dedicated Docker network with a specific Docker volume.
This allows to store the data related to the Database in the file system.
We can then process the Docker Volume path with a backup routine.

- https://docs.docker.com/get-started/09_image_best/
- https://docs.docker.com/language/python/run-containers/
- https://docs.docker.com/network/bridge/
- https://docs.docker.com/storage/volumes/

We're going to see how we can validate the Database Connection to Postgres SQL from the REST API point of view.
This happens directly while building the Docker Image for the HTTP API, so we can make sure that
the ODBC drivers (when needed) and the Python dependencies can reach the Postgres SQL Database.

Tags: #docker #docker-network #postgres

# Flask REST API in Python part 6/6: how to deploy a Kubernetes solution with Minikube

Let's see how to deploy a Kubernetes solution with Minikube and:

- deployments for the REST API and the Postgres DB,
- services to expose the deployments with an IP address and a TCP port
- persistent volumes (and claims) plus secrets to manage stateful deployments like a Postgres database.

Some context:

- https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
- https://minikube.sigs.k8s.io/docs/start/
- https://kubernetes.io/docs/concepts/storage/persistent-volumes/

We're also going to see how to lint the YAML code for Kubernetes with "yamllint" and "Kubeval".

- https://yamllint.readthedocs.io/en/stable/
- https://www.kubeval.com/
- https://polaris.docs.fairwinds.com/infrastructure-as-code/#running-in-a-ci-pipeline

We can check (monitor) the status of the resources of our
Kubernetes cluster with a variety of tools like:

- the `kubectl` command
- the Lens IDE (visual): https://k8slens.dev/

Let's also briefly mention other networking (routing) options like 
Ingress and Gateway API.

Although we're not implementing any of these, this is a very important topic.
It's usually related to the cloud provider of choice e.g. AWS, GCP, Azure or a local Minikube cluster and the tiny configuration details make the difference in terms of architecture and infrastructure as code (YAML files).

- https://kubernetes.io/docs/concepts/services-networking/ingress/
- https://gateway-api.sigs.k8s.io/
- https://projectcontour.io/guides/gateway-api/

We usually secure an API with TLS certificates (old SSL) signed by a 3rd party authority.
Although we could use self-signed TLS certificates directly with Tornado + Flask, they are usually provided by the Let's Encrypt certificate manager. 
They are stored in solutions like Nginx as a Reverse Proxy deployed as a Kubernetes Ingress
acting - in principles, as a Load Balancer.

We're not going to add TLS certificates or an Nginx reverse proxy,
however these are some more resources to deep dive into the topic:

- https://kubernetes.github.io/ingress-nginx/
- https://en.wikipedia.org/wiki/Reverse_proxy
- https://letsencrypt.org/

Tags: #kubernetes #flask #postgres


# Keywords

python,flask,rest api,api,http api,python logger,python configuration,postgrs,postgres db,postgresql,integration test,curl,linter,static code analysis,type checking,docker,docker network,docker volume,flake8,pylint,pytype,black,sqlfluff,kubernetes,minikube,kubernetes service,kubernetes secret,kubernetes persistent volume

