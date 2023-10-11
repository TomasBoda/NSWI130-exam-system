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

##### Personal messages responsibilities
* Store the message in the database
* Assign the message to all registered students.

##### Notification responsibilities
* Send a new personal message notification to all students according to their notification settings.
