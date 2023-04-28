//
//  SceneDelegate.swift
//  Example
//
//  Created by Lucille Benoit on 8/22/22.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        let viewController = ViewController()
        let navigation = UINavigationController(rootViewController: viewController)

        window.rootViewController = navigation

        self.window = window
        window.makeKeyAndVisible()

    }
}
