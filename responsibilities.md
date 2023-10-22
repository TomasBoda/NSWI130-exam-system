# Responsibilities

## 1. Add new exam
As a teacher, I want to add a new exam including the subject, date, room number, capacity etc.

### Story
1. teacher opens their taught courses
2. teacher selects a course for a new exam
3. teacher opens add new exam page
4. teacher fills in the exam information
    - exam date
    - room number
    - capacity
    - prerequisites (credit)
5. teacher saves the new exam
6. the system saves the data to the database
7. the system notifies enrolled students about the new exam

### Responsibilities

#### User Interface
- Provide a page that shows courses the teacher is teaching
- For each course, provide a button that allows too add a new exam for the course
- Provide a page that allows too add the new exam
- On the new exam page, provide a form to fill in the new exam information
- Validate that all required field are filled in
- Provide a button that publishes the form
- In case of error, show a modal with the error information

#### Authentication
- Authenticate the teacher and ensure they have the necessary permissions to create a new exam for the selected course

#### Data validation
- check if exam date is not in the past and is within the exam period
- check if the room number exists and is available for the exam
- check if capacity is valid for the chosen room
- check if the prerequisites make sense for the chosen course

#### Database
- Store the new exam in a database

#### Notifications
- Find all the enrolled students for the selected exam
- Send notification to all students off the selected course about the new exam

#### Conflicts
- Check for any scheduling conflicts with existing exams and try to resolve them or notify the teacher

## 2. Edit existing exam
As a teacher, I want to edit an existing exam

### Story
1. teacher opens one of their exams
2. teacher fills in the new exam information
- exam date
- room number
- capacity
- prerequisites (credit)
5. teacher saves the exam
6. the systems saves the data to the database
7. the system notifies enrolled students about the changed exam data

### Responsibilities

#### Interface 
- system shows correctly all exams so teacher can choose which one he/she wants to edit
- ensure that data are properly projected into screen so the teacher can distiquish between different informations
- user elements will give a notification or any other information that provided data are not valid

#### Data manipulation
- system has to edit data only for selected exam, other exams have to stay unintacked
- ensure that only one person can manipulate with exam data in the same time. This prevents overriding data.
- ensure that the change of value in database will happen only after clicking the save button, not during changing the value.
- database system cannot accept data which are not valid. 
- database system has to properly activate triggers when the data are saved.

#### Information
- implement logic which collects data for notification
- system properly parse information into message and send it to only students registered in the exam

## 3. Send exam results
As a teacher, I want to ensure that exam results and statistics are effectively communicated to the students

### Story
1. teacher navigates to the exam page
2. teacher picks one of the registered exams
3. teacher sees a list of all registered students and their information
4. teacher fills in grades for every registered student
5. teacher saves the data
6. the systems saves the data to the database
7. students are notified about their grades and some basic statistics from the exam

### Responsibilites

#### User Interface and Navigation
- Ensure that the web or application interface provides a clear and intuitive navigation path to the exam page.
- Develop a user interface element, such as a dropdown or list, that allows the teacher to select from registered exams.
- Ensure that the selected exam triggers the retrieval of relevant data from the database
- Ensure that the data is presented in a clear and organized format for the teacher's review
#### Data Input and Processing
- Implement real-time validation to ensure data accuracy
- Create the data input forms and integrate them with the database
- Ensure that the saved data is temporarily stored locally before being sent to the server
- Implement error-handling mechanisms to handle data saving failures
#### Student Notification and Statistics
- Design and implement a notification system that sends messages or alerts to students
- Implement the logic to calculate and present basic statistics from the exam results

## 4. Send message to students registered on an exam
As a teacher, I want to send a message to all students registered on a exam I created so that I can easily communicate new information about the exam to them.

### Story
1. Teacher navigates to the exam page.
2. Teacher opens a `message to all registered students` dialog.
3. Teacher fills in a message form (subject and text of the message).
4. Teacher sends the message.
5. The system deliveres the message into `personal messages` of every registered student.
6. The system notifies students according to their notification settings. 
7. Students with notifications turned on receive the notification.
8. All addressed students can open the message in their `personal messages`.
9. The system shows a confirmation of a succesful delivery.

### Responsibilities

#### Message Modal responsibilities

* **Message Composition and Delivery:**
    * Ensure data validation to prevent malicious or erroneous input.
    * Handle message delivery to personal messages of registered students efficiently.
* **Confirmation Feedback:**
    * Display confirmation messages to the teacher upon successful message delivery.
    * Log and maintain a record of sent messages for auditing and future reference.

#### Personal Messages Responsibilities
* **Data Storage:**
    * Store the content and metadata of the sent message in a secure and structured manner within the database.
* **Message Assignment:**
    * Associate the message with all registered students who are recipients of the message.
    * Ensure the link between students and messages for efficient retrieval.
    * Handle message status, such as marking messages as 'read' or 'unread.'

#### Notification Responsibilities
* **Notification Preferences:**
    * Maintain a record of each student's notification preferences and settings.
    * Provide ways for students to adjust their notification settings.
* **Notification Dispatch:**
    * Schedule and dispatch notifications based on student's preferences, such as email notifications, in-app notifications, or SMS alerts.
    * Handle any delivery failures or exceptions gracefully, providing error handling and retry mechanisms.
    * Monitor students' notification settings and preferences for message delivery.

## 5. Register for an exam
As a student, I want to register for an exam date of a course I am enrolled in.

### Story
1. student **navigates** to the list of courses they are enrolled in
2. student **selects** one of the courses they are enrolled in
3. students **sees** a list of exam dates for the selected course
4. student **selects** one of the exam dates for the selected course
5. student **confirms** the exam date selection

### Responsibilites

#### Frontend: User interface and Navigation
- provide a **page** with the list of courses the student is enrolled in
- provide a **button** that navigates the student to the page with the list of courses they are enrolled in
- provide a **page** with the list of exam dates for a selected course
- provide a **button** for each enrolled course that navigates the student to the page with the list of exam dates for the given course
- provide a **button** for each exam date that registers the student to the exam date
- provide a **modal** for potential error messages to the student

#### Backend: Authentification
- provide a `POST` endpoint for **validating user credentials** and retrieving authentification token to the student

#### Backend: Courses
- provide a `GET` endpoint for **retrieving** an array of **courses** the student is enrolled in
- provide a `GET` endpoint for **retrieving** a specific **course**

#### Backend: Exam dates
- provide a `GET` endpoint for **retrieving** an array of **exam dates** for a given course
- provide a `POST` endpoint for **registering** a student to an **exam date**

#### Backend: Data validation
- allow registering for an exam date only if the student is enrolled in the course
- allow registering for an exam date only if the exam date has not yet fulfilled its capacity

## 6. Unregister from an exam
As a student, I want to unregister from an existing exam

### Story
1. student opens the exam they are registered to
2. student unregisters from the exam
3. the systems saves the data to the database

### Responsibilities
#### Displaying information
- System provides information about all exams the student is enrolled to
- System provides details about the selected exam
#### Bussiness logic
- System deletes student from database of enrolled students after he decides to unregister
- System checks if anyone is in the waiting list and if so, enrolls rhe first student on there to the exam
#### Notification
- System shows a notification that the unregister was successful
- System sends an email and a notification to the student enrolled from the waiting list, if there was such student