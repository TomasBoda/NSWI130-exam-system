workspace "Buildings" "This workspace documents the architecture of the Buildings part of Student Information System which is used to manage the school's buildings" {
   model {
      # Software systems
      buildings = softwareSystem "Buildings" "The Buildings software system is responsible for managing the school's buildings, their rooms and equipment." {
         
         # Front-end containers
         dashboard = container "Dashboard" "The UI dashboard for the Buildings system." {
            webUI = component "Web Application UI" "Allows users to manage the school's buildings, rooms and equipment."          
         }

         # Back-end containers
         buildingManager = container "Building Manager" "Handles business logic around buildings and rooms within them, including room reservations." {
            buildingViewer = component "Building Viewer" "Handles building data to be suitable for displaying."
            buildingEditor = component "Building Editor" "Handles building adding/editing and room adding/editing."
            roomReserver = component "Room Reserver" "Handles logic around room reservations."
            buildingManagerDatabaseManager = component "Database Manager" "Fetches and updates data about buildings and rooms in them, validates and sanitizes it."
            buildingManagerAPI = component "Public API" "Provides an API for usage by other containers."
         }

         equipmentManager = container "Equipment Manager" "Handles business logic around equipment, including adding/editing and fault reporting." {
            equipmentViewer = component "Equipment Viewer" "Handles equipment data to be suitable for displaying."
            equipmentEditor = component "Equipment Editor" "Handles equipment adding/editing and fault reporting."
            equipmentFaultNotifier = component "Equipment Fault Notifier" "Equipment Fault Notifier is responsible for notifying the maintenance team about faulty equipment."
            equipmentManagerDatabaseManager = component "Database Manager" "Fetches and updates data about equipment, validates and sanitizes it."
            equipmentManagerAPI = component "Public API" "Provides an API for usage by other containers."
         }
         
         securityManager = container "Security Manager" "Security Manager is responsible for authentication and authorization of users and their actions." {
            authenticator = component "Authenticator" "Authenticator is responsible for authenticating users."
            authorizator = component "Authorizator" "Authorizator is responsible for giving rights to users based on their role in the system."
            userDatabaseManager = component "User Database Manager" "Fetches data about users from the database, validates and sanitizes it."
            securityManagerAPI = component "Public API" "Provides an API for usage by other containers."
         }
         
         statisticalAnalyzer = container "Statistical Analyzer" "Statistical Analyzer is responsible for analyzing the data and providing statistics."
         
         logger = container "Logger" "Logger logs application events and keeps them as persistent data." {
            eventSniffer = component "Event Sniffer" "Watches for events and sends them to the logger."
            eventLogger = component "Event Logger" "Sends event logs to the database."
         }
         
         # database containers
         databaseRouter = container "Database Router" "Database Router is responsible for routing queries to the primary database."
         database = container "Database" "The database is used to store information about buildings, rooms and equipment." "" "Database"
         secondaryDatabase = container "Backup Database" "The database is used to replicate information about buildings, rooms and equipment." "" "Database"
         logDatabase = container "Log Database" "This database is used to store data from the logger." "" "Database"
         
         !docs docs
         
         databaseRouter -> database "Routes queries to the primary database."
         databaseRouter -> secondaryDatabase "Routes queries to the secondary database."
      }
      
      # stakeholders
      teacher = person "Teacher" "A teacher who uses the school's facilities."
      maintenance = person "Maintenance team member" "A maintenance member who manages the school's facilities."
      
      # SystemContext relationships
      ## relationships between users and Buildings system
      teacher -> buildings "Reserves rooms for teaching and examinations, sets room schedules, reports faulty equipment."
      maintenance -> buildings "Manages the buildings, rooms and equipment."
      buildings -> maintenance "Sends notifications about faulty equipment."

      # Container relationships
      ## relationships between containers
      dashboard -> buildingManager "Displays building and room management services, allows user input."
      dashboard -> equipmentManager "Displays equipment management services, allows user input."
      dashboard -> securityManager "Uses security services." "JSON/HTTP"

      dashboard -> logger "Sends UI interaction activity." "JSON/HTTP"
      equipmentManager -> logger "Sends equipment management activity." "JSON/HTTP"
      buildingManager -> logger "Sends building and room management activity." "JSON/HTTP"
      securityManager -> logger "Sends security activity." "JSON/HTTP"
            
      ## relationships between users and containers
      teacher -> dashboard "Interacts with the system through UI."
      maintenance -> dashboard "Interacts with the system through UI."
      equipmentManager -> maintenance "Notifies maintenance member of fault."
      
      # Component relationships
      ## relationships between components
      webUI -> buildingManager "Sends user input to be handled by business logic." "JSON/HTTP"
      webUI -> equipmentManager "Sends user input to be handled by business logic." "JSON/HTTP"
      webUI -> securityManager "Fetches user information from the security manager." "JSON/HTTP"
      webUI -> statisticalAnalyzer "Fetches statistics." "JSON/HTTP"
      webUI -> logger "Logs user activity." "JSON/HTTP"
   
      buildingManagerAPI -> buildingEditor "Accesses functionalities of the editor."
      buildingManagerAPI -> buildingViewer "Accesses functionalities of the viewer."
      buildingManagerAPI -> roomReserver "Accesses functionalities of the room reserver."
      buildingViewer -> buildingManagerDatabaseManager "Fetches data about buildings and rooms in them."
      buildingEditor -> buildingManagerDatabaseManager "Fetches and updates data about buildings and rooms in them."
      roomReserver -> buildingManagerDatabaseManager "Fetches and updates data about room reservations."

      equipmentManagerAPI -> equipmentEditor "Accesses functionalities of the editor."
      equipmentManagerAPI -> equipmentViewer "Accesses functionalities of the viewer."
      equipmentManagerAPI -> equipmentFaultNotifier "Accesses functionalities of the fault notifier."
      equipmentViewer -> equipmentManagerDatabaseManager "Fetches data about equipment."
      equipmentEditor -> equipmentManagerDatabaseManager "Fetches and updates data about equipment."
      equipmentFaultNotifier -> equipmentManagerDatabaseManager "Fetches and updates data about equipment faults."
      equipmentFaultNotifier -> dashboard "Sends notifications about faulty equipment to be displayed." "JSON/HTTP"

      securityManagerAPI -> authenticator "Accesses functionalities of the authenticator."
      authenticator -> userDatabaseManager "Fetches users from the database." "JSON/HTTP"
      authenticator -> authorizator "Sends authorization requests."
      authorizator -> userDatabaseManager "Fetches user rights from the database." "JSON/HTTP"

      buildingManagerDatabaseManager -> databaseRouter "Applies queries on the database and fetches results." "SQL/TCP"
      buildingManagerDatabaseManager -> statisticalAnalyzer "Sends data for statistical analysis." "JSON/HTTP"
      buildingManager -> eventSniffer "Sends events to the logger." "JSON/HTTP"
      
      equipmentManagerDatabaseManager -> databaseRouter "Applies queries on the database and fetches results." "SQL/TCP"
      equipmentManagerDatabaseManager -> statisticalAnalyzer "Sends data for statistical analysis." "JSON/HTTP"
      equipmentManager -> eventSniffer "Sends events to the logger." "JSON/HTTP"

      userDatabaseManager -> databaseRouter "Applies queries on the database and fetches results." "SQL/TCP"
      userDatabaseManager -> statisticalAnalyzer "Sends data for statistical analysis." "JSON/HTTP"
      securityManager -> eventSniffer "Sends events to the logger." "JSON/HTTP"
      
      statisticalAnalyzer -> dashboard "Sends statistics to be displayed." "JSON/HTTP"

      eventSniffer -> eventLogger "Sends events to be logged." "JSON/HTTP"
      eventLogger -> logDatabase "Sends logs to be stored in the database." "SQL/TCP"

      secondaryDatabase -> database "Replicates data from the primary database." "SQL/TCP"
   

      # Deployment environment
      deploymentEnvironment "Production"    {
            deploymentNode "User's web browser" "" "HTML 5"    {
               dashboardInstance = containerInstance dashboard
            }
            deploymentNode "Buildings module" "" ""   {
               deploymentNode "Application Server" "" "SUSE Linux Enterprise 15"   {
                  deploymentNode "Web server" "" "Apache Tomcat 10.1.15"  {
                     equipmentManagerInstance = containerInstance equipmentManager
                     buildingManagerInstance = containerInstance buildingManager
                  }
                  deploymentNode "Security server" "" "Apache Tomcat 10.1.15"  {
                     securityManagerInstance = containerInstance securityManager
                  }
                  deploymentNode "Statistical Server" "" "SUSE Linux Enterprise 15"   {
                     statisticalAnalyzerInstance = containerInstance statisticalAnalyzer
                  }

                  deploymentNode "Logger Server" "" "SUSE Linux Enterprise 15" {
                     loggerInstance = containerInstance logger
                  }

               }

               deploymentNode "Datacenter"  {
                  deploymentNode "DatabaseRouter" "" "SUSE Linux Enterprise 15" {
                     routerInstance = containerInstance databaseRouter
                  }
                  deploymentNode "Database Server - 01" "" "SUSE Linux Enterprise 15"   {
                     deploymentNode "Relational DB server - primary" "" "Oracle 19.1.0" {
                        databaseInstance = containerInstance database
                     }
                     deploymentNode "Log storage" "" "Elasticsearch 7.13"  {
                        loggerDatabaseInstance = containerInstance logDatabase
                     }
                  }

                  deploymentNode "Database Server - 02" "" "SUSE Linux Enterprise 15"   {
                     deploymentNode "Relational DB server - secondary" "" "Oracle 19.1.0" {
                        secondaryDatabaseInstance = containerInstance secondaryDatabase
                     }
                  }
               }
            }
        }
   }
   
   views {

      systemContext buildings "SystemContextView" {
         include *
         autoLayout
      }

      container buildings "ContainerView" {
         include *
         autoLayout
      }

      component dashboard "DashboardComponentView" {
         include *
         autoLayout
      }
      
      component buildingManager "BuildingManagerComponentView" {
         include *
         autoLayout
      }

      component equipmentManager "EquipmentManagerComponentView" {
         include *
         autoLayout
      }

      component securityManager "SecurityManagerComponentView" {
         include *
         autoLayout
      }
      
      component logger "LoggerComponentView" {
         include *
         autoLayout
      }

      deployment buildings "Production" "DeploymentView" {
         include *
         autoLayout
      }

      dynamic buildings "RegisteringAndEditingRoomsAndBuildings" {
         maintenance -> dashboard "Maintenance member registers a new building"
         dashboard -> logger "UI interaction activity is logged"
         dashboard -> buildingManager "Information about the building is sent to the building manager"
         buildingManager -> logger "Building and room management adding/editing activity is logged"
         buildingManager -> databaseRouter "Additions made are saved in the database"
         
         autoLayout
      }

      dynamic buildings "FaultEvidenceAndReporting" {
         teacher -> dashboard "Teacher reports faulty equipment"
         dashboard -> equipmentManager "Information about the fault is sent to the equipment manager"
         equipmentManager -> logger "Equipment activity is logged"
         equipmentManager -> databaseRouter "Updates made by the user are saved in the database"
         equipmentManager -> dashboard "Faulty equipment is reported to maintenance"
         maintenance -> dashboard "Maintenance member views what equipment needs to be fixed"
         
         autoLayout
      }

      dynamic buildings "RoomReservations" {
         teacher -> dashboard "Teacher reserves a room"
         dashboard -> buildingManager "Information about the reservation is sent to the room reserver"
         dashboard -> logger "UI interaction activity is logged"
         buildingManager -> logger "Room management activity is logged"
         buildingManager -> databaseRouter "Room reservations made are saved in the database"
         
         autoLayout
      }

      dynamic buildings "StatisticalReports" {         
         dashboard -> statisticalAnalyzer "User selects which kind of statistics to view"
         statisticalAnalyzer -> dashboard "Analyzer computes statistics and sends them to the dashboard"
         buildingManager -> statisticalAnalyzer "Analyzer fetches data from the database"
         equipmentManager -> statisticalAnalyzer "Analyzer fetches data from the database"
         securityManager -> statisticalAnalyzer "Analyzer fetches data from the database"
         dashboard -> logger "UI interaction activity is logged (e.g. most viewed building)"
         
         autoLayout
      }


      dynamic buildings "LoginSystemRightsDifferentiation" {       
         teacher -> dashboard "Teacher logs in"
         maintenance -> dashboard "Maintenance logs in"
         dashboard -> logger "UI interaction activity is logged"
         dashboard -> securityManager "Dashboard sends login request"
         securityManager -> dashboard "Dashboard receives user information"
         securityManager -> logger "Security activity is logged"

         autoLayout
      }

      theme default

      styles {
         element "Software System" {
            background #32cd32
            color #ffffff
         }
         
         element "Database"  {
            shape Cylinder
            background #808080
         }

         element "Container" {
            background #63cd32
            color #ffffff
         }

         element "Component" {
            background #92cd32
            color #ffffff
         }
         
         element "Existing System" {
            background #999999
            color #ffffff
         }

         element "Web Front-End"  {
            shape WebBrowser
         }

         element "Infrastructure"  {
            shape Pipe
         }

         element "Logic"  {
            shape Component
         }

         element "Model"  {
            shape RoundedBox
         }

         element "Person" {
            shape Person
         }

         element "Public" {
            background #999999
            color #ffffff
         }

         element "Gov" {
            background #006400
            color #ffffff
         }
      }
   }
}