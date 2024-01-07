# Performance

## Scenario 1
### Source
Security Manager
### Stimulus
1000 requests per second
### Artifact
Logger
### Response
All requests must be processed for the sake of the security
### Measure
With an average latency of 1 sec
#### Modification to the system
Having one or more backup servers that will start working if the main server is overloaded with requests

# Scalability

## Scenario 2
### Source
Users
### Stimulus
The amount of actions performed in the module increases over time
### Artifact
Database
### Response
Database is divided
### Measure
Performance and availability are not affected
#### Modification to the system
Log database is separated from the main database.

# Availability

## Scenario 1
### Source
Building manager
### Stimulus
Unable to write
### Artifact
Database
### Response
Mask(postpone), log
### Measure
No downtime, write performed in max 10 minutes
#### Modification to the system
Add support for delaying write, possibly add backup fallback DB.

## Scenario 2
### Source
Building manager
### Stimulus
Unable to read from database
### Artifact
Database
### Response
Mask(repeat), log
### Measure
Max downtime 5s
#### Modification to the system
Second backup database with copied data.

# Security

## Scenario 1
### Source
Users
### Stimulus
Even users who have access to the system can have bad intentions to get data which should be kept secret. Inserting code into search windows
### Artifact
Individual managers of the system (Equipment manager, ...) 
### Response
Input data are always sanitized from special characters to prevent for example SQL injection, javascript injection and others
### Measure
Performance and other quality requirements will not be affected because it will only do few operations with strings which are not computationally intensive
#### Modification to the system
Introduce a small segment of code into managers to sanitize their input fields.