# Distributed Attendance System - iOS Application

This is a project work in progress. (23 November 2019)

Login, Register and Walkthrough:

![](https://media.giphy.com/media/Kf5KAxQ9k2EWjmo2yA/giphy.gif)

Biometrics and QR Scanner:

![](https://media.giphy.com/media/f46pAfpT7kiOuLFvcM/giphy.gif)

## Project Background :

The current medieval form of taking attendance is a slow, time-consuming and inept process. Rather than being a mere record keeping task, it has evolved to a rather cumbersome task due to the sheer amount of time it takes and the dedicated concentration that is expected from both the student and the teacher for doing said task in a smooth manner. Moreover, with the advancement in technology and sciences, our day to day lifestyle and the quality of our lives has improved tremendously making everything easier and more efficient for mankind. Despite this, the method of taking attendance has remained the same and has seen no improvement or changes at the slightest. Thus, there is a pressing need to make the whole task of taking attendance more trivial and efficient, and this can be achieved with the help of incorporating various technologies that have become a standard part of everyone’s day to day life such as mobile phones.

## Motivation :

Being a college student who attends classes regularly, one thing that seems to bother everyone is the fact that around 20% of class time is spent in tasks such as attendance, settling down, Q&A etc. While some of these are unavoidable, the time spent on attendance can be brought down dramatically if a certain amount of work is done to improve the current system by utilizing technology. Consider this scenario, A typical class is of 50mins, and the time spent in attendance for said class is around 5 minutes. this is 1/10’s of the whole class or in other words, for every 10 classes that happens, we are spending 1 class only taking attendance. Thus, the waste of time is clear and an issue. This need not always be the case and his is where we aim to change the way we take attendance. Everyone going to college carries a phone with them and due to the advancement in technology, we have cameras in our phones and internet access in our classroom. These factors allow us to create a system where the teacher creates a QR code for the classroom’s attendance and a person can scan a QR code and automatically post the attendance for a particular class. This whole process can be done in parallel i.e. multiple students can scan and post attendance at the same time thus making sure there is no need to wait for posting attendance. This will drastically decrease our time spent in attendance and thus ensuring a more effective class time utilisation.

## Architecture :

![Architecture](//imgur.com/h4fRugt)

## Project Description :

Distributed Attendance System consists of many components including web application, iOS native application and corresponding AI models. This system architecture is implemented with speed in mind so that the attendance system works flawlessly within seconds. Few key points kept in mind while developing this system are as follows -

- Student friendliness such that they don’t feel frustrated to give attendance using the application.
- Teacher friendly with very less components and easy to understand U.I.
- Components does not stress the hardware of the students to prevent heating issues.
- Teacher side web application does not require heavy hardware usage.
- Components follow universal standards so that further maintenance of the system by colleges won’t be an issue.

## **Application components:**

MVC architecture is followed for this iOS application. The following model consist of the subcomponents -

> **Model:**

- Face ID for Face Recognition and Verification.

Complex sensor-based Face Recognition and Verification using mobile hardware.

- Persistent storage for storing user data.

iOS persistence storage using user defaults.

- AES-GCM class definition

Advanced encryption system for secure communication of information using RESTful API and using Galois/Counter Mode for integrity.

> **View:**

- Main storyboard

Main view architecture for iOS applications

- Launch screen storyboard

Launch view architecture for iOS applications

> **Controller:**

- Tab view controller

Split view controller for users to choose between logging in or registering.

- Login view controller

Login view controller for user login activity using REST post request and AES-GCM encryption.

- Register view controller

Register view controller for user register activity using REST post request and AES-GCM encryption.

- Navigation view controller

A navigation controller manages a stack of view controllers to provide a drill-down interface for hierarchical content.

- Face ID view controller

View controller where the sensor-based Face Recognition system is deployed. This can be accessed via the navigation controller following the path.

- QR Scanner view controller

QR view controller contains a QR scanner using iOS mobile camera following a privacy request.

- Attendance Posted view controller

View controller to notify users that their attendance is posted.

## iOS Sensor based Face recognition and Liveness detection:

The apple FaceID is done by using various types of sensors. Devices iPhone X and above consist of 5 different sensors: Infrared camera, Flood illuminator, Proximity sensor, Ambient light sensor, Dot projector. All of these are combined and worked with the all new True Depth camera system. The flood illuminator shines infrared light at your face, that permits the system to sight whoever is in front of the iPhone, even in low-light situations or if the person is wearing glasses (or a hat). Then the dot projector shines over 30,000 pin-points of light onto your face, building a depth map that may be read by the infrared camera. All of these data which are collected using the True Depth camera are processed using the latest A series bionic processing chip.

Apple's Face ID system uses Apple's Machine Learning algorithms and a "Neural engine" hardware component built into the A11 processor to analyze and recognize your face. This includes keeping up to date with changing appearances, such as when you're growing a beard or wearing sunglasses. (The infrared light can see through those sunglasses to detect your gaze, and the system will still recognize you if enough data points match. Neural engine is a custom-designed, dual-core chip specifically made to crunch data, identifying people, places and objects without affecting the phone's primary CPU.

Face ID analyzes your features in real-time, processing more data points - 30,000 of them - than Touch ID measures when scanning a fingerprint. Apple worked to make sure the system can't be spoofed by photographs and worked with Hollywood mask-makers to ensure even elaborate masks won't defeat the system. As a result, according to Apple, the chance a random person can unlock your phone using their face is 1 in a million; it's 1 in 50,000 for Touch ID. But not all students own an iPhone above the model X. In those specialized cases our application will handle accordingly. We will discuss more about this in the controller segment.

The students distributed attendance system uses the Face ID feature of the iPhone X and above to securely log in the user of the mobile into the application. If any other person tries to login the mobile, then the face ID would not unlock the application forcing it to log back to the login screen.

## Student Model for persistent storage:

The student class model is defined in this file. This class ensures that the student created conforms to this class and the information of this user can be accessed anywhere from the application. This class is file private and the stored information is not visible to others outside of the application. These user data are stored in the user’s mobile temporarily from the login screen to the end attendance posted screen. The data is stored using the User Defaults NSObject.

    class UserDefaults : [NSObject](https://developer.apple.com/documentation/objectivec/nsobject)

The UserDefaults class provides a programmatic interface for interacting with the defaults system. The defaults system allows an app to customise its behaviour to match a user’s preferences. For example, you can allow users to specify their preferred units of measurement or media playback speed. Apps store these preferences by assigning values to a set of parameters in a user’s defaults database. The parameters are referred to as defaults because they’re commonly used to determine an app’s default state at startup or the way it acts by default.

At runtime, you use UserDefaults objects to read the defaults that your app uses from a user’s defaults database. UserDefaults caches the information to avoid having to open the user’s defaults database each time you need a default value. When you set a default value, it’s changed synchronously within your process, and asynchronously to persistent storage and other processes. This information of the user can be accessed whenever we need from all classes and can be retrieved by using the key we used to store it. The register number of the user is persisted here across all screen so that it can be retrieved on the last before QR Scanner view controller to be sent along with the QR related data to the database for verification.

### View / Storyboard:

### Interface Builder:

The Interface Builder editor within Xcode makes it simple to design a full user interface without writing any code. Simply drag and drop windows, buttons, text fields, and other objects onto the design canvas to create a functioning user interface.

Because Cocoa and Cocoa Touch are built using the Model-View-Controller pattern, it is easy to independently design your interfaces, separate from their implementations. User interfaces are actually archived Cocoa or Cocoa Touch objects (saved as .nib files), and macOS and iOS will dynamically create the connection between UI and code when the app is run.

### Storyboard:

A complete iOS app is composed of multiple views through which the user navigates. The relationships between these views are defined by storyboards, which show a complete view of your app’s flow.

### LaunchScreen.storyboard:

This screen will be presented during the launch of the application. The logo of the application will be animated to the center of the screen upon clicking the application from the home page of the user. The logo will further be projected with greater size and opacity.

Next, the user is presented with the user agreement and other necessary privacy settings that the user must allow in order for the application to work flawlessly. This is to make sure that the privacy of the user is contained within the mobile and we are not eligible for the loss of any day that the user provides.

### Main.storyboard:

Main storyboard contains the applications architecture. The architecture consists of the path the app will take in order to traverse through one view controller to the other. This file is the core for linking the necessary views to its classes and produce a hierarchy.

![Main Storyboard](https://imgur.com/khAP3Tq)

## Controller:

All the screens presented conform to “Dark theme” presented in the new iOS 13.1. All screen displayed will conform to the protocol and will change colors depending on the theme used by the administrator / user.

### Tab view controller:

The iOS tab view controller will conform to the UITabViewController class of the UIKit library in Swift.

    class UITabBarController : [UIViewController](https://developer.apple.com/documentation/uikit/uiviewcontroller)

The tab bar interface displays tabs at the bottom of the window for selecting between the different modes and for displaying the views for that mode. This class is generally used as-is, but may also be subclassed.

Each tab of a tab bar controller interface is associated with a custom view controller. When the user selects a specific tab, the tab bar controller displays the root view of the corresponding view controller, replacing any previous views. The tab bar consists of two classes in this scenario.

1. Register view controller
2. Login view controller

### Segues and View controller transition:

UIStoryboardSegue object that prepares for and performs the visual transition between two view controllers.

```Swift
class UIStoryboardSegue : [NSObject] (https://developer.apple.com/documentation/objectivec/nsobject)
```

The UIStoryboardSegue class supports the standard visual transitions available in UIKit. This can also be subclassed to define custom transitions between the view controllers in the storyboard file.

Segue objects contain information about the view controllers involved in a transition. When a segue is triggered, but before the visual transition occurs, the storyboard runtime calls the current view controller’s prepare(for: sender:) method so that it can pass any needed data to the view controller that is about to be displayed.

The storyboard runtime creates the segue objects when it must perform a segue between two view controllers. We can still initiate a segue programmatically using the performSegue(withIdentifier: sender:) method of UIViewController if we want. One might do so to initiate a segue from a source that was added programmatically and therefore not available in Interface Builder.

### Login screen View Controller and Register View Controller:

```Swift
class LoginScreenViewController : [UIViewController](https://developer.apple.com/documentation/uikit/uiviewcontroller)
class RegisterViewController : [UIViewController](https://developer.apple.com/documentation/uikit/uiviewcontroller)
```

The tab view controller (consisting of both login and register view controller) is the first screen that is presented to the user once he/she launches the application from the homepage. The user can click on the login or the register view controller in the tab bar presented at the bottom of the screen Both register and login screen controller class further conforms to the [UITextFieldDelegate](https://developer.apple.com/documentation/uikit/uitextfielddelegate) protocol for various user friendly and quality of life features.
```Swift
protocol UITextFieldDelegate
```

Register view controller class lets the user register to the Distributed Attendance System services by entering their respective name, email, password and register number. Register number parameter is used as the user’s username as it works as the ID in most of the colleges and universities. With the help of UITextFieldDelegate protocol normal form validations are performed (i.e. checking for nil values). The user then selects the Sign-Up button which encrypts the information with AES-GCM algorithm. This security encryption is done to prevent sniffers from accessing user credentials and locking out the user. The algorithm is explained in detail after this section. After this phase a verification email is sent to the user using the email mentioned during the registration process. The student should click on the verification link in the email to verify his identity. After this process the student is permanently stored in the D.A.S cloud database. The user who has already registered and verified on the distributed attendance system database can login and use the application. This is the basic security feature in the application. During the registration process the fields registernumber and password entered should be re-entered here for verification. But this feature is not that secure, therefore once the user presses the Sign In button he is traversed to the Face ID verification Controller. In the figure 2 presented above we can see the Login View controller presented to the user. On top of this basic text validation is done on the text field along with AES-GCM encryption. This information is sent as a get request from the user’s mobiles to the D.A.S database server. JSON string is received as a response from the server which is also AES-GCM encrypted. Upon success received from the server the user is moved to the next screen. On a failed response the user is asked to login again with the correct credentials or requested to connect to proper internet connection before re-attempting the same.

Login screen controller also contains the NSObject NotificationCenter which is responsible for the keyboard view port animation which raises the viewport based on the keyboard height and width which makes sure the text fields are not hidden.

    class NotificationCenter : NSObject

    NotificationCenter.**default**.**addObserver**(self, 
    																				selector: #**selector**( keyboardWillShow(notification:)), 
    																				name: UIResponder.keyboardWillShowNotification, 
    																				object: **nil**) 
    NotificationCenter.**default**.**addObserver**(self, 
    																				selector: #**selector**( keyboardWillShow(notification:)), 
    																				name: UIResponder.keyboardWillHideNotification, 
    																				object: **nil**) 
    NotificationCenter.**default**.**addObserver**(self, 
    																				selector: #**selector**( keyboardWillShow(notification:)), 
    																				name: UIResponder.keyboardWillChangeFrameNotification, 
    																				object: **nil**)

For HTTP request handling, Alamofire for Swift is used. This will help in handling JSON responses and sending requests easily. For installing packages, we use CocoaPods. CocoaPods is a dependency manager for Cocoa projects. To integrate Alamofire into the Xcode project using CocoaPods, we specify this in the Podfile:

    pod ‘Alamofire’, ~> 5.0.0-rc.3

With the package installed we can easily import the library using the command below in the Xcode IDE:

    import Alamofire

With Alamofire imported we can now use all the commands using this library.

For Register Post request we use:

    //Dictionary used for sending the parameters for post request
    let params: [String : String] = [ “id”: ID,
    																	“name” : Name,
    																	“password: Pass,
    																	“email”: Email,
    																	“category”: “Student”
    																]

    //Actual post request using the URL of the website as URLstring and parameters as params 
    Alamofire.**request(**URL**: URLstring,** 
    									method: **.post,** 
    									parameters: **params) 
    									.responseJSON {** response **in}**

The response variable houses the response received from the post request. Using the response, we can find our whether the registration was successful or not.

For Login Post request we use

    //Dictionary used for sending the parameters for post request
    let params: [String : String] = [
        “username”: ID,
        “password: Pass,
        ]

    //Actual post request using the URL of the website as URLstring and parameters as params 
    Alamofire.**request(**URL**: URLstring,** 
    									method: **.post,** 
    									parameters: **params) 
    									.responseJSON {** response **in}**

The response here is checked by using the SwiftyJSON library imported using Cocoapods. SwiftyJSON allows us to easily handle JSON objects in a very similar way to JavaScript.

With the help of this library we check if the string returned is a success or not. If success we send the user to the next view else kick him back to login to try again.

### Verification View Controller:

When the user enters into this view controller he is immediately prompted to verify his identity using the available biometric sensor in the device. iPhone 5 and above consist of Touch ID and iPhone X and above consist of the new Face ID. This way of verification is a necessity because this makes sure that no-one can grab anyone else’s phone and post attendance on their behalf.

Before starting Face ID verification, the phone’s OS version must be checked and then proceeded. Biometrics on iPhone which supports the functions that are implemented in the application need iOS 8.0 and above.

    guard #available ( **iOS** 8.0, *) else {
    //This verification function performs both TouchID and FaceID based on the user’s device
        performVerification ( )
    }

Certain policies must be mentioned beforehand so that privacy of the user is considered. All of these policies are stored in the “property list” file (more commonly known as plist files). An information property list file is a structured text file that contains essential configuration information for a bundled executable. The file itself is typically encoded using the Unicode UTF-8 encoding and the contents are structured using XML. The root XML node is a dictionary, whose contents are a set of keys and values describing different aspects of the bundle. The system uses these keys and values to obtain information about your app and how it is configured. As a result, all bundled executables (plug-ins, frameworks, and apps) are expected to have an information property list file.

By convention, the name of an information property list file is Info.plist. This name of this file is case sensitive and must have an initial capital letter I. In iOS apps, this file resides in the top-level of the bundle directory. In macOS bundles, this file resides in the bundle’s Contents directory. Xcode typically creates this file for you automatically when you create a project of an appropriate type. Since for the project we use iPhone’s camera and FaceID feature we should get the user’s permission first.

For Camera access:

Privacy - Camera Usage Description

For Face ID access:

Privacy - Face ID Usage Description

![Face ID Test](https://imgur.com/ynTrVFb)

### QR Scanner View Controller

QR scanner view controller is implemented by accessing user’s camera.

## Current system of QR based attendance and its flaws.

The current system of Using a QR code to post attendance is flawed due to the following issue:

- A person can take a photo of the QR code and send it to his/her friend who in turn can scan the QR thus posting Attendance.
- This issue can however be overcome if there is a time out for posting attendance i.e. The QR code becomes invalid after a certain time thus ensuring Scanning the QR’s photo will not post attendance way after the class is over.
- But this still causes issues when the photo can be instantly transferred to a friend via email or other messaging software that are available today.

## Proposed Solution

Keeping in mind the various limitations of the current system, the proposed system is to revolve the QR or change it continuously after a set amount of time. This means we are creating multiple QR’s for a particular class and each QR code will have a different time before it times out. Thus, each QR is valid only for a Short amount of time, ideally this time would be less than the Time it takes for a person to take a Screenshot of the QR and send it to a person. This way even if a person takes a screenshot, sending it to a friend would take too long and scanning the photo will result in nothing but a timeout thus ensuring only people present in class can actually use the QR to post attendance.

A typical QR code is generated based on a text input i.e. it takes a text and transfers it into a pictorial representation of the text that can be scanned and giving useful information to the device that is scanning it.

So, in our case, the following details will be sent to the mobile application that will be scanning the QR

- Class ID
- Slot
- Current time
- Offset
- Salt

## Class ID and Slot

****This is used to identify the class for which is used to identify which class to post attendance.

Current Time and Offset

****The current time is as the name suggest, the time at which the QR is generated. The offset is the position of the QR in the cycle of revolving QR. The offset along with the time is used to timeout the QR. The way it works is as follows:

- Mobile application gets current time and Offset from QR.
- Mobile generates the current system time.
- If (current system time – current time from QR) > (Offset * desired window of activation)
    - Post attendance
- Else
    - Exit Application.

### **Salt**

****Salt is just an added layer of security which adds a random string of characters in order to make the string more unique.

The user camera detects this generated QR code and gets the information to do a post request using Alamofire mentioned in the Login/Register view controller. Finally, all this data is appended to a String and encrypted via AES126 encryption to get more security.

## Attendance View controller

This view controller contains a label which tells the user that his attendance is posted.
