# Security
## Scenario 1
### Source
Users
### Stimulus
Even users who have access to the system can have bad intentions to get data which should be kept secret. Inserting code into search windows
### Artifact
Individual managers of the system (Equipment manager...) 
### Response
Input data are always sanitized from special characters to prevent for example sql injection, javascript injection and others
### Measure
Performance and other quality requirements will not be affected because it will only do few operations with strings which are not computationally intensive
#### Modification to the system
Introduce a small segment of code into managers to sanitize their input fields.

## Scenario 2
### Source
Users
### Stimulus
Logs and actual data are stored in the same database. People with access to database could get security logs if managers would not take special care with accessing the database. 
### Artifact
Database
### Response
Database is divided
### Measure
Performance and availability will be increased, since logging could affect performance of the database
#### Modification to the system
There will be 2 databases - database for logs, technical updates..., database for actual data users need

