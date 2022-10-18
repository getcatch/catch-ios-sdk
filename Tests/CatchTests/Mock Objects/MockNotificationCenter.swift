//
//  MockNotificationCenter.swift
//  
//
//  Created by Lucille Benoit on 10/18/22.
//

import XCTest
@testable import Catch

class MockNotificationCenter: NotificationCenter {
    private var lastNotificationPosted: String = String()

    override func post(name aName: NSNotification.Name, object anObject: Any?) {
        lastNotificationPosted = aName.rawValue
    }

    func didPostNotifcation(with name: String = String()) -> Bool {
        return name.isEmpty
        ? !lastNotificationPosted.isEmpty
        : name == lastNotificationPosted
    }
}
