workspace "ExamSystem Workspace" "This workspace documents the architecture of the ExamSystem system which enables managing of exams, signing up on the exams and communication between students and teachers." {

    model {
        student = person "Student" "Signs up for exams"
        teacher = person "Teacher" "Creates and manages exams"

        exam_system = softwareSystem "Exam System" "Provides exam management and communication" {
            ui = container "User Interface" "Provides user interface" "" "FrontEnd" {
                // UI for authentication
                auth_ui = component "Auth UI" "User interface for user authentication"
                // UI for students
                student_ui = component "Student UI" "User interface for students"
                // UI for teachers
                teacher_ui = component "Teacher UI" "User interface for teachers"
            }

            api_gateway = container "API Gateway" "Provides Rest API endpoints" "" "BackEnd" {
                // handles requests from UI
                request_controller = component "Request Handler" "Handles API requests" "" "RequestController"
                // routes requests from UI to Rest API
                routing_controller = component "Routing Controller" "Handles API endpoint routing" "" "RoutingController"
                // handles real-time messaging using WebSocket
                web_socket_controller = component "WebSocket" "Provides WebSocket for real-time message handling" "" "WebSocketController"
            }

            rest_api = container "Rest API" "Handles Rest API endpoints" "" "RestAPI" {
                // provides interface to query the database
                database_query_interface = component "Database Query Interface" "Handles database queries"
                // validates the integrity of data provided to database
                validator = component "Data Validator" "Provides data validation and integrity"

                // handles auth API requests
                auth_controller = component "Auth Controller" "Handles user authentication" "" "AuthController"
                // handles exam API requests
                exam_controller = component "Exam Controller" "Handles exam-related requests" "" "ExamController"
                // handles grade API requests
                grade_controller = component "Grade Controller" "Handles grade-related requests" "" "GradeController"
                // handles notification API requests
                notification_controller = component "Notification Controller" "Handles notification-related requests" "" "NotificationController"
                // handles message API requests
                message_controller = component "Message Controller" "Handles message-related requests" "" "MessageController"
            } 

            notification_service = container "Notification Service" "Provides notification management" "" "NotificationService" {
                // handles manual notification requests from UI (teacher wants to manually send a message)
                notification_request_handler = component "Request Handler" "Handles notification requests"
                // listens to database changes for notification sending
                database_listener = component "Database Listener" "Listens to database data changes"
                // handles notifications (processing, model)
                notification_handler = component "Notification Handler" "Handles notifications"
                // emits the notification to e.g. e-mail, SMS, ...
                notification_emitter = component "Notification Emitter" "Emits notification"
            }

            message_service = container "Message Service" "Provides student-teacher communication" "" "MessageService" {
                // handles message API requests
                message_request_handler = component "Request Handler" "Handles message requests"
                // emits the message to WebSocket provided in API Gateway
                message_emitter = component "Message Emitter" "Emits message"
            }

            database = container "Database" "Provides data persistence" "" "Database" {
                
            }
        }

        auth_service = softwareSystem "Auth Service" "Handles user authentication and authorization" {
            authentication_service = container "Authentication Service" "Provides user authentication" {
                register_controller = component "Register Controller" "Handles user registration"
                login_controller = component "Login Controller" "Handles user login"
            }
            authorization_service = container "Authorization Service" "Handles user authorization"
            auth_database = container "Auth Database" "Provides auth data persistance" "" "AuthDatabase"
        }

        student -> exam_system "Signs up for exams"
        student -> exam_system "Sends message to teachers"

        teacher -> exam_system "Manages exams"
        teacher -> exam_system "Sends exam results to students"
        teacher -> exam_system "Sends message to students"

        // ----------------------------------------------------------------------

        // API Gateway
        request_controller -> routing_controller "Transmits API requests"
        routing_controller -> rest_api "Transmits routed API requests to corresponding controllers"
        routing_controller -> auth_controller "Transmits auth-related requests"
        routing_controller -> exam_controller "Transmits exam-related requests"
        routing_controller -> grade_controller "Transmits grade-related requests"
        routing_controller -> notification_controller "Transmits notification-related requests"

        // Rest API
        rest_api -> api_gateway "Send back processed data"

        auth_controller -> auth_service "Transmits auth-related requests"
        auth_service -> auth_controller "Sends auth-related data"
        auth_controller -> request_controller "Sends auth-related data"

        exam_controller -> database_query_interface "Sends exam-related data"
        database_query_interface -> exam_controller "Sends exam-related data"
        exam_controller -> request_controller "Sends exam-related data"

        grade_controller -> database_query_interface "Sends grade-related data"
        database_query_interface -> grade_controller "Sends grade-related data"
        grade_controller -> request_controller "Sends grade-related data"

        notification_controller -> notification_request_handler "Transmits notification-related requests"

        message_controller -> message_request_handler "Transmits message-related requests"
        message_controller -> web_socket_controller "Send data to WebSocket"

        database_query_interface -> database "Send request queries"
        database -> database_query_interface "Send queried data"

        database_query_interface -> validator "Send back validated data"
        validator -> database_query_interface "Send data for validation"

        // User Interface
        ui -> request_controller "Send data request"
        request_controller -> ui "Send requested data"

        auth_ui -> student_ui "Navigates user of type 'Student' to Student UI"
        auth_ui -> teacher_ui "Navigates user of type 'Teacher' to Teacher UI"

        auth_ui -> request_controller "Sends auth requests"
        request_controller -> auth_ui -> "Sends back auth-related data"

        student_ui -> request_controller "Sends data requests"
        request_controller -> student_ui "Sends back requested data"

        teacher_ui -> request_controller "Sends data requests"
        request_controller -> teacher_ui "Sends back requested data"

        student_ui -> web_socket_controller "Subscribe to messages via WebSocket"
        teacher_ui -> web_socket_controller "Subscribe to messages via WebSocket"
        web_socket_controller -> student_ui "Sends back message data"
        web_socket_controller -> teacher_ui "Send back message data"

        // Notification Service
        database_listener -> database "Subscribe to database data changes"
        database -> database_listener "Emits data changes logs"

        notification_request_handler -> notification_handler "Transmits notification data"
        database_listener -> notification_handler "Transmits notification data"

        notification_handler -> database "Send notification data"
        notification_handler -> notification_emitter "Send prepared notification item"

        // Message Service
        message_request_handler -> database "Send message data"
        database -> message_request_handler -> "Send back message data"
        message_request_handler -> message_emitter "Emit message"
        message_emitter -> web_socket_controller "Send message item to Web Socket"
    }

    views {
        systemContext exam_system "examSystemSystemContextDiagram" {
            include *
            autoLayout lr
        }

        container exam_system "examSystemContainerDiagram" {
            include *
            autoLayout lr
        }

        component api_gateway "examSystemApiGatewayDiagram" {
            include *
            autoLayout lr
        }

        component rest_api "examSystemRestApiDiagram" {
            include *
            autoLayout lr
        }

        component ui "examSystemUiDiagram" {
            include *
            autoLayout lr
        }

        component notification_service "examSystemNotificationServiceDiagram" {
            include *
            autoLayout lr
        }

        component message_service "examSystemMessageServiceDiagram" {
            include *
            autoLayout lr
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
            element "AuthDatabase" {
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

            element "ExamController" {
                background  #54c48c
            }
            element "GradeController" {
                background  #54c48c
            }
            element "AuthController" {
                background  #54c48c
            }
            element "NotificationController" {
                background  #54c48c
            }
            element "MessageController" {
                background  #54c48c
            }
        }
    }
}
