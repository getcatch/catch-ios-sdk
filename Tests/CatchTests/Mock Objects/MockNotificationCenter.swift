//
//  MockNotificationCenter.swift
//  
//
//  Created by Lucille Benoit on 10/18/22.
//

import XCTest
@testable import Catch

class MockNotificationCenter: NotificationCenter {
    private var lastNotificationPosted: NSNotification.Name?

    override func post(name aName: NSNotification.Name, object anObject: Any?) {
        lastNotificationPosted = aName
    }

    func didPostNotifcation(with name: NSNotification.Name? = nil) -> Bool {
        guard let notificationName = name else { return false }
        return notificationName == lastNotificationPosted
    }
}
