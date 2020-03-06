# Onramp iOS Take-Home Project 

## Overview 🍎

# Onramp iOS Take-Home Project 

## Description of the overall iOS application

This app is a Photo Gallery that showcase my Artwork from a book I am publishing call "Capturing Narcos".  Each artwork has a video timeline that can be display when the art is on full screen mode.  I wanted to take the Photo Gallery to another level and I included an Art Gallery in Augmented Reality where users can walk around and see each Artwork like in a real Gallery.  Lastly,  users would be able to register and login from the settings view and learn more about "Capture Narcos" and signup to be notify when the book and the game are available.

## High level architectural overview of your iOS application, relationships and purposes of all UIViewControllers and UIViews


* RootViewController: Is a UITabBarController, responsible to hold other ViewControllers of the app.
* PhotoGalleryController: Is a UICollectionViewController that inherit from BaseCollectionViewController. The PhotoGalleryController is responsible to present the Chapters cell that scroll vertical. Artwork are presented by Chapters. 
* BaseCollectionViewController: is a boiler plate for UICollectionViews and holds all the common factors to avoid repeating code as the project grows.
* PhotoHorizontalController: Is a UICollectionView that inherit from HorizontalSnappingController.  The purpose of this view is to scroll horizontal.
* HorizontalSnappingController: Is a UICollectionView that handles the position of the collection cells as user scroll horizontal. This prevent the images fall out of place or right in the middle. 
* BetterSnappingLayout: Helps with the calculations of the layout when scrolling horizontal 
* PhotoFullScreenController: Is a UITableViewController and it is use to render full screen on the first row and Chapter and Artwork description at the bottom. Here the user are able to play a video timeline of the selecte art.
* GalleryViewController: Is a UIViewController and ARSNViewDelegate that is use to render the Art Gallery in Augmented Reality when detecting a Horizontal Plane and the user click the screen to render the 3D Gallery.
* Plane: is a SCNNode: It is use to create an ARPlaneAnchor to give the ilusion we are walking around the Gallery.
* SettingsViewController: is a UIViewController that delegates to TableViewDelegate when user selects a cell. Settings allow user to upload a photo and update their name as well as logout, learn more about "Capture Narcos", or be notify when the book or the game will be available. The Tableview uses the cell header to render a botton that uses UIImagePickerView to have access to the device gallery. Also the cells are UITextField where only the name is enable and the last cell are two UIStackViews Horizontal for two UILabel and a two UISegmentedControl and the other UIStackView is Vertical to place them one above the otherone.
* The Navigation var at the top of the SettingsViewController, display a logout UIBarButtonItem on the left and save UIBarBottonItem on the right.
* The Save Botton will save the data to Firebase. 
* The Logout Botton will end the session and will present modally the RegistrationViewController
* The RegistrationViewController signup user with photo, name, email and password.  It display a botton at the botton to go to the LoginViewController. 
* The app uses UserDefault to save the user's UUID and keep them login. 
* For Service I use Capture Narcos API that I build from scratch usin Python/Django/AWS and I use Codable on my models  and URL Session to fetch request the Chapters, Artworts and Timelines.
* I abstract from the Controllers all the code responsible to fetch information and create ViewModel to be the coordinator between the controllers and the models, I decople the controllers use protocols and keep my view dumb. 


## Video Overview Link

https://youtu.be/aIY3d8_QR1E


## Photos

