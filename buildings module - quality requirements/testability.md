# Testability
## Scenario 1
### Source
Tester
### Stimulus
Sends a requests to the Building Manager.
### Artifact
Building Manager, Statistical Analyzer
### Environment
Building Manager, Statistical Analyzer, Tester manually fetches data from the analyzer using its API(intercepts the raw response to the Dashboard)
### Response
Tester can see the raw data of the response
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
Tester can easily send the request to the public API of the Equipment Manager and can easily see if the equipment was correctly added to the database.
#### Modification to the system
None needed. Request can be easily sent to the API, if the system works correctly the equipment can be easily seen in the database and in case of an error, the logger can be used to find the problem.

