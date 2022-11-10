//
//  MerchantSubscribing.swift
//  Catch
//
//  Created by Lucille Benoit on 11/7/22.
//

import UIKit

var merchantNotificationKey = "merchantNotificationToken"

protocol MerchantSubscribing: AnyObject {
    func handleMerchantNotification(merchant: Merchant)
}

/**
 Protocol to allow classes to listen and respond to merchant updates.
 */
extension MerchantSubscribing {

    var notificationName: Notification.Name {
        NotificationName.merchantUpdate
    }

    // We need to store the notification token in order to remove the observer
    // for block-based notification subscriptions.

    var notificationToken: NSObjectProtocol? {
        get {
            return objc_getAssociatedObject(self, &merchantNotificationKey) as? NSObjectProtocol
        }
        set {
            objc_setAssociatedObject(self, &merchantNotificationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func subscribeToMerchantUpdates() {
        let token = NotificationCenter.default.addObserver(forName: notificationName,
                                                           object: nil,
                                                           queue: nil) { [weak self] notification in
            if let merchant = notification.object as? Merchant {
                self?.handleMerchantNotification(merchant: merchant)
            }
        }
        notificationToken = token
    }

    func unsubscribeFromMerchantUpdates() {
        if let token = notificationToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
}
