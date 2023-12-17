# Scalability
## Scenario 1
### Source
Teachers
### Stimulus
The amount of requests from teachers increases over time as more faculties adopt this system
### Artifact
Building Manager
### Response
The building manager is scaled up
### Measure
Performance and availability are not affected
#### Modification to the system
Introduce load balancer between Dashboard and building manager.

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
Single database is tranformed into multiple instances divided by functionality (log database, building and equipment database)

