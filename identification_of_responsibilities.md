# Exam System

## Core features and responsibilities

<!-- A ### section for each feature -->
### Feature: Sending message to all students registered on an exam 

<!-- The feature described in a form of a user story -->
As a teacher, I want to send a message to all students registered on a exam I created so that I can easily communicate new information about the exam to them.

#### Feature breakdown

<!-- The feature breakdown -->
1. Teacher navigates to the exam page.
2. Teacher opens a `message to all registered students` dialog.
3. Teacher fills in a message form (subject and text of the message).
4. Teacher sends the message.
5. The system deliveres the message into `personal messages` of every registered student.
6. The system notifies students according to their notification settings. 
7. Students with notifications turned on receive the notification.
8. All addressed students can open the message in their `personal messages`.
9. The system shows a confirmation of a succesful delivery.

#### Responsibilities

<!-- A ##### section for each group of responsibilities -->

##### Message Modal responsibilities

* **Message Composition and Delivery:**
    * Ensure data validation to prevent malicious or erroneous input.
    * Handle message delivery to personal messages of registered students efficiently.
* **Confirmation Feedback:**
    * Display confirmation messages to the teacher upon successful message delivery.
    * Log and maintain a record of sent messages for auditing and future reference.

##### Personal Messages Responsibilities
* **Data Storage:**
    * Store the content and metadata of the sent message in a secure and structured manner within the database.
* **Message Assignment:**
    * Associate the message with all registered students who are recipients of the message.
    * Ensure the link between students and messages for efficient retrieval.
    * Handle message status, such as marking messages as 'read' or 'unread.'

##### Notification Responsibilities
* **Notification Preferences:**
    * Maintain a record of each student's notification preferences and settings.
    * Provide ways for students to adjust their notification settings.
* **Notification Dispatch:**
    * Schedule and dispatch notifications based on student's preferences, such as email notifications, in-app notifications, or SMS alerts.
    * Handle any delivery failures or exceptions gracefully, providing error handling and retry mechanisms.
    * Monitor students' notification settings and preferences for message delivery.
