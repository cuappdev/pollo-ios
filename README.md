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
| lectures | [[Lecture](#lecture)] | Lectures that a user has participated in.              |

#### Course 

| Name       | Type   | Description                             |
|------------|--------|-----------------------------------------|
| id         | String | Unique identifier.                      |
| name       | String | Course name.                            |
| term       | String | Course term.                            |
| professors | [[User](#user)] | Professors who teach the course.        |
| students   | [[User](#user)] | Students who participate in the course. |

#### Lecture 

| Name      | Type       | Description                                     |
|-----------|------------|-------------------------------------------------|
| id        | String     | Unique identifier.                              |
| dateTime  | String     | Start date and time of the lecture.             |
| questions | [[Question](#question)] | Questions asked / to be asked during a lecture. |

#### Question

| Name    | Type     | Description                                                         |
|---------|----------|---------------------------------------------------------------------|
| id      | String   | Unique identifier.                                                  |
| text    | String   | Question asked / to be asked.                                       |
| type    | String   | Type of questions (FREE_RESPONSE, MULTIPLE_CHOICE, MULTIPLE_ANSWER) |
| options | [[Option](#option)] | Choices presented / to be presented to answer a question.           |
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

#### Cells

 * LiveSessionTableViewCell: Used in the HomeViewController to display active lectures.
 * PastSessionTableViewCell: Used in the HomeViewController to display past lectures.

#### Headers

 * LiveSessionHeader: Used in the HomeViewController as the section header for active lectures.
 * PastSessionHeader: Used in the CourseViewController as the section header for past lectures.

### Controllers

 * HomeViewController: Used to display all active lectures and past lectures. 
 * LiveSessionViewController: Used to answer questions in class. Includes question, answers, timer, submit, etc. 
 * LoginViewController: Used to allow users (students and professors) to login.
 * TabBarController: Used to implement a tab bar navigation flow.

### Other Classes

#### Quarks

We use Quarks for all of our protocol-oriented networking tasks. [Neutron](https://github.com/dantheli/Neutron) is an awesome framework that we use to streamline all networking tasks.

 * ClickerQuark
 * CourseQuark 
 * LectureQuark 
 * OrganizationQuark 
 * QuestionsQuark
 * UserQuark

#### Sessions

 * Session
 
|   Name   |       Type      |        Description       |
|----------|-----------------|--------------------------|
| id       | Int             | Unique identifier.       |
| delegate | SessionDelegate | This session's delegate. |
 
 * SessionDelegate: Protocol specifying session functionality (sessionConnected & sessionDisconnected).

### External Services

 * [AlamoFire](https://github.com/Alamofire/Alamofire): Used for HTTP networking.
 * [Fabric](https://get.fabric.io/?utm_campaign=discover&utm_medium=natural): Used to track every move of our users. 
 * [Google Sign In](https://developers.google.com/identity/sign-in/ios/): Used to seamlessly sign in users. 
 * [Socket.io](https://github.com/socketio/socket.io-client-swift): Used to manage sockets.
 * [SnapKit](http://snapkit.io/docs/): Used for some AutoLayout magic.
 * [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON): Used for improved JSON parsing.
 * [Neutron](https://github.com/dantheli/Neutron): Used for protocol-oriented networking.

Check out [Issues](https://github.com/cuappdev/clicker-ios/issues) to see what we are working on!

[Back to top ^](#)
