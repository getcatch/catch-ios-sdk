// swiftlint:disable identifier_name type_name
//
//  Catch.swift
//
//
//  Created by Lucille Benoit on 9/14/22.
//

import Foundation

public let Catch = _Catch.sharedInstance

public class _Catch {

    static let sharedInstance = _Catch()

    private var options: CatchOptions = CatchOptions(theme: .lightColor,
                                                     environment: .sandbox,
                                                     useCatchFonts: true)
    private var merchantRepository: MerchantRepositoryInterface

    // This prevents others from using the default '()' initializer for this class.
    private init() {
        let merchantNetworkService = MerchantNetworkService()
        let merchantLocalStorage = MerchantCache()
        merchantRepository = MerchantRepository(networkService: merchantNetworkService,
                                                cache: merchantLocalStorage)
    }

    /**
     Initializes the Catch SDK. This should only be called once in the application's lifecycle.
     If the provided publicKey is invalid, initialization will not succeed.
     Applications may handle this scenario using the completion handler.
     - Parameter publicKey: A string representing the merchant's public API key.
     - Parameter options: An object which specifies optional configuration settings to
     control the global behavior of the Catch SDK. If options is omitted, the Catch SDK will fallback to default values.
     - Parameter completion: A callback function to handle the success or failure of initialization.
     */
    public func initialize(publicKey: String,
                           options: CatchOptions = CatchOptions(),
                           completion: @escaping (Result<Bool, Error>) -> Void) {

        guard !publicKey.isEmpty else { return }

        if options.useCatchFonts {
            CatchFontLoader.registerFonts()
        }

        merchantRepository.fetchMerchant(from: publicKey) { result in
            completion(result)
        }
    }

    internal var environmentHost: String {
        options.environment.host
    }
}
