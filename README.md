#  Kubernetes operator example

Test for learn how they work

Based on:

https://github.com/operator-framework/operator-sdk/blob/master/doc/user-guide.md

memcached-operator


This opetator was modified to detect if a memcached custom resource events
and publish the last event in Slack.

The avents supported are:

- create
- update: When the atribute `value` is modified
- delete when the resouce was deleted


## Requeriments 

- dep
- git
- go
- docker
- kubectl
- Access to a Kubernetes v1.11.3+ cluster.


## Slack token 

In order to send Slack mesages the resource require a token is defined,
update a valid token in `deploy/crds/cache_v1alpha1_memcached_cr.yaml`
## Usage:

To build and deploy the operator run:

```
make all
```

To check the current status of the created resource run

```
make cr-status
```


