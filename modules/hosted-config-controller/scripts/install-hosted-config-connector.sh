#!/usr/bin/env bash

PROJECT_ID=${1}
CONFIG_CONTROLLER_NAME=${2}
LOCATION=${3}

print_message(){
    export MSG_TO_PRINT=${1}
    echo "############################################"
    echo $MSG_TO_PRINT
    echo "############################################"
}

main(){
    print_message "Creating config connector can take upto 15 minutes"
    gcloud alpha anthos config controller create ${CONFIG_CONTROLLER_NAME} \
        --project=${PROJECT_ID} \
        --location=${LOCATION} \
        --quiet

    print_message "Created following config connector"
    gcloud alpha anthos config controller describe ${CONFIG_CONTROLLER_NAME} \
        --project=${PROJECT_ID} \
        --location=${LOCATION} \
        --quiet

    print_message "Configuring service account"
    gcloud alpha anthos config controller get-credentials ${CONFIG_CONTROLLER_NAME} \
        --project=${PROJECT_ID} \
        --location ${LOCATION} \
        --quiet

    export SA_EMAIL="$(kubectl get ConfigConnectorContext -n config-control \
    -o jsonpath='{.items[0].spec.googleServiceAccount}' 2> /dev/null)"

    print_message "Configuring access for SA: ${SA_EMAIL}"
    gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
        --member "serviceAccount:${SA_EMAIL}" \
        --role "roles/owner" \
        --quiet

}

# Calling main with all the arguments
main