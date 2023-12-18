# Modifiability

## Scenario 1
The team is considering adding new functionality to the `Building Manager` module.

### Stimulus
The team is considering adding a new type of buildings into the `Building Manager` module and its corresponding functionality.

### Artifact
The team needs to add the desired business logic to the `Building Manager` module, but the `Database Manager` module needs to be changed as well to handle new types of data in the database.

### Response
Fortunately, both the `Building Manager` and the `Database Manager` are in the same module, since the software system architecture is built upon standalone modules based on their business logic and semantics, so only the part of the team responsible for managing buildings is concerned with this change.

### Measure
Other modules will not be affected by the new functionality in the `Buidling Manager` module. The only thing what would be affected is the UI, but that is only a minor addition which needs to be handled in most cases of new functionalities.

### Modification to the system
The system would only need to modify the appropriate `Building Manager` module and the UI to display the changes.