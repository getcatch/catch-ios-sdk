//
//  ThemeResponding.swift
//  Catch
//
//  Created by Lucille Benoit on 10/23/22.
//

import UIKit

var themeNotificationTokenKey = "themeNotificationToken"

protocol ThemeResponding: UIView {
    var theme: Theme { get set }
    func setTheme(_ theme: Theme)
}

extension ThemeResponding {

    var notificationName: Notification.Name {
        Notification.Name(NotificationName.globalThemeUpdate)
    }

    // We need to store the notification token in order to remove the observer
    // for block-based notification subscriptions.

    var notificationToken: NSObjectProtocol? {
        get {
            return objc_getAssociatedObject(self, &themeNotificationTokenKey) as? NSObjectProtocol
        }
        set {
            objc_setAssociatedObject(self, &themeNotificationTokenKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func subscribeToGlobalThemeUpdates() {
        let token = NotificationCenter.default.addObserver(forName: notificationName,
                                                           object: nil,
                                                           queue: nil) { [unowned self] notification in
            self.handleGlobalThemeNotification(notification)
        }
        notificationToken = token
    }

    func updateLocalTheme(_ theme: Theme) {
        unsubscribeFromGlobalThemeUpdates()
        self.theme = theme

        for subview in subviews {
            if let themeRespondingSubview = subview as? ThemeResponding {
                themeRespondingSubview.setTheme(theme)
            }
        }
    }
}

private extension ThemeResponding {
    func handleGlobalThemeNotification(_ notification: Notification) {
        if let globalTheme = notification.object as? Theme {
            theme = globalTheme
        }
    }

    func unsubscribeFromGlobalThemeUpdates() {
        if let token = notificationToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
}
