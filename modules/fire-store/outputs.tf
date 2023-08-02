output "db_name" {
    description = "Name of the database"
    value = google_firestore_database.firestore_db.name
}

output "db_id" {
    description = "ID in the format `projects/{{project}}/databases/{{name}}`"
    value = google_firestore_database.firestore_db.id
}