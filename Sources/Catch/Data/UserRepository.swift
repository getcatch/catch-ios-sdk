//
//  UserRepository.swift
//  
//
//  Created by Lucille Benoit on 10/19/22.
//

import Foundation

class UserRepository {

    private let userNetworkService: UserNetworkServiceInterface
    private let keyChain: KeyChainInterface
    private let notificationCenter: NotificationCenter

    private var user: PublicUserData? {
        didSet {
            if oldValue != user {
                notificationCenter.post(name: Notification.Name(NotificationName.publicUserDataUpdate), object: nil)
            }
        }
    }

    // MARK: - Initializers

    init(networkService: UserNetworkServiceInterface = UserNetworkService(),
         keyChain: KeyChainInterface = KeyChainManager(),
         notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.userNetworkService = networkService
        self.keyChain = keyChain
        self.notificationCenter = notificationCenter
    }

    // MARK: - Repository Operations

    func getCurrentUser() -> PublicUserData? {
        return user
    }

    func getDeviceToken() -> String? {
        return keyChain.loadString(forKey: Constant.deviceTokenKeyChainService)
    }

    func saveDeviceToken(_ token: String) {
        guard getDeviceToken() == nil else { return } // do not overwrite existing device token
        _ = keyChain.saveString(token, forKey: Constant.deviceTokenKeyChainService)
    }

    func fetchUserData(merchantId: String) {
        if let token = getDeviceToken() {
            userNetworkService.fetchUserData(deviceToken: token, merchantId: merchantId) { [weak self] result in
                if case let .success(publicUserData) = result {
                    self?.user = publicUserData
                }
            }
        }
    }
}
