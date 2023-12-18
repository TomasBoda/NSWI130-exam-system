# Performance
## Scenario 1
### Source
Security Manager
### Stimulus
1000 requests per second
### Artifact
Logger
### Response
All request must be processed for the sake of the security
### Measure
5s downtime
#### Modification to the system
Having one or more backup servers that will start working if the main server is overloaded with requests