![IMG_7EDB8085EEB3-1](https://user-images.githubusercontent.com/10387470/76103836-399c7500-5f87-11ea-9afe-9b92878f80f5.jpeg)



![IMG_0581](https://user-images.githubusercontent.com/10387470/76103989-77010280-5f87-11ea-823e-ce3e62a8b671.PNG)

![IMG_0598](https://user-images.githubusercontent.com/10387470/76104022-83855b00-5f87-11ea-914f-6f341063024f.PNG)


![IMG_0583](https://user-images.githubusercontent.com/10387470/76104094-9ac44880-5f87-11ea-96ee-b723ca0be45d.PNG)


![IMG_0587](https://user-images.githubusercontent.com/10387470/76104314-01e1fd00-5f88-11ea-8f08-4c7511caa6b2.PNG)






### A Note on Researching and Plagiarism

You are actively encouraged to research the web, books, videos, or tutorials for this project. That said, we expect all code that is submitted to be your own (e.g. this project should NOT be completed with another person). That means that we expect each candidate to refrain from copying and/or pasting code into the project. If we find copied code in your project, we will have to disqualify you. Web and video resources are available at the end of this document.

## What we're looking for 🚀

We will evaluate your project by assessing the overall strength and quality of the following five factors:

### UI Design

iOS users expect your application to look and behave in a way that's consistently intuitive. Your iOS application should adhere to [Apple’s Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios/overview/themes/) (HIG). Be thoughtful of the UI elements you use, and refer to the HIG for examples of best practices. 

### Architecture Pattern 

An architecture pattern enables you to define a guide for how a piece of software should function, such that it can be scalable, maintainable, and testable. Common patterns for iOS applications include [MVC](https://www.raywenderlich.com/1000705-model-view-controller-mvc-in-ios-a-modern-approach) (Model-View-Controller), Viper, and [MVVM](https://www.raywenderlich.com/34-design-patterns-by-tutorials-mvvm) (Model-View-ViewModel). Keep in mind the concept of Separation of Concerns (youtube video discussing that here). **Note that it is required that you leverage the MVVM pattern within your iOS app.**

### Core iOS Components

Make sure to use version control with your app using a Github repository. 
A large part of iOS development consists of consuming JSON data to display on the screen. Leverage an API of your choice to fetch data for use within your app. Make sure to meet all app requirements, as laid out above. You can choose your preference of either Storyboard/Interface Builder or programmatic UI.

### iOS Development Best Practices

It's important to subscribe to a set of best practices when designing and implementing an iOS app. Be mindful of these widely accepted principles:

* [DRY](https://code.tutsplus.com/tutorials/3-key-software-principles-you-must-understand--net-25161) (don't repeat yourself). Also view this [Wikipedia Article](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself).
* Maintain a [separation of concerns](https://youtu.be/hIaPdjS5GNo?t=163) within your iOS components. Adhering to MVVM should naturally separate the various components of your app.
* Specify good [project structure](https://www.swiftbysundell.com/articles/structuring-swift-code/).
* Using these principles will result in a high quality user experience while efficiently utilizing phone hardware resources and ensuring other developers can easily navigate through your code.

### Application Description

Each project submission must include a README file providing an overview of the iOS application and details the app's overall MVVM architecture as well as your design decisions. Screenshots of the iOS app taken from the Xcode simulator or your testing device are also required. This task assesses the critical competency of communicating and documenting technical concepts. See details in the submission information section below.

# What we are NOT Evaluating ❌

## Testing

Testing frameworks and strategies are intentionally NOT assessed because we want you to dedicate your time to building a functional application. We do realize that UI and iOS component testing are critical practices of iOS Development, but this project prioritizes a focus on surfacing Swift/iOS development proficiency.

## Feature Depth

You won’t be earning extra points for having a bunch of features. Focus on creating a clean, simple application that addresses all of the requirements and is documented properly for submission.

# Submission Information 🎇

This repository will be your starting point. Please download (not clone or fork) this Github repository and upload changes to a newly created **public** repository. Once the iOS application has been completed, you'll be submitting a link to the new repository you created. Prior to submitting your project, you should update the README file to provide the following information:

* A description of the overall iOS application
* A high level architectural overview of your iOS application. e.g. names, relationships and purposes of all UIViewControllers and UIViews
* Explanations for and descriptions of the design patterns you leveraged
* [Screenshots](https://stackoverflow.com/questions/7092613/take-screenshots-in-the-ios-simulator) of each View and descriptions of the overall user flow

## Submission Deadline + Process

You must submit your project by **9:00am PST/12:00pm EST on Friday, March 6** using this [form](https://docs.google.com/forms/d/e/1FAIpQLSfVu3xnF7UsgZIItpW36ggH9ASrhfozUl3Jo2lwse3tP4bAxg/viewform). 

Once you’ve submitted your project, you are expected to stop working on it. Any commits that occur after submission or the deadline will not be reviewed. 

## Additional Resources
* MVVM [Swift: How to Migrate MVC to MVVM](https://www.youtube.com/watch?v=n06RE9A_8Ks), [Different Flavors of view models in Swift by Sundell](https://www.swiftbysundell.com/articles/different-flavors-of-view-models-in-swift/), [AppCoda: Introduction to MVVM](https://www.appcoda.com/mvvm-vs-mvc/), [objc.io: Introduction to MVVM](https://www.appcoda.com/mvvm-vs-mvc/)
* [Swift Language Guide](https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html)
* [Exhaustive list of iOS Good Practices](https://github.com/futurice/ios-good-practices) 
* [Hacking With Swift blog](https://www.hackingwithswift.com/)
* [Ray Wenderlich blog](https://www.raywenderlich.com/)
* [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios/overview/themes/)
* [Separation of Concerns](https://www.youtube.com/watch?v=VtF6aebWe58&feature=youtu.be)
* [SwiftLee blog](https://www.avanderlee.com/)
* [Data Persistence](https://developer.apple.com/library/archive/referencelibrary/GettingStarted/DevelopiOSAppsSwift/PersistData.html)
* [Apple Developer App](https://apps.apple.com/us/app/apple-developer/id640199958)
* [WWDC Videos](https://developer.apple.com/videos/)
