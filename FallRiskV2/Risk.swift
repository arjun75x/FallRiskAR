//
//  ObjectInfos.swift
//  FallRiskAR
//
//  Created by Arjun Arun on 12/1/19.
//  Copyright © 2019 Apple. All rights reserved.
//


import Foundation

struct Risk {
  let name: String
  let level: String

  static func getObject(for name:String) -> Risk? {
    switch name {
    case "officecleaner":
      return Risk(name: "Can", level: "Low")
    case "srirambackpack":
      return Risk(name: "Backpack", level: "High")
    case "googlebottle":
      return Risk(name: "Bottle", level: "Medium")
    case "twitterbook":
      return Risk(name: "Book", level: "Low")
    case "quorabag":
      return Risk(name: "Bag", level: "Medium")
    case "oculusbox":
      return Risk(name: "Box", level: "High")
    case "cords":
      return Risk(name: "Cords", level: "High")
    default:
      return nil
    }
  }

}
