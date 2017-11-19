# Clicker iOS Client 
[![Build Status](https://travis-ci.org/cuappdev/clicker-ios.svg?branch=master)](https://travis-ci.org/cuappdev/clicker-ios)

Clicker is one of the latest apps by [Cornell AppDev](http://cornellappdev.com), a project team at Cornell University. Clicker seeks to extend the functionality of iClickers on a web and mobile platform.

## Installation
We use [CocoaPods](http://cocoapods.org) for our dependency manager. This should be installed before continuing.

After cloning the project, `cd` into the new directory and install dependencies with
```
pod install
```
Open the Clicker Xcode workspace, `Clicker.xcworkspace`, and enjoy!

---

## Development 
  * [Models](#models)
  * [Views](#views)
  * [Controllers](#controllers)
  * [Other Classes](#other-classes)
  * [External Services](#external-services)

### Models

#### User

| Name     | Type      | Description                                            |
|----------|-----------|--------------------------------------------------------|
| id       | String    | Unique identifier.                                     |
| netID    | String    | Unique, university-generated identifier for each user. |
| name     | String    | User name (full name).                                 |
| courses  | [[Course](#course)]  | Courses that a user is either a student/professor in.  |
| lectures | [Lecture] | Lectures that a user has participated in.              |

#### Course 

| Name       | Type   | Description                             |
|------------|--------|-----------------------------------------|
| id         | String | Unique identifier.                      |
| name       | String | Course name.                            |
| term       | String | Course term.                            |
| professors | [User] | Professors who teach the course.        |
| students   | [User] | Students who participate in the course. |

#### Lecture 

| Name      | Type       | Description                                     |
|-----------|------------|-------------------------------------------------|
| id        | String     | Unique identifier.                              |
| dateTime  | String     | Start date and time of the lecture.             |
| questions | [Question] | Questions asked / to be asked during a lecture. |

#### Question

| Name    | Type     | Description                                                         |
|---------|----------|---------------------------------------------------------------------|
| id      | String   | Unique identifier.                                                  |
| text    | String   | Question asked / to be asked.                                       |
| type    | String   | Type of questions (FREE_RESPONSE, MULTIPLE_CHOICE, MULTIPLE_ANSWER) |
| options | [Option] | Choices presented / to be presented to answer a question.           |
| answer  | String   | Correct answer to the question.                                     |

#### Option

| Name        | Type   | Description                                   |
|-------------|--------|-----------------------------------------------|
| id          | String | Unique identifier.                            |
| description | String | Choice presented / to be presented to a user. |

#### Answer

| Name             | Type     | Description                                         |
|------------------|----------|-----------------------------------------------------|
| id               | String   | Unique identifier.                                  |
| question         | String   | Question id.                                        |
| answerer         | String   | User id.                                            |
| type             | String   | Type of answer (SINGLE_RESPONSE, MULTIPLE_RESPONSE) |
| multipleResponse | [String] | Choices submitted by a user.                        |
| singleResponse   | String   | Choice submitted by a user.                         |

#### Organization

| Name       | Type   | Description                             |
|------------|--------|-----------------------------------------|
| id         | String | Unique identifier.                      |
| name       | String | Organization name.                      |

### Views

 * CourseTableViewCell: Used in the HomeViewController to display a current course.
 * SessionTableViewCell: Used in the CourseViewController to display a past session. 

### Controllers

 * TabBarController: Used to implement a tab bar navigation flow.
 * LoginViewController: Used to allow users (students and professors) to login.
 * HomeViewController: Used to display all live sessions and current courses. 
 * CourseViewController: Used to display all past sessions for a given course.
 * LiveSessionViewController: Used to answer questions in class. Includes question, answers, timer, submit, etc. 

### Other Classes

 * Lecture Socket Delegate: Incoming and outgoing lecture messages

### External Services

 * [Socket.io](https://github.com/socketio/socket.io-client-swift): Used to manage sockets.
 * [SnapKit](http://snapkit.io/docs/): Used for some AutoLayout magic.
 * [Fabric](https://get.fabric.io/?utm_campaign=discover&utm_medium=natural): Used to track every move of our users. 
 * [Google Sign In](https://developers.google.com/identity/sign-in/ios/): Used to seamlessly sign in users. 

Check out [Issues](https://github.com/cuappdev/clicker-ios/issues) to see what we are working on!

[Back to top ^](#)
