// swiftlint:disable line_length
//
//  AppDelegate.swift
//  Example
//
//  Created by Lucille Benoit on 8/22/22.
//

import Catch
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

        let options = CatchOptions(theme: .lightColor, environment: .sandbox, useCatchFonts: true)

        // The Catch SDK should be initialized only once on application launch.

        Catch.initialize(publicKey: Constant.publicKey, options: options) { result in
            if case let .failure(error) = result {
                print("Initialization failed with \(error)")
            }
        }

        return true

    }

}
