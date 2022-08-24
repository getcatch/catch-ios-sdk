// swiftlint:disable line_length
//
//  AppDelegate.swift
//  Example
//
//  Created by Lucille Benoit on 8/22/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if #unavailable(iOS 13) {

            self.window = UIWindow()

            let vc = ViewController()
            self.window?.rootViewController = vc

            self.window?.makeKeyAndVisible()

        }

        return true

    }

}
