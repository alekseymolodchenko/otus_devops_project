TF=terraform
TF_INIT=$(TF) init
TF_GET=$(TF) get
TF_APPLY=$(TF) apply -auto-approve
TF_DESTROY=$(TF) destroy -auto-approve
TF_VARS_FILE=terraform.tfvars
TF_DIR=terraform
K8S=kubectl
K8S_DIR=kubernetes
CHARTS_DIR=$(K8S_DIR)/Charts
TILLER_EXIST := $(shell kubectl get pods -n kube-system | grep -Ec "tiller.*Running")
HELM_INIT=helm init

.PHONY: all cluster-create cluster-destroy create-tiller deploy-gitlab

all: cluster-create deploy-app deploy-ingress deploy-monitoring deploy-app deploy-production deploy-staging deploy-ingress

cluster-create:
	@echo ">> Creating Kubernetes Cluster"
#	gsutil mb gs://tf-otus-crawler-project/
	cd $(TF_DIR) && $(TF_INIT) ; $(TF_GET) ; $(TF_APPLY)

cluster-destroy:
	@echo ">> Removing Kubernetes Cluster"
	cd $(TF_DIR) && $(TF_DESTROY)

create-tiller:
ifeq ($(TILLER_EXIST), 0)
	@echo ">> Creating tiller service account"
	$(K8S) apply -f $(K8S_DIR)/manifests/tiller/tiller.yml
	$(HELM_INIT) --service-account tiller
	sleep 5
else
	@echo ">> Tiller account exits"
endif


deploy-gitlab: create-tiller
	@echo ">> Deploying Gitlab to Kubernetes"
	cd $(CHARTS_DIR)/gitlab && helm install --name gitlab . -f values.yaml

deploy-app: deploy-production deploy-staging

deploy-production: create-tiller
	@echo ">> Deploying Search Engine application to Production"
	cd $(CHARTS_DIR)/search-engine && helm dep update
	cd $(CHARTS_DIR) && helm upgrade prod search-engine --install --namespace production

deploy-staging: create-tiller
	@echo ">> Deploying Search Engine application to Staging"
	cd $(CHARTS_DIR)/search-engine && helm dep update
	cd $(CHARTS_DIR) && helm upgrade stage search-engine --install --namespace staging

deploy-ingress: create-tiller
	helm install stable/nginx-ingress --name nginx

deploy-monitoring: deploy-prometheus deploy-grafana

deploy-prometheus: create-tiller
	helm upgrade prom stable/prometheus -f $(CHARTS_DIR)/prometheus/values.yaml --install --namespace monitoring

deploy-grafana: create-tiller
	helm upgrade grafana stable/grafana -f $(CHARTS_DIR)/grafana/values.yaml --install --namespace monitoring
	$(K8S) apply -f $(K8S_DIR)/manifests/grafana --namespace monitoring

test: depend
	@echo ">> running tests"
	@python -m unittest discover -s tests/

docker-build:
	@echo ">> building docker images"
	cd src/search_engine_crawler ; make build
	cd src/search_engine_ui ; make build

docker-push:
