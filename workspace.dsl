workspace "ExamSystem Workspace" "This workspace documents the architecture of the ExamSystem system which enables managing of exams, signing up on the exams and communication between students and teachers." {

    model {
        student = person "Student" "Signs up for exams"
        teacher = person "Teacher" "Creates and manages exams"

        exam_system = softwareSystem "Exam System" "Provides exam management and communication" {
            ui = container "User Interface" "Provides user interface" {
                // UI for authentication
                auth_ui = component "Auth UI" "User interface for user authentication"
                // UI for students
                student_ui = component "Student UI" "User interface for students"
                // UI for teachers
                teacher_ui = component "Teacher UI" "User interface for teachers"
            }

            api_gateway = container "API Gateway" "Provides Rest API endpoints" "" "BackEnd" {
                // handles requests from UI
                request_controller = component "Request Handler" "Handles API requests"
                // routes requests from UI to Rest API
                routing_controller = component "Routing Controller" "Handles API endpoint routing"
                // handles real-time messaging using WebSocket
                web_socket_controller = component "WebSocket" "Provides WebSocket for real-time message handling"
            }

            rest_api = container "Rest API" "Handles Rest API endpoints" {
                // provides interface to query the database
                database_query_interface = component "Database Query Interface" "Handles database queries"
                // validates the integrity of data provided to database
                validator = component "Data Validator" "Provides data validation and integrity"

                // handles exam API requests
                exam_controller = component "Exam Controller" "Handles exam-related requests" {
                    tags "Controller"
                }
                // handles grade API requests
                grade_controller = component "Grade Controller" "Handles grade-related requests" {
                    tags "Controller"
                }
            } 

            notification_service = container "Notification Service" "Provides notification management" {
                tags "Service"

                // handles manual notification requests from UI (teacher wants to manually send a message)
                notification_request_handler = component "Request Handler" "Handles notification requests"
                // listens to database changes for notification sending
                database_listener = component "Database Listener" "Listens to database data changes"
                // handles notifications (processing, model)
                notification_handler = component "Notification Handler" "Handles notifications"
                // emits the notification to e.g. e-mail, SMS, ...
                notification_emitter = component "Notification Emitter" "Emits notification"
            }

            message_service = container "Message Service" "Provides student-teacher communication"{
                tags "Service"

                // handles message API requests
                message_request_handler = component "Request Handler" "Handles message requests"
                // emits the message to WebSocket provided in API Gateway
                message_emitter = component "Message Emitter" "Emits message"
            }

            database = container "Database" "Provides data persistence" {
                tags "Database"
            }

            message_database = container "Message Database" "Provides message history persistance" {
                tags "Database"
            }
        }

        auth_service = softwareSystem "Auth Service" "Handles user authentication and authorization" {
            tags "External"

            authentication_service = container "Authentication Service" "Provides user authentication" {
                register_controller = component "Register Controller" "Handles user registration"
                login_controller = component "Login Controller" "Handles user login"
            }
            authorization_service = container "Authorization Service" "Handles user authorization"
            auth_database = container "Auth Database" "Provides auth data persistance" {
                tags "Database"
            }
        }

        // Actors
        student -> exam_system "Signs up for exams"
        student -> exam_system "Sends messages to teachers"

        teacher -> exam_system "Manages exams"
        teacher -> exam_system "Sends exam results to students"
        teacher -> exam_system "Sends messages to students"

        // API Gateway
        request_controller -> routing_controller "Transmits API requests"
        routing_controller -> rest_api "Transmits routed API requests to corresponding controllers"
        routing_controller -> auth_service "Trasmits auth-related requests"
        routing_controller -> exam_controller "Transmits exam-related requests"
        routing_controller -> grade_controller "Transmits grade-related requests"
        routing_controller -> notification_service "Transmits notification-related requests"
        routing_controller -> message_service "Transmits message-related requests"

        // Rest API
        rest_api -> request_controller "Sends processed data"

        auth_service -> routing_controller "Sends back auth-related data"

        exam_controller -> database_query_interface "Sends exam-related queries"
        database_query_interface -> exam_controller "Sends exam-related data"
        exam_controller -> request_controller "Sends exam-related data"

        grade_controller -> database_query_interface "Sends grade-related queries"
        database_query_interface -> grade_controller "Sends grade-related data"
        grade_controller -> request_controller "Sends grade-related data"

        api_gateway -> notification_request_handler "Transmits notification-related requests"

        api_gateway -> message_request_handler "Transmits message-related requests"
        web_socket_controller -> message_service "Sends data to the WebSocket"

        database_query_interface -> database "Sends queries"
        database -> database_query_interface "Sends queried data"

        database_query_interface -> validator "Sends data for validation"
        validator -> database_query_interface "Sends validated data"

        // User Interface
        ui -> request_controller "Sends requests for data"
        request_controller -> ui "Sends requested data"

        auth_ui -> student_ui "Navigates user of type 'Student' to Student UI"
        auth_ui -> teacher_ui "Navigates user of type 'Teacher' to Teacher UI"

        auth_ui -> request_controller "Sends auth requests"
        request_controller -> auth_ui -> "Sends auth-related data"

        student_ui -> request_controller "Sends data requests"
        request_controller -> student_ui "Sends requested data"

        teacher_ui -> request_controller "Sends data requests"
        request_controller -> teacher_ui "Sends requested data"

        student_ui -> web_socket_controller "Subscribes to messages via WebSocket"
        teacher_ui -> web_socket_controller "Subscribes to messages via WebSocket"
        web_socket_controller -> student_ui "Sends message data"
        web_socket_controller -> teacher_ui "Sends message data"

        student_ui -> api_gateway "Subscribes to messages via WebSocket"
        teacher_ui -> api_gateway "Subscribes to messages via WebSocket"
        api_gateway -> student_ui "Sends message data"
        api_gateway -> teacher_ui "Sends message data"

        // Notification Service
        database_listener -> database "Subscribes to database data changes"
        database -> database_listener "Emits data change logs"

        notification_request_handler -> notification_handler "Transmits notification data"
        database_listener -> notification_handler "Transmits notification data"

        notification_handler -> database "Sends notification data"
        notification_handler -> notification_emitter "Sends prepared notification item"

        // Message Service
        message_request_handler -> message_database "Sends message data"
        message_database -> message_request_handler "Sends back message data"
        message_request_handler -> message_emitter "Emits messages"
        message_emitter -> web_socket_controller "Sends message items to the Web Socket"

        live = deploymentEnvironment "Live" {
            deploymentNode "Client Computer" {
                deploymentNode "Web Browser" {
                    spa = infrastructureNode "Single Page Application" {
                        description "Provides exam system functionality via web browser"
                    }
                }
            }

            deploymentNode "Whole architecture" {
                
                deploymentNode "Backend Server" {
                    lbNode = infrastructureNode "Load Balancer" {
                        description "Balances incoming calls"
                    }

                    apiNode = infrastructureNode "Rest API Infrastructure" {
                        description "Provides Rest API endpoints"
                    }

                    deploymentNode "Database Enviroment" {
                        databaseNode = infrastructureNode "Database" {
                            tags "Database"
                            description "Provides data persistence"
                        }

                        messageDatabaseNode = infrastructureNode "Message Database" {
                            tags "Database"
                            description "Provides message history persistence"
                        }
                    }
                }

                deploymentNode "Service Infrastructure" {
                    notificationNode = infrastructureNode "Notification Service" {
                        description "Provides notification handler"
                    }

                    messageNode = infrastructureNode "Message Service" {
                        description "Provides message handler"
                    }
                }

                deploymentNode "Auth Server" {
                    authNode = infrastructureNode "Auth Service" {
                        description "Provides authentication and authorization functionality"
                    }
                }	
            }

            apiNode -> authNode "Sends auth requests"
            authNode -> apiNode "Sends back auth data"

            spa -> lbNode "Calls API requests"
            apiNode -> spa "Sends back requested data"
            lbNode -> apiNode "Forwards API requests"

            apiNode -> databaseNode "Sends data to persist"
            apiNode -> messageDatabaseNode "Sends message history"

            databaseNode -> apiNode "Sends back requested data"
            messageDatabaseNode -> apiNode "Sends back message data"

            apiNode -> notificationNode "Request notification"
            notificationNode -> databaseNode "Subscribe to data changes"

            messageNode -> messageDatabaseNode "Store message data"
            messageDatabaseNode -> messageNode "Send back message history"
        }
    }

    views {
        systemContext exam_system "examSystemSystemContextDiagram" {
            include *
            autoLayout lr
        }

        container exam_system "examSystemContainerDiagram" {
            include *
        }

        component api_gateway "examSystemApiGatewayDiagram" {
            include *
        }

        component rest_api "examSystemRestApiDiagram" {
            include *
        }

        component ui "examSystemUiDiagram" {
            include *
        }

        component notification_service "examSystemNotificationServiceDiagram" {
            include *
            autoLayout lr
        }

        component message_service "examSystemMessageServiceDiagram" {
            include *
            autoLayout lr
        }

        deployment exam_system "Live" "AmazonWebServicesDeployment" {
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
            
            element "Component" {
                background #c4c4c4
                color #000000
            }

            element "Service" {
                background #d4655d
            }
            element "Database" {
                shape Cylinder
                background #30469c
                color #ffffff
            }
            element "Controller" {
                background  #57b586
            }
            element "External" {
                background  #636363
            }
        }
    }
}
