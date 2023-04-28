//
//  NotificationName.swift
//  
//
//  Created by Lucille Benoit on 10/18/22.
//

import UIKit

enum NotificationName {
    static let publicUserDataUpdate = Notification.Name("PublicUserDataUpdate")
    static let globalThemeUpdate = Notification.Name("GlobalThemeUpdate")
    static let merchantUpdate = Notification.Name("MerchantUpdate")
    static let applicationDidBecomeActive = UIApplication.didBecomeActiveNotification
}
