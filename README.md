# Проект Otus Search Engine

## Requirements

* [Terraform][] >= 0.11.10
* [gcloud-sdk][]
* [kubernetes-cli][]
* [Helm][] >= 2.13.1

## Usage

1. [Включаем GKE API][gke-api],
2. [Создаем сервисный аккаунт][service-account],
3. `export GOOGLE_PROJECT=$(gcloud config get-value project)`,
4. `gcloud config set project $GOOGLE_PROJECT` устанавливаем текущий проект,
5. `make deploy-app` деплоим приложение на staging и production окружения,
6. `make deploy-ingress && make deploy-monitoring` развертываем мониторинг

[Terraform]: https://terraform.io
[Google Kubernetes Engine]: https://cloud.google.com/kubernetes-engine/
[gcloud-sdk]: https://cloud.google.com/sdk/docs/
[kubernetes-cli]: https://kubernetes.io/docs/tasks/tools/install-kubectl/
[gke-api]: https://console.developers.google.com/apis/api/container.googleapis.com/overview?project=terraform-gke
[service-account]: https://console.developers.google.com/
[Helm]: https://helm.sh/

## Todo

 - [x] Добавить исходные код приложения;
 - [x] Контейнеризировать приложения UI и Crawler;
 - [x] Добавить привиженинг кластера k8s для terraform;
 - [x] Добавить Helm Charts для деплоя приложения;
 - [ ] Добавить bucket для хранения стейта terraform;
 - [x] Добавить мониторинг приложения;
 - [ ] Добававить алертинг;
 - [ ] Добавить логирование;
 - [ ] Добавить CI/CD Pipeline;
 - [ ] Добавить описание проекта

## Author

Copyright (c) 2019 Aleksey Molodchenko <am@sw1tch.pp.ua>.
