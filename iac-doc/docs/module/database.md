# Module Database

Provide a database for the app deployed on our compute instance.


## Required variables

- `project_id`: project id to attach all resources to
- `project_name`: name to compute the resource name from

- `region`: the deployment region
- `vpc_id`: the ID of our VPC


## Resources

- `password` ([random_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password)): a generated random password for the database

- `instance` ([google_sql_database_instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance)): our database instance

- `database` ([google_sql_database](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/gsql_database)): our SQL database inside our database instace

- `users` ([google_sql_user](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user)): the database user, used by the app
