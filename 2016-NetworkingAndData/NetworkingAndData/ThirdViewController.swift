//
//  ThirdViewController.swift
//  NetworkingAndData
//
//  Created by T. Andrew Binkowski on 2/29/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    // Persiste data in user defaults
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // Set some objects
    defaults.setObject("Mars", forKey: "kString1")
    defaults.setObject("Saturn", forKey: "kString2")
    
    // Set an array of strings
    let planets = ["Mercury","Venus","Earth","Mars","Jupiter","Saturn","Uranus","Neptune","Pluto?"]
    defaults.setObject(planets,forKey: "kPlanets")
    
    // Sync
    defaults.synchronize()
    
    // Print out the entire dictionary
    print(defaults.dictionaryRepresentation())
    
    // Get
    print("Object: \(defaults.objectForKey("kString1")!)")
    print("String: \(defaults.stringForKey("kString1")!)")
    
    if let string = defaults.stringForKey("kString1") {
      print(string)
    }
    
    // Get an array of data
    print("Array of Strings: \(defaults.arrayForKey("kPlanets")!)")
    
    //let defaults = NSUserDefaults.standardUserDefaults()
    //userDefaults.registerDefaults(["soundsOn": true, "username": "bob"])
    
    
    // Archive our custom Planet Objects
    let kPlanetEarthObject = "KPlanetEarthObject"
    let earth = Planet(name: "Earth")
    let data = NSKeyedArchiver.archivedDataWithRootObject(earth)
    
    // Unarchive our custom `Planet` object
    if let data = NSUserDefaults.standardUserDefaults().objectForKey(kPlanetEarthObject) as? NSData {
      if let earth = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Planet {
        print(earth.name)
      }
    }
    
    NSUserDefaults.standardUserDefaults().setObject(data, forKey: kPlanetEarthObject)
    
    // Path to main bunle
    //let bundle = NSBundle.mainBundle().URLForResource("Image", withExtension: ".png")
    
    
    print(defaults.dictionaryRepresentation())
    
    // To file on disk
    let planetsObjects: [Planet] = [Planet(name: "Earth"), Planet(name: "Mars")]
    
    let docs = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    let cache = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)[0] as String
    let tmp = NSTemporaryDirectory().stringByAppendingString("/planets.plist")
    
    NSKeyedArchiver.archiveRootObject(planetsObjects, toFile:docs.stringByAppendingString("/planets.plist"))
    NSKeyedArchiver.archiveRootObject(planetsObjects, toFile:cache.stringByAppendingString("/planets.plist"))
    NSKeyedArchiver.archiveRootObject(planetsObjects, toFile:tmp)
    
    print(docs,cache)
    
  }
  
}

