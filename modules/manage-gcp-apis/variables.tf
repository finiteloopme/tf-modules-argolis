variable "project_id" {
    description = "Project ID for the DB"
}

variable "project_apis" {
    type = list(string)
    description = "List of APIs"
}

variable "wait_time"{
    description = "Time to wait for API(s) call to 'activate'.  Default is 10s"
    default = "10s"
}