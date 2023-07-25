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