# Проект Otus Search Engine

## Requirements

* [Terraform][] >= 0.11.10
* [gcloud-sdk][]
* [kubernetes-cli][]
* tbu...

## Usage

1. [Включаем GKE API][gke-api],
2. [Создаем сервисный аккаунт][service-account],
3. `terraform init` скачиваем нужные плагины,
4. `terraform apply` выполняем провижинг кластера,
5. `export GOOGLE_PROJECT=project-123456789`,
6. `gcloud config set project $GOOGLE_PROJECT` устанавливаем текущий проект,
7. `gcloud container clusters list` (для просмотра списка кластеров),
8. tbu....

Теперь можно получить доступ к сластеру Kubernetes через CLI: `kubectl
cluster-info`.

[Terraform]: https://terraform.io
[Google Kubernetes Engine]: https://cloud.google.com/kubernetes-engine/
[gcloud-sdk]: https://cloud.google.com/sdk/docs/
[kubernetes-cli]: https://kubernetes.io/docs/tasks/tools/install-kubectl/
[gke-api]: https://console.developers.google.com/apis/api/container.googleapis.com/overview?project=terraform-gke
[service-account]: https://console.developers.google.com/

## Todo

 - [x] Добавить исходные код приложения;
 - [x] Контейнеризировать приложения UI и Crawler;
 - [x] Добавить привиженинг кластера k8s для terraform;

## Author

Copyright (c) 2019 Aleksey Molodchenko <am@sw1tch.pp.ua>.
