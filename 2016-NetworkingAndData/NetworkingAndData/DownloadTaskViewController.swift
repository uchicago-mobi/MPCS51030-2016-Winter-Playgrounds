//
//  DownloadTaskViewController.swift
//  NetworkingAndData
//
//  Created by T. Andrew Binkowski on 2/29/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import UIKit

class DownloadTaskViewController: UIViewController {
  
  /// A progress view to show the download status
  @IBOutlet weak var progressView: UIProgressView! {
    didSet {
      progressView.setProgress(0.0, animated: false)
    }
  }
  
  
  //
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Create the task
    var downloadTask: NSURLSessionDownloadTask
    var backgroundSession: NSURLSession
    
    // Create the background session
    let backgroundSessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("backgroundSession")
    backgroundSession = NSURLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
    
    // Do any additional setup after loading the view.
    guard let url = NSURL(string: "https://kittybloger.files.wordpress.com/2012/05/cute-kittens-20-great-pictures-1.jpg") else {
      return
    }
    
    // Set and kick off the task
    downloadTask = backgroundSession.downloadTaskWithURL(url)
    downloadTask.resume()
  }
}



///
///
///
extension DownloadTaskViewController: NSURLSessionDataDelegate {
  
  func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL){
    
    let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
    let destinationURLForFile = NSURL(fileURLWithPath: path.stringByAppendingString("/downloadedImage.jpg"))
    
    // Check if the file is already there; if not, move the downloaded file
    // there.  Note: The file only lives in the scope of the closure so you
    // need to so something with it immediately
    let fileManager = NSFileManager()
    if fileManager.fileExistsAtPath(destinationURLForFile.path!){
      print(destinationURLForFile.path!)
    } else {
      do {
        try fileManager.moveItemAtURL(location, toURL: destinationURLForFile)
        print(destinationURLForFile.path!)
      }catch{
        print("An error occurred while moving file to destination url")
      }
    }
  }
  
  /// Get progress on the download to update a progress view on the screen
  func URLSession(session: NSURLSession,
    downloadTask: NSURLSessionDownloadTask,
    didWriteData bytesWritten: Int64,
    totalBytesWritten: Int64,
    totalBytesExpectedToWrite: Int64){
      progressView.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
  }
  
}

