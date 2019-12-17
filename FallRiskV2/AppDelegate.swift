//
//  AppDelegate.swift
//  FallRiskAR
//
//  Created by Arjun Arun on 12/1/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import ARKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    guard ARImageTrackingConfiguration.isSupported,
      ARWorldTrackingConfiguration.isSupported else {
      fatalError("ARKit Unsupported.")
    }

    return true
  }
}
