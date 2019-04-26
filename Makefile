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

all:

cluster-create:
	@echo ">> Creating Kubernetes Cluster"
	$(TF_INIT) $(TF_DIR) ; $(TF_GET) $(TF_DIR) ; $(TF_APPLY) -var-file=$(TF_DIR)/$(TF_VARS_FILE) $(TF_DIR)

cluster-destroy:
	@echo ">> Removing Kubernetes Cluster"
	$(TF_DESTROY) -var-file=$(TF_DIR)/$(TF_VARS_FILE) $(TF_DIR)

create-tiller:
	@echo ">> Creating tiller service account"
	$(K8S) apply -f $(K8S_DIR)/tiller.yml
	helm init --service-account tiller

deploy-gitlab: create-tiller
	@echo ">> Deploying Gitlab to Kubernetes"
	$(K8S) apply -f $(K8S_DIR)/gitlab.yml
	helm init --service-account gitlab-admin
	cd $(CHARTS_DIR)/gitlab-omnibus ; helm install --name gitlab . -f values.yaml

deploy-app: create-tiller
	@echo ">> Deploying Search Engine application to cluster"
	cd kubernetes/Charts/search-engine ; helm dep update
	cd kubernetes/Charts ; helm install search-engine --name se

test: depend
	@echo ">> running tests"
	@python -m unittest discover -s tests/

docker-build:
	@echo ">> building docker images"
	cd src/search_engine_crawler ; make build
	cd src/search_engine_ui ; make build

docker-push:


.PHONY: all
