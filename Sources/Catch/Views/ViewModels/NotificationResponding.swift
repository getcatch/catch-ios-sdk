//
//  NotificationResponding.swift
//  Catch
//
//  Created by Lucille Benoit on 10/23/22.
//

import UIKit

var notificationTokensKey = "notificationTokens"

protocol NotificationResponding: AnyObject {
    func didReceiveNotification(_ notification: Notification)
}

extension NotificationResponding {

    // We need to store the notification token in order to remove the observer
    // for block-based notification subscriptions.

    var notificationTokens: [NSObjectProtocol]? {
        get {
            return objc_getAssociatedObject(self, &notificationTokensKey) as? [NSObjectProtocol]
        }
        set {
            objc_setAssociatedObject(self, &notificationTokensKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func subscribeToGlobalThemeUpdates() {
        subscribeToNotifications(notifications: [NotificationName.globalThemeUpdate])
    }

    func subscribeToMerchantUpdates() {
        subscribeToNotifications(notifications: [NotificationName.merchantUpdate])
    }

    func subscribeToNotifications(notifications: [Notification.Name]) {
        for notification in notifications {
            let token = NotificationCenter.default.addObserver(forName: notification,
                                                               object: nil,
                                                               queue: nil) { [weak self] notification in
                self?.handleNotification(notification)
            }
            let currentTokens = notificationTokens ?? [] + [token]
            notificationTokens = currentTokens
        }
    }

    func unsubscribeFromNotifications() {
        for token in notificationTokens ?? [] {
            NotificationCenter.default.removeObserver(token)
        }
    }
}

private extension NotificationResponding {
    func handleNotification(_ notification: Notification) {
        didReceiveNotification(notification)
    }
}
