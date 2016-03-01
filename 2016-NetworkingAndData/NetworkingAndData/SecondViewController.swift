//
//  SecondViewController.swift
//  NetworkingAndData
//
//  Created by T. Andrew Binkowski on 2/28/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import UIKit

///
///
/// Note: The broacast name is a constant `kNotificationImageDownloadedKey` that
///       is defined in Constants.swift
///
///



class SecondViewController: UIViewController {
  
  /// An image view to be shown in the center of the screen; use computed
  /// properties to set behaviors
  var catImageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 200))
  
  //
  // MARK: - Lifecycle
  //
  
  override func viewDidLoad() {
    super.viewDidLoad()
    catImageView.contentMode = .ScaleAspectFill
    catImageView.backgroundColor = UIColor.blueColor()
    catImageView.center = view.center
    view.addSubview(catImageView)
    
    //
    // Add the notification observer for the lifecycle of the view controller
    //
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "imageDownloaded:",
      name: kNotificationImageDownloadedKey,
      object: nil)
  }
  
  /// Called when the view controller is removed from memory
  ///
  deinit {
    // Remove the notification observer so it will not be listenting to broadcasts
    // anymore.
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    //
    // Download a big image and show it on the scene
    //
    downloadImageWithNotification()
  }
}


///
///
///
extension SecondViewController {
  
  /// Download a really big image by calling our downloadImage() function
  ///
  func downloadImageWithNotification() {
    guard let url = NSURL(string: "http://i.imgur.com/XBnuETM.jpg") else {
      print("Probelem with url")
      return
    }
    
    // Make the download call
    downloadImage(url)
  }
  
  
  /// Kick off a data task to downloade the image.  Announce the download is
  /// complete to the NotificationCenter
  ///
  func downloadImage(url: NSURL) {
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
      
      // Check that there was no data; this is misleading since a 404 does not
      // return an error.  Note: All paramters in the completion handler are optionals
      guard error == nil else {
        print("error: \(error!.localizedDescription): \(error!.userInfo)")
        return
      }
      
      guard response != nil else {
        // Check the response
        print("Response: \(response)")
        return
      }
      
      guard let taskData: NSData = data where data != nil else {
        print("Error with data")
        return
      }
      
      // Create a UIImage from the response data and pass it to the completion
      // handler
      //print(taskData)
      if let image = UIImage(data: taskData) {
        print("Done downloading")

        //
        // Broadcast to notification center that we have the image
        //
        NSNotificationCenter.defaultCenter().postNotificationName(kNotificationImageDownloadedKey, object: image)
      }
    })
    
    // Tasks start in the suspended state, so resume it to start immediately
    task.resume()
  }
  
  
  
  /// The method called when the notification is recieved from notification
  /// center.  Cast the `object` to an `UIImage` and then set the image property
  /// of the image view on the screen
  ///
  /// - Parameter notification: A dictionary sent to the receiver
  ///
  func imageDownloaded(notification: NSNotification) {
    print("Image downloaded with notification: \(notification)")
    let image = notification.object as? UIImage
    
    // Update the image with the passed image
    dispatch_async(dispatch_get_main_queue()) {
      self.catImageView.image = image
    }
  }
  
}
