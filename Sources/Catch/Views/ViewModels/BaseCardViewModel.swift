//
//  BaseCardViewModel.swift
//  Catch
//
//  Created by Lucille Benoit on 11/22/22.
//

import Foundation

protocol MerchantRespondingDelegate: AnyObject {
    func updateMerchantViews()
}
/**
 Base view model class for  merchant card-based widgets.
 */
class BaseCardViewModel: NotificationResponding {
    internal weak var merchantUpdatingDelegate: MerchantRespondingDelegate?
    internal var merchantPublicKey: String?
    internal var merchant: Merchant?
    internal var merchantName: String {
        merchant?.name ?? LocalizedString.thisStore.localized
    }

    init(merchantRepository: MerchantRepositoryInterface = Catch.merchantRepository) {
        self.merchant = merchantRepository.getCurrentMerchant()
        self.merchantPublicKey = merchantRepository.merchantPublicKey
        subscribeToMerchantUpdates()
    }

    func didReceiveNotification(_ notification: Notification) {
        if let merchant = notification.object as? Merchant {
            self.merchant = merchant
            merchantUpdatingDelegate?.updateMerchantViews()
        }
    }

    deinit {
        unsubscribeFromNotifications()
    }
}
