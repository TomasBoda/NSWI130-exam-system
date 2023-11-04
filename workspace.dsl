workspace "ExamSystem Workspace" "This workspace documents the architecture of the ExamSystem system which enables managing of exams, signing up on the exams and communication between students and teachers." {
    
    model {
        # software systems
        examSystem = softwareSystem "ExamSystem" "Manages exams, signing of students up for them and communication between students and teachers." {
            HTML = container "Exam Web Application Front-end" "Provides funcionality for student Exam registration and exam administration in a web browser. Its internal structure is based on the MVC pattern implemented using React/Redux." "React/Redux" "Web Front-End"

            examWebApp = container "Exam Web Application" "Delivers administration web application front-end to the client's browser."

            adminAPI = container "Exam Application Back-end" "Provides the application logic to administer exams and student's registrations in the system via an API."  {
                    adminRegistrationController = component "Registrations Administration Controller" "Processes requests to manage exam registrations"
                    adminExamController = component "Exam Administration Controller" "Processes requests to manage exams"
                    adminExamModel = component "Exam Model" "Represents Exams and persists them in the database"
                    adminRegistrationModel = component "Registration Model" "Represents Registrations and persists them in the database"
            }

            notifier = container "Notifier" "Sends notifications to students and teachers about exam changes and new messages." "" "Notification Service" {
                notifierController = component "Notifier Controller" "Processes requests to send notifications"
                notifierModel = component "Notifier Model" "Represents notifications and persists them in the database"
            }

            db = container "Exam database" "Stores the exams and student's registrations." "" "Database"
        }

        studentRegister = softwareSystem "StudentRegister" "Stores student's data and provides it to the ExamSystem." "Existing System" {
            studentRegisterAPI = container "StudentRegister API" "Provides student's data to the ExamSystem." "" "API" 
        }

        # actors
        student = person "Student" "Signs up for the exams."
        teacher = person "Teacher" "Creates exams."


        # relationships between users and ExamSystem
        student -> examSystem "Signs up for exams."
        student -> examSystem "Communicates with their examiners."
        
        teacher -> examSystem "Manages exams."
        teacher -> examSystem "Sends messages to the."

        # relationships to/from containers

        examWebApp -> HTML "Delivers to the user's web browser"
        adminExamController -> HTML "Delivers data to"
        adminRegistrationController -> HTML "Delivers data to"

        adminExamController -> adminExamModel "Uses"
        adminRegistrationController -> adminRegistrationModel "Uses"

        adminExamModel -> db "Reads from and writes to exam data"
        adminRegistrationModel -> db "Reads from and writes to exam data"
        adminRegistrationModel -> studentRegisterAPI "Reads student data from"
        

        # relationships to/from components
        HTML -> adminExamController "Makes API calls to"
        HTML -> adminRegistrationController "Makes API calls to"
        adminRegistrationController -> notifierController "Sends notifications to"


        # relationships between external systems and ExamSystem
    }

    views {

        systemContext examSystem "examSystemSystemContextDiagram" {
            include *
            autoLayout lr
        }

        container examSystem "examSystemSystemContainerDiagram" {
            include *
            autoLayout
        }

        component adminAPI "adminAPISystemComponentDiagram" {
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
            element "Existing System" {
                background #999999
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Web Browser" {
                shape WebBrowser
            }
            element "Mobile App" {
                shape MobileDeviceLandscape
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
        }
    }
}
