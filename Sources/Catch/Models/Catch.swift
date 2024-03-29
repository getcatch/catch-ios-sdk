//
//  Catch.swift
//
//
//  Created by Lucille Benoit on 9/14/22.
//

import UIKit

/// The Catch SDK shared instance.
public let Catch = _Catch.sharedInstance // swiftlint:disable:this identifier_name

public class _Catch { // swiftlint:disable:this type_name

    static let sharedInstance = _Catch()

    private var options: CatchOptions = CatchOptions(theme: .lightColor,
                                                     environment: .sandbox,
                                                     useCatchFonts: true)

    internal var merchantRepository: MerchantRepositoryInterface
    internal var userRepository: UserRepositoryInterface
    internal var rewardsCalculator: RewardsCalculatorInterface {
        return RewardsCalculator(userRepository: userRepository, merchantRepository: merchantRepository)
    }
    internal var environmentHost: String {
        options.environment.host
    }

    private let notificationCenter: NotificationCenter = NotificationCenter.default

    // This prevents others from using the default '()' initializer for this class.
    private init() {
        let merchantNetworkService = MerchantNetworkService()
        let merchantLocalStorage = MerchantCache()
        merchantRepository = MerchantRepository(networkService: merchantNetworkService,
                                                cache: merchantLocalStorage)
        userRepository = UserRepository()
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
        self.options = options

        if options.useCatchFonts {
            CatchFontLoader.registerFonts()
        }

        merchantRepository.fetchMerchant(from: publicKey) { result in
            completion(result)
        }
    }

    /**
     Changes the current value of the default theme. The theme parameter accepts the same
     enumeration of values that can be used for the theme option when initializing the SDK.
     - Parameter theme: The Catch preset color theme.
     */
    public func setTheme(_ theme: Theme) {
        options.theme = theme
        notificationCenter.post(name: NotificationName.globalThemeUpdate, object: theme)
    }

    /**
     Opens the checkout flow given a checkout id.
     - Parameter checkoutId: The unique identifier for the checkout
     - Parameter options: Prefill values and callback functions for checkout confirmed or canceled.
     */
    public func openCheckout(checkoutId: String,
                             options: OpenCheckoutOptions) {
        guard let webController = DirectCheckoutController(checkoutId: checkoutId, options: options) else { return }
        presentCheckoutController(webController)
    }

    /**
     Create and opens the virtual card checkout flow.
     - Parameter checkoutData: The order data for the checkout.
     - Parameter options: Prefill values and callback functions for checkout confirmed or canceled.
     */
    public func createAndOpenVirtualCardCheckout(checkoutData: CreateVirtualCardCheckoutBody,
                                                 options: VirtualCardCheckoutOptions) {
        guard let webController = VirtualCardCheckoutController(
            checkoutData: checkoutData,
            options: options) else { return }
        presentCheckoutController(webController)
    }

    internal func getTheme() -> Theme {
        return options.theme
    }

    internal func getGlobalStyleOverrides() -> CatchStyleConfig? {
        return options.globalStyleOverrides
    }

    private func presentCheckoutController(_ controller: CheckoutController) {
        controller.modalPresentationStyle = .overFullScreen
        UIApplication.topViewController()?.present(controller, animated: true)
    }
}
