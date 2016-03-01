//
//  Planet.swift
//  NetworkingAndData
//
//  Created by T. Andrew Binkowski on 2/29/16.
//  Copyright © 2016 The University of Chicago, Department of Computer Science. All rights reserved.
//

import Foundation


///
/// Custom Planet Object that conforms to NSCoding to archive
///
class Planet: NSObject, NSCoding {
  var name: String
  
  // Memberwise initializer
  init(name: String) {
    self.name = name
  }
  
  
  //
  // MARK: - NSCoding
  //
  
  
  required convenience init?(coder decoder: NSCoder) {
    guard let name = decoder.decodeObjectForKey("name") as? String else {
        // Alternative use a coalescing operator
        // name = aDecoder.decodeObjectForKey("name") as? String ?? ""
        return nil
    }
    self.init(name: name)
  }
  
  func encodeWithCoder(coder: NSCoder) {
    coder.encodeObject(self.name, forKey: "name")
  }
}


