//
//  UserRepository.swift
//  
//
//  Created by Lucille Benoit on 10/19/22.
//

import Foundation

protocol UserRepositoryInterface {
    func getCurrentUser() -> WidgetContentPublicUserData?
    func getDeviceToken() -> String?
    func saveDeviceToken(_ token: String)
    func saveUserData(_ widgetUserData: WidgetContentPublicUserData)
}

class UserRepository: UserRepositoryInterface {
    private let keyChain: KeyChainInterface
    private let notificationCenter: NotificationCenter

    private var user: WidgetContentPublicUserData?

    internal var didFetchUserData: Bool = false
    internal var merchantId: String?

    // MARK: - Initializers

    init(keyChain: KeyChainInterface = KeyChainManager(),
         notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.keyChain = keyChain
        self.notificationCenter = notificationCenter
    }

    // MARK: - Repository Operations

    func getCurrentUser() -> WidgetContentPublicUserData? {
        return user
    }

    func getDeviceToken() -> String? {
        return keyChain.loadString(forKey: Constant.deviceTokenKeyChainService)
    }

    func saveDeviceToken(_ token: String) {
        /*
         Once a device token has already been generated and saved don't overwrite it
         since it acts as the unique identifier used to access the user's public data.
         */
        guard getDeviceToken() == nil else { return }
        _ = keyChain.saveString(token, forKey: Constant.deviceTokenKeyChainService)
        notificationCenter.post(name: NotificationName.deviceTokenUpdate, object: nil)
    }

    func saveUserData(_ widgetUserData: WidgetContentPublicUserData) {
        user = widgetUserData
    }
}
