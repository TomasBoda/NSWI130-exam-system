# Decomposition

## First Decomposition
First decomposition into individual modules.

### 1. Auth Service
- provide endpoint for obtaining user credentials (e-mail, password)
- validate user credentials using Validation module
- generate auth-token for validated user

### 2. Notification Service
- provide endpoint for creating a generic notification (title, message, priority, course/students)
- provide extended notification system (e-mail, SMS, ...) apart from standard in-app notifications
- provide a way to adjust notification settings to users
- notify students enrolled in a course about exam date creation, update and deletion
- notify students registered for an exam about new information
- notify specific student registered for an exam about new information

### 3. Rest API
- handle requests from the UI modules (obtaining and manipulating user-related and exam-related data)
- serve requests by communicating with the Database module
- validate requests and data integrity using the Validation module

### 4. Validation
- validate data integrity of Rest API requests from UI module
- validate room availability for exam dates
- validate room capacity for exam dates
- validate exam prerequisities of enrolled students

### 5. Database
- handle generic database manipulation requests
- provide interface for communicating and serving requests from Rest API module
- handle data persistance

### 6. Auth UI
- provide a page for generic user authentication using e-mail and password
- navigate the successfully logged user to corresponding page based on their role and authorization

### 7. Student UI
- provide a profile page for student
- provide a settings page for notification tweaking
- provide a page with a list of courses the student is enrolled in
- provide a page with details about a specific course
- provide a page with a list of exam dates for a given course
- provide a page with details about a specific exam date

### 8. Teacher UI
- provide a profile page for user
- provide a settings page for notification tweaking
- provide a page with list of courses the teacher teaches
- provide a page with details about a specific course, such as list of enrolled students
- provide a page for creating a new exam date
- provide a page for editing an existing exam date
- provide an interface for sending a message to individual or all students registered for an exam date

### 9. Unified UI
- provide a UI that lazy loads Auth UI, Student UI and Teacher UI
- provide app routing between the UI modules

## Second Decomposition
First decomposition into persistence, domain, application and presentation logic.

### 1. Data Persistance
- store and retrieve data to and from the database
- provide interface for generic database queries

### 2. Notifications
- create new notification
- send notification to selected users or group of users
- adjust notification settings (student & teacher)
- trigger e-mail and SMS notifications

### 3. Data Requests
- authenticate based on user credentials
- serve notification requests (create, send, modify)
- retrive on-demand data (courses, exams, students, notifications)
- validate data integrity

### 4. User Interface
- authentication interface as application's entry point
- individual pages for student interface
- individual pages for teacher interface
- unified UI loading all UI modules together into one usable interface