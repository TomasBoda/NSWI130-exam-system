# Modifiability

## Scenario 1
### Source
Developer of the system
### Stimulus
Add new attribute to the building model
### Artifact
Building Manager
### Response
The database schema is modified, Building Editor and Building Viewer is extended by the new attribute and corresponding functionality is implemented
### Measure
3 man-days to implement

## Scenario 2
### Source
Developer of the system
### Stimulus
Add new user role
### Artifact
Security Manager, Building Manager, Equipment Manager
### Response
The database schema is modified, the Security Manager is extended by the new user role and the Building Manager and Equipment Manager containers are extended by the new authorization rules for data request restrictions
### Measure
8 man-days to implement

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
With an average latency of 1 sec
#### Modification to the system
Having one or more backup servers that will start working if the main server is overloaded with requests

## Scenario 2
### Source
Building Manager
### Stimulus
100 requests per second
### Artifact
Logger
### Response
All request must be processed
### Measure
With an average latency of 0.5 sec

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


# Testability
## Scenario 1
We want to test if the statistical analyzer correctly calculates the statistics.
### Source
Tester
### Stimulus
Sends requests to the Building Manager with some data.
### Artifact
Building Manager, Statistical Analyzer
### Environment
Building Manager, Statistical Analyzer, Tester manually fetches data from the analyzer using its API (intercepts the raw response to the Dashboard)
### Response
Tester can see the raw data from the intercepted response.
### Measure
Since Building Manager provides an API, it should be easy to send the requests. Tester can easily compare the expected output with the actual output.
Any mistake in the system can be easily found if tester has correctly prepared data. Analyzer is dependent on the manager to provide the data.
#### Modification to the system
Provide API for the Analyzer to better input the data -> better testability and easier extendability.

## Scenario 2
### Source
Tester
### Stimulus
Sends a request to add new equipment to the Equipment Manager.
### Artifact
Equipment Manager, Database
### Environment
Equipment Manager, Database, Logger
### Response
Tester can see the equipment in the database or in case of an error, the logger can be used to find the problem.
### Measure
Tester can easily send the request to the public API of the Equipment Manager and can easily see if the equipment was correctly added to the database. Error should be quite easily findable using the logger.
#### Modification to the system
None needed. Request can be easily sent to the API, if the system works correctly the equipment can be easily seen in the database and in case of an error, the logger can be used to find the problem.


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
