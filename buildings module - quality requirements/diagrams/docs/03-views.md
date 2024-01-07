## Views

### How are the views documented?

The software architecture of BuildingsModule is further documented according to the [C4 model](https://c4model.com/) using its 2 levels - [container](https://c4model.com/#ContainerDiagram) level and [component](https://c4model.com/#ComponentDiagram) level.
The documentation also uses supplementary diagrams - [deployment diagrams](https://c4model.com/#DeploymentDiagram) and [dynamic diagrams](https://c4model.com/#DynamicDiagram).


### Buildings Module decomposition view

All users access the system through the Dashboard, where they are required to log in, being authorized by the Security Manager, before they may access its functionality.
If a teacher chooses to request or modify their room reservation, the request is sent to the Buildings Manager, which handles the related business logic. The result
is then displayed to the user via the Dashboard.
If a teacher chooses to report faulty equipment, the request is sent to the Equipment Manager, which handles the related business logic and notifies maintenance staff
about the issue.

If a maintenance staff member chooses to add or modify a building or a room within a building, the request is sent to the Buildings Manager, which handles the related
business logic. The result is then displayed to the user via the Dashboard.
If a maintenance staff member chooses to add or modify equipment within a room, the request is sent to the Equipment Manager, which handles the related business logic.
The result is then displayed to the user via the Dashboard.
If a maintenance staff member chooses to view statistics, the request is sent to the Statistical Analyzer, which handles the related business logic. The result is then
displayed to the user via the Dashboard.

If either user chooses to view building or room data, the request is sent to the Buildings Manager, which handles the related business logic. The result is then
displayed to the user via the Dashboard.
If either user chooses to view equipment data, the request is sent to the Equipment Manager, which handles the related business logic. The result is then displayed to
the user via the Dashboard.

The Buildings Manager, the Equipment Manager and Security Manager communicate with the Database, persisting and retrieving data.

All of this activity is logged by the Logger, which stores the logs in a database.

Furthermore, the Dashboard, Buildings Manager, Equipment Manager and Security Manager send their data to the Statistical Analyzer for analysis.

![](embed:ContainerView)

### Buildings Manager decomposition view

The Buildings Manager is responsible for handling all requests related to buildings and rooms within buildings. It is accessed by maintenance staff members and teachers.

The Building Viewer prepares data about buildings and rooms within buildings for the Dashboard. It is accessed by maintenance staff members and teachers.

The Building Editor, when accessed by a maintenance staff member, allows for adding/editing room and building data. These requests are sent to the Buildings Database Manager, where they are validated and processed. This means that queries will be applied to the Database. Then, information will be fetched about the process and sent back to the Building Editor, which will send the data to the Building Viewer, which will make the data displayable for the Dashboard

The Room Reserver, when accessed by a teacher, allows for reserving a room for a time period or viewing the reservation state of the room. This also sends requests to the Buildings Database Manager, where they are correctly handled (validated and processed). This means that queries will be applied to the Database. Then, information will be fetched about the process and sent back to the Room Reserver, which will make the data displayable for the dashboard.

The Public API is the mediator between the Dashboard and the Buildings Manager. It is responsible for handling requests from the Dashboard and sending them to the correct Component.

Its internal architecture corresponds to its use cases and their processes.

#### Teacher use case
The teacher can reserve a room or view the reservation state of a room:
* The teacher's request is sent to the Public API, which forwards it to the Room Reserver.
* The Room Reserver requests data via the Database Manager.
* The Room Reserver provides available rooms.
* The Room Reserver sends the request to the Database Manager.

#### Maintenance staff use case
The maintenance staff can add or modify a building or a room:
* The maintenance staff's request is sent to the Public API, which forwards it to the Building Editor.
* The Building Editor requests data via the Database Manager.
* The Building Editor provides available buildings and rooms.
* The Building Editor sends the request to the Database Manager.

#### Common use case
The user can view a building or room:
* The user's request is sent to the Public API, which forwards it to the Building Viewer.
* The Building Viewer requests data via the Database Manager.
* The Building Viewer provides available buildings and rooms.

In any case, the user is updated about the process via the Dashboard, the data is sent to the Statistical Analyzer for analysis and the process is logged by the Logger.

![](embed:BuildingManagerComponentView)

### Equipment manager decomposition view

The Equipment Manager is responsible for handling all requests related to equipment. It is accessed by maintenance staff members and teachers.

The Equipment Viewer prepares data about equipment for displaying in the Dashboard. It is accessed by maintenance staff members and teachers.

The Equipment Editor, when accessed by a maintenance staff member, allows for adding/modifying equipment data. These requests are sent to the Equipment Database Manager, where they are validated and processed. This means that queries will be applied to the Database. Then, information will be fetched about the process and sent back to the Equipment Editor, which will send the data to the Equipment Viewer, which will make the data displayable for the dashboard.

The Equipment Fault Notifier, when accessed by a teacher, allows for reporting equipment states - especially faults with the equipment. The requests are sent to the Equipment Database Manager, where they are properly handled. The information sent back from the database is then collected by the Equipment Fault Notifier, which will then notify maintenance staff members via e-mail/SMS or directly to the Dashboard.

The Public API is the mediator between the Dashboard and the Equipment Manager. It is responsible for handling requests from the Dashboard and sending them to the correct Component.

Its internal architecture corresponds to its use cases and their processes.

#### Teacher use case
The teacher can report a fault with the equipment:
* The teacher's request is sent to the Public API, which forwards it to the Equipment Fault Notifier.
* The Equipment Fault Notifier requests data via the Database Manager.
* The Equipment Fault Notifier provides available equipment.
* The Equipment Fault Notifier sends the request to the Database Manager.

#### Maintenance staff use case
The maintenance staff can add or modify equipment:
* The maintenance staff's request is sent to the Public API, which forwards it to the Equipment Editor.
* The Equipment Editor requests data via the Database Manager.
* The Equipment Editor provides available equipment.
* The Equipment Editor sends the request to the Database Manager.

#### Common use case
The user can view equipment:
* The user's request is sent to the Public API, which forwards it to the Equipment Viewer.
* The Equipment Viewer requests data via the Database Manager.
* The Equipment Viewer provides available equipment.

In any case, the user is updated about the process via the Dashboard, the data is sent to the Statistical Analyzer for analysis and the process is logged by the Logger.

![](embed:EquipmentManagerComponentView)

### Security manager decomposition view

The Security Manager is responsible for handling all requests related to user authentication. The Dashboard requests authentication of a user via the Public API. This request is sent to the Authenticator which in turn sends the request to the Authentizator, which requests user rights from the User Database Manager which fetches the data from the Database. The Authorizator is responsible for authorizing users.

![](embed:SecurityManagerComponentView)

### Logger decomposition view

The Logger is responsible for logging the user's requests. The Logger is notified by the Dashboard, the Buildings Manager, the Equipment Manager and the Security Manager about the user's actions. More specifically, the Event Sniffer is notified and then sends the data to the Event Logger, which stores the data in the Database for persistence.

Logger does NOT log database events - that is managed by the database itself.

![](embed:LoggerComponentView)

### Dashboard decomposition view

The Dashboard is responsible for displaying data to the user. It is accessed by teachers and maintenance staff members. When the user requests to view or modify any data, The correct Container is called and the data is displayed to the user. The Dashboard also sends the data to the Statistical Analyzer for analysis and the Logger for logging.

![](embed:DashboardComponentView)