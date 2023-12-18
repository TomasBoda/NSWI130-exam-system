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
