include ../config.properties

.dummy: init, deploy, undeploy

init:
	gcloud container clusters get-credentials krmapihost-gke-config-controller \
		--location=us-central1 \
		--project=${PROJECT_ID}

deploy:
	kubectl apply -f ./gke-clusters/

undeploy:
	kubectl delete -f ./gke-clusters/
