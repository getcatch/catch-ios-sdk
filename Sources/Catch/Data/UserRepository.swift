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
    func saveDeviceToken(_ token: String, override: Bool)
    func saveUserData(_ widgetUserData: WidgetContentPublicUserData)
}

class UserRepository: UserRepositoryInterface {
    private let keyChain: KeyChainInterface
    private let notificationCenter: NotificationCenter

    private var user: WidgetContentPublicUserData?

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

    /*
     Save the device token to keychain.

     If a device token was already generated and saved, we only overwrite it
     if the override flag is true.
     */
    func saveDeviceToken(_ token: String, override: Bool) {
        // If the token is the same as what we have already stored, no need to continue.
        guard token != getDeviceToken() else { return }

        // If we already have a token and do not wish to override, no need to continue.
        if getDeviceToken() != nil && !override  { return }

        // Save the token, reset the user, and send a notification indicating token was updated.
        _ = keyChain.saveString(token, forKey: Constant.deviceTokenKeyChainService)
        user = nil
        notificationCenter.post(name: NotificationName.deviceTokenUpdate, object: nil)
    }

    func saveUserData(_ widgetUserData: WidgetContentPublicUserData) {
        user = widgetUserData
    }
}
