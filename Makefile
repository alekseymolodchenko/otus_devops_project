TF=terraform
TF_INIT=$(TF) init
TF_GET=$(TF) get
TF_APPLY=$(TF) apply -auto-approve
TF_DESTROY=$(TF) destroy -auto-approve
TF_VARS_FILE=terraform.tfvars
TF_DIR=./terraform
K8S=kubectl
K8S_DIR=kubernetes
CHARTS_DIR=$(K8S_DIR)/Charts
TILLER_EXIST := $(shell kubectl get pods -n kube-system | grep -Ec "tiller.*Running")

all: cluster-create deploy-app deploy-ingress deploy-monitoring

cluster-create:
	@echo ">> Creating Kubernetes Cluster"
	$(TF_INIT) $(TF_DIR) ; $(TF_GET) $(TF_DIR) ; $(TF_APPLY) -var-file=$(TF_DIR)/$(TF_VARS_FILE) $(TF_DIR)

cluster-destroy:
	@echo ">> Removing Kubernetes Cluster"
	$(TF_DESTROY) -var-file=$(TF_DIR)/$(TF_VARS_FILE) $(TF_DIR)

create-tiller:
ifeq ($(TILLER_EXIST), 0)
	@echo ">> Creating tiller service account"
	$(K8S) apply -f $(K8S_DIR)/manifests/tiller.yml
	helm init --service-account tiller
else
	@echo ">> Tiller account exits"
endif

deploy-gitlab: create-tiller
	@echo ">> Deploying Gitlab to Kubernetes"
	$(K8S) apply -f $(K8S_DIR)/manifests/gitlab.yml
	helm init --service-account gitlab-admin
	cd $(CHARTS_DIR)/gitlab-omnibus ; helm install --name gitlab . -f values.yaml

deploy-app: deploy-production deploy-staging

deploy-production: create-tiller
	@echo ">> Deploying Search Engine application to Production"
	cd kubernetes/Charts/search-engine ; helm dep update
	cd kubernetes/Charts ; helm upgrade prod --namespace production search-engine --install

deploy-staging: create-tiller
	@echo ">> Deploying Search Engine application to Staging"
	cd kubernetes/Charts/search-engine ; helm dep update
	cd kubernetes/Charts ; helm upgrade stage --namespace staging search-engine --install

deploy-ingress: create-tiller
	helm install stable/nginx-ingress --name nginx

deploy-monitoring: deploy-prometheus deploy-grafana

deploy-prometheus: create-tiller
	helm upgrade prom stable/prometheus --namespace monitoring -f kubernetes/Charts/prometheus/values.yaml --install

deploy-grafana: create-tiller
	helm upgrade grafana stable/grafana --namespace monitoring -f kubernetes/Charts/grafana/values.yaml --install
	kubectl apply -f kubernetes/manifests/grafana --namespace monitoring

test: depend
	@echo ">> running tests"
	@python -m unittest discover -s tests/

docker-build:
	@echo ">> building docker images"
	cd src/search_engine_crawler ; make build
	cd src/search_engine_ui ; make build

docker-push:


.PHONY: all
