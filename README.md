# Pollo iOS Client
[![GitHub release](https://img.shields.io/github/release/cuappdev/clicker-ios.svg)]()
[![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)]()
[![GitHub contributors](https://img.shields.io/github/contributors/cuappdev/clicker-ios.svg)]()
[![Build Status](https://travis-ci.org/cuappdev/clicker-ios.svg?branch=master)](https://travis-ci.org/cuappdev/clicker-ios)

Pollo is one of the latest apps by [Cornell AppDev](http://cornellappdev.com), a project team at Cornell University. Pollo seeks to extend the functionality of iClickers on a web and mobile platform.

## Installation
We use [CocoaPods](http://cocoapods.org) for our dependency manager. This should be installed before continuing.

Clone the project with `git clone https://github.com/cuappdev/pollo-ios.git`

After cloning the project, `cd` into the new directory and install dependencies with `pod install`.

Open the Pollo Xcode workspace, `Pollo.xcworkspace`, and enjoy!

## Configuration
You need a valid `env-vars.sh` file with the following structure:
```
export API_URL=example-url.com
export API_DEV_URL=example-dev-url.com
export FABRIC_API_KEY=someapikey
export FABRIC_BUILD_SECRET=somefabricbuildsecret
```

---

## Development
  * [IGListKit](#iglistkit)
  * [Controllers](#controllers)
  * [External Services](#external-services)

### IGListKit

IGListKit is a `UICollectionView` framework built by Instagram that we use throughout the app. It forces us to create models for items we display in a `UICollectionView`.

### Controllers

 * PollsViewController: Used to display created and joined groups and allow user to create or join a group.
 * CardController: Used to display all polls on a single date for a group.
 * PollsDateViewController: Used to display all dates for a group.
 * DeletePollViewController: Used to delete a poll from a group.
 * EditNameViewController: Used to edit the name of a group.
 * EditPollViewController: Used to edit a poll.
 * FeedbackViewController: Used to prompt user for feedback on the app.
 * PollBuilderViewController: Used to create and start polls and create drafts.
 * EditDraftViewController: Used to edit a draft.
 * SettingsViewController: Used to display settings (website, log out, etc.).
 * GroupControlsViewController: Used to allow the admin of a group to configure settings for a group.
 * AttendanceViewController: Used to allow the admin of a group to view and export group attendance.

### External Services

 * [Alamofire](https://github.com/Alamofire/Alamofire): Used for HTTP networking.
 * [Google Sign In](https://developers.google.com/identity/sign-in/ios/): Used to seamlessly sign in users.
 * [Socket.io](https://github.com/socketio/socket.io-client-swift): Used to manage sockets.
 * [SnapKit](http://snapkit.io/docs/): Used for some AutoLayout magic.
 * [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON): Used for improved JSON parsing.
 * [SwiftLint](https://github.com/realm/SwiftLint): Used to enforce Swift style and conventions.
 * [Sourcery](https://github.com/krzysztofzablocki/Sourcery): Used to generate code.
 * [Presentr](https://github.com/icalialabs/Presentr): Used for custom view controller presentation.
 * [FutureNova](https://github.com/cuappdev/ios-networking.git): Used for networking.
 * [AppDevAnalytics](https://github.com/cuappdev/ios-analytics.git): Used for event logging.
 * [IGListKit](https://github.com/Instagram/IGListKit): Used for collection views.

Check out [Issues](https://github.com/cuappdev/pollo-ios/issues) to see what we are working on!

[Back to top ^](#)
