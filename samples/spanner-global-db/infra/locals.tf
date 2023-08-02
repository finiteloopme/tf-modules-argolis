locals {

  # API services
  project_apis = [
        "compute.googleapis.com",
        "cloudresourcemanager.googleapis.com",
        "spanner.googleapis.com",
        "run.googleapis.com",
        # Enabling the ServiceUsage API allows the new project to be quota checked from now on.
        "serviceusage.googleapis.com",
  ]

  DDL_TABLE_SINGERS = {
    value = <<EOH
    CREATE TABLE Singers (
                                SingerId   INT64 NOT NULL,
                                FirstName  STRING(1024),
                                LastName   STRING(1024),
                                SingerInfo BYTES(MAX),
                                FullName   STRING(2048) AS (
                                        ARRAY_TO_STRING([FirstName, LastName], " ")
                                ) STORED
                        ) PRIMARY KEY (SingerId)
  EOH
  }
  DDL_TABLE_ALBUMS = {
    value = <<EOH
    CREATE TABLE Albums (
                                SingerId     INT64 NOT NULL,
                                AlbumId      INT64 NOT NULL,
                                AlbumTitle   STRING(MAX)
                        ) PRIMARY KEY (SingerId, AlbumId),
                        INTERLEAVE IN PARENT Singers ON DELETE CASCADE
  EOH
  }
}