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
    print_message "Removing service account"
    gcloud alpha anthos config controller get-credentials ${CONFIG_CONTROLLER_NAME} \
        --project=${PROJECT_ID} \
        --location ${LOCATION}  \
        --quiet

    export SA_EMAIL="$(kubectl get ConfigConnectorContext -n config-control \
    -o jsonpath='{.items[0].spec.googleServiceAccount}' 2> /dev/null)"

    gcloud projects remove-iam-policy-binding "${PROJECT_ID}" \
        --member "serviceAccount:${SA_EMAIL}" \
        --role "roles/owner" \
        --quiet

    print_message "Deleting config connector: ${CONFIG_CONTROLLER_NAME}"
    gcloud alpha anthos config controller delete ${CONFIG_CONTROLLER_NAME} \
        --project=${PROJECT_ID} \
        --location=${LOCATION} \
        --quiet

    print_message "Listing available config connectors"
    gcloud alpha anthos config controller list \
        --project=${PROJECT_ID} \
        --location=${LOCATION} \
        --quiet

}

# Calling main with all the arguments
main