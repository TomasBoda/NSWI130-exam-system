# Context 

To achieve a degree students need to pass certain exams. It is not an easy task to manage these exams for hundreds, 
maybe thousands of students at the same time. This system will provide an environment which will effectively manage these exams.

Currently, there are no other inputs or programs. This system will work independently without the input of other programs.
In the future, there will probably be other parts of this university system so it should be designed in such a way, that other systems could
be easily included.


# Functional overview

## Main Overview

Teachers and students will communicate with the program via a web browser. The code that they will access will be in an application called Exam System. Only external
system will be as Auth service. To make own good authorization is a problem, so an external provider will be used.

## UI

There will be 3 connected structures to provide a user interface. They will be independent of each other, and each of them will be for a specific purpose.

### Student UI

It will be possible to enrol for an exam, see grades and other actions a student can do.

### Teacher UI

It will be possible to create exams, write grades and other tasks teachers do.

### Auth UI

This UI is for both students and teachers before they there will be redirected to their UI, they have to authorize themselves, and it will be done 
in this part of the application

## Core services

### Exam system - core

The system is accessible via API Gateway. Users and other services can access functionalities via this unified access. The task will be then done 
by a specific controller.

#### Access to database

To provide data integrity and validity writing into the database is done via the Query interface. Parameters are checked by the data validator and then executed
the database. Only general data are checked, for example student/teachers IDs etc. - not data validity

#### Controllers

They are designed for a specific purpose. They handle specific types of requests.

##### Exam controller

Every request related to exam management - create an exam, change date, choose available room...

##### Grade controller

Every request related to grading

## Non-core services

### Descriptions

These services provide extra functionality but the system could work without them. They are generic, they should provide the same functionality and also
for another system if they will be implemented in the future

### Message service

Teachers and students can communicate in real time about exams etc. For example asking and answering questions.


### Notification service

This program sends automated notifications. For example, when the time of an exam is changed, enrolled students should be notified. The message of these
changes is generic and can be sent automatically. This service will spectate the database and when a certain change is spotted, 
it will automatically generate and send a notification. Notification can be also triggered by a real person when a simple message is needed to notify.


# Quality attributes

## Performance

Usually, there will be no problem with performance. Users will usually get information and then they will spend a certain time consuming the result.
Problems could arise when a large set of exam days is released. There is an expected large volume of students at the same time trying to sign up for their
specific date.


## Real-time functionality

During peak time certain exams times can be full in a matter of seconds. People should see immediately when the time is full, they should not be able
to see available time but then get an error, because in the meantime the time is full.

## Consistency

There does not have to be extra care with data stored in a database. For example, the date will be stored in the wrong way. 
In the worst scenario, students will sign for an invalid date and it will be moved. It could only disturb their schedule. 
The only exceptions are grades and personal information.


## Availibility

The exam system is not a core infrastructure. If the system is not available, it will not be a huge problem, but these windows should not be longer than a day.

## Security

Exam grades and personal information should be private and kept secret from other people. Login and role system should be implemented. 
Only students and lecturers of the subject should see their own grades. Personal information should be visible only to a small group of people