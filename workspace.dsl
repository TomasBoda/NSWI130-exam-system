workspace "ExamSystem Workspace" "This workspace documents the architecture of the ExamSystem system which enables managing of exams, signing up on the exams and communication between students and teachers." {

    model {
        student = person "Student" "Signs up for exams"
        teacher = person "Teacher" "Creates and manages exams"

        examSystem = softwareSystem "ExamSystem" "Manages exams, registering students to exams and communication between students and teachers." {
            webAppFrontEnd = container "Web App Front-end" "Provides user interface to authenticated users" "" "FrontEnd" {
                authUI = component "Auth UI" "User interface for user authentication"
                studentUI = component "Student UI" "User interface for students"
                teacherUI = component "Teacher UI" "User interface for teachers"
            }

            restAPI = container "Rest API" "Provides RestAPI endpoints for exam management" "" "BackEnd" {
                requestController = component "Request Handler" "Handles API requests" "" "RequestController"
                routingController = component "Routing Controller" "Manage endpoint routing" "" "RoutingController"
                examController = component "Exam Controller" "Retrieves and manipulates exam data"
                gradeController = component "Grade Controller" "Manipulates exam grades"
            }

            notificationService = container "Notification Service" "Provides endpoints for notification management" "" "NotificationService" {
                userNotificationManager = component "User Notification Manager UI" "Provides the user with the ability to set user settings and create notifications"
                notificationController = component "Notification Controller" "Handles the notifications bussiness logic"
                notificationHandler = component "Notification Handler" "Sends the notification messages and emails"
            }

            messageService = container "Message Service" "Provides endpoints for student-teacher communication" "" "MessageService" {
                
            }

            database = container "Exam Database" "Stores exams, exam registrations and messages" "" "Database" {
                
            }

            validator = container "Validator" "Validates data" "" "Validator" {

            }
        }

        authenticationAPI = softwareSystem "Authentication API" "Manages users (students, teacher) and their login credentials for authentication to the exam system" {
            authenticationContainer = container "Authentication container" "Authenticates users" {
                registrationAPI = component "Registration API" "Registers users (student, teacher)"
                loginAPI = component "Login API" "Validates user credentials and generates auth token"
            }
            authorizationContainer = container "Authorization container" "Authorizes users"
        }

        student -> examSystem "Signs up for exams"
        student -> examSystem "Communicates with examiners"

        teacher -> examSystem "Creates, updates and removes exams"
        teacher -> examSystem "Sends exam results to students"
        teacher -> examSystem "Communicates with registered students"
        teacher -> examSystem "Sends exam information to registered students"

        webAppFrontEnd -> restAPI "Send request for data retrieval"
        webAppFrontEnd -> restAPI "Send request for data manipulation"

        webAppFrontEnd -> notificationService "Send notification to registered students"
        webAppFrontEnd -> messageService "Send message to specific user"

        restAPI -> webAppFrontEnd "Provide data to users"
        restAPI -> webAppFrontEnd "Provide data manipulation endpoints"

        database -> restAPI "Provide data to back-end on demand"

        messageService -> database "Store messages to database"
        notificationService -> database "Store notifications to database"

        webAppFrontEnd -> validator "Validate outgoing data"
        restAPI -> validator "Validate incoming data"

        authUI -> studentUI "Navigates user of type 'Student' to Student UI"
        authUI -> teacherUI "Navigates user of type 'Teacher' to Teacher UI"

        restAPI -> studentUI "Provide student data"
        restAPI -> teacherUI "Provide teacher data"
        authenticationAPI -> authUI "Provide authentication requests"

        requestController -> routingController "Send incoming requests to router"
        routingController -> examController "Route incoming exam manipulation requests"
        routingController -> gradeController "Route incoming grade manipulation requests"
        examController -> requestController "Send handled requests back to handler"
        gradeController -> requestController "Send handled requests back to handler"

        database -> examController "Provide exam-related data"
        database -> gradeController "Provide grade-related data"
        examController -> database "Store exam-related data"
        gradeController -> database "Store grade-related data"

        webAppFrontEnd -> requestController "Send requests for data retrieval and manipulation"
        
        notificationController -> notificationHandler "Uses for actual sending of notifications"
        userNotificationManager -> notificationController "Sets up the settings for its behavior, uses for sending new messages"
    }

    views {
        systemContext examSystem "examSystemSystemContextDiagram" {
            include *
        }

        container examSystem "examSystemSystemContainerDiagram" {
            include *
        }

        component webAppFrontEnd "examSystemWebAppFrontEndDiagram" {
            include *
        }

        component restAPI "examSystemWebAppBackEndDiagram" {
            include *
        }
        component notificationService "examSystemNotifierDiagram"{
            include *
        }

        styles {
            element "Person" {
                color #08427b
                fontSize 22
                shape Person
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Database" {
                shape Cylinder
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
            element "Failover" {
                opacity 25
            }

            element "RequestController" {
                background #c4c4c4
            }
            element "RoutingController" {
                background #c4c4c4
            }
            element "NotificationService" {
                background #ff8766
            }
            element "MessageService" {
                background #ff8766
            }
        }
    }
}
