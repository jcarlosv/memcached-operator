IMAGE="jcarlosv/memcached-operator:v0.0.1"

all: update-generated-code register-operator push-image create-cr

delete-all: delete-cr delete-deploy-operator unregister-operator

update-generated-code:
	operator-sdk generate k8s

register-operator:
	kubectl apply -f deploy/crds/cache_v1alpha1_memcached_crd.yaml

unregister-operator:
	kubectl delete -f deploy/crds/cache_v1alpha1_memcached_crd.yaml || true

create-deploy-file:
	 sed -i 's|REPLACE_IMAGE|$(IMAGE)|g' deploy/operator.yaml

deploy-operator: create-deploy-file
	kubectl apply -f deploy/service_account.yaml
	kubectl apply -f deploy/role.yaml
	kubectl apply -f deploy/role_binding.yaml
	kubectl apply -f deploy/operator.yaml

delete-deploy-operator:
	kubectl delete -f deploy/operator.yaml || true
	kubectl delete -f deploy/role_binding.yaml || true
	kubectl delete -f deploy/role.yaml || true
	kubectl delete -f deploy/service_account.yaml || true

build-image:
	operator-sdk build $(IMAGE)

push-image: build-image
	docker push $(IMAGE)

create-cr: deploy-operator
	kubectl apply -f deploy/crds/cache_v1alpha1_memcached_cr.yaml

delete-cr: 
	kubectl delete -f deploy/crds/cache_v1alpha1_memcached_cr.yaml || true

cr-status:
	 kubectl get memcached/example-memcached -o yaml

unit-test:
	golangci-lint run ./pkg/controller/memcached/memcached_controller.go
