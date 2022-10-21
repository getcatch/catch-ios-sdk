//
//  UserRepository.swift
//  
//
//  Created by Lucille Benoit on 10/19/22.
//

import Foundation

protocol UserRepositoryInterface {
    func getCurrentUser() -> PublicUserData?
    func getDeviceToken() -> String?
    func saveDeviceToken(_ token: String)
    func fetchUserData(merchantId: String, completion: @escaping (Result<PublicUserData, Error>) -> Void)
}

class UserRepository: UserRepositoryInterface {

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
        /*
         Once a device token has already been generated and saved don't overwrite it
         since it acts as the unique identifier used to access the user's public data.
         */
        guard getDeviceToken() == nil else { return }
        _ = keyChain.saveString(token, forKey: Constant.deviceTokenKeyChainService)
    }

    func fetchUserData(merchantId: String, completion: @escaping (Result<PublicUserData, Error>) -> Void = {_ in }) {
        if let token = getDeviceToken() {
            userNetworkService.fetchUserData(deviceToken: token, merchantId: merchantId) { [weak self] result in
                if case let .success(publicUserData) = result {
                    self?.user = publicUserData
                    completion(.success(publicUserData))
                } else {
                    completion(.failure(NetworkError.requestError(.invalidDeviceToken(token))))
                }
            }
        } else {
            completion(.failure(NetworkError.requestError(.invalidDeviceToken(nil))))
        }
    }
}
