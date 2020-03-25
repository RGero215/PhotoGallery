## Overview 🍎


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


