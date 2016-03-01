//
//  FirstViewController.swift
//  NetworkingAndData
//
//  Created by T. Andrew Binkowski on 2/28/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
  
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
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // When view appears, download an image and set the image view's `image` property
    downloadImageWithClosure()
  }
}

extension FirstViewController {
  
  ///
  ///
  func downloadImageWithClosure() {
    let startTime = CFAbsoluteTimeGetCurrent()
    
    
    guard let url = NSURL(string: "https://kittybloger.files.wordpress.com/2012/05/cute-kittens-20-great-pictures-1.jpg") else {
      print("Probelem with url")
      return
    }
    
    // Make the download call
    downloadImage(url) { (downloadedImage) -> () in
      // Ensure the completion block is on the main thread
      self.catImageView.image = downloadedImage
      print("Elaspsed Time: " + (NSString(format: "%2.5f", CFAbsoluteTimeGetCurrent() - startTime) as String))
    }
  }
  
  ///
  ///
  func downloadImage(url: NSURL, completion: (UIImage)->()) {
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
        dispatch_async(dispatch_get_main_queue()) {
          completion(image)
        }
      }
    })
    
    // Tasks start in the suspended state, so resume it to start immediately
    task.resume()
  }
}
