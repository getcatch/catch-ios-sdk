//
//  UserRepository.swift
//  
//
//  Created by Lucille Benoit on 10/19/22.
//

import Foundation

protocol UserRepositoryInterface {
    var didFetchUserData: Bool { get }
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
            notificationCenter.post(name: NotificationName.publicUserDataUpdate, object: nil)
            didFetchUserData = true
        }
    }

    internal var didFetchUserData: Bool = false

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
                    completion(.success(publicUserData))
                    self?.user = publicUserData
                } else {
                    self?.user = PublicUserData.noData
                    completion(.failure(NetworkError.requestError(.invalidDeviceToken(token))))
                }
            }
        } else {
            // Default back to a new user with no credits if no device token is found
            user = PublicUserData.noData
            completion(.failure(NetworkError.requestError(.invalidDeviceToken(nil))))
        }
    }
}
