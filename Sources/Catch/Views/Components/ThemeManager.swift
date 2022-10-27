//
//  ThemeManager.swift
//  Catch
//
//  Created by Lucille Benoit on 10/23/22.
//

import UIKit

protocol ThemeResponding: UIView {
    var theme: Theme { get set }
    var themeManager: ThemeManager { get set }
    func setTheme(_ theme: Theme)
}

class ThemeManager {
    weak var delegate: ThemeResponding?

    private let notificationName = Notification.Name(NotificationName.globalThemeUpdate)
    private var notificationCenter: NotificationCenter

    private var overrideGlobalTheme: Bool = false {
        didSet {
            if oldValue != overrideGlobalTheme && overrideGlobalTheme == true {
                unsubscribeFromGlobalThemeUpdates()
            }
        }
    }

    init(_ initialTheme: Theme?,
         notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.notificationCenter = notificationCenter

        overrideGlobalTheme = initialTheme != nil
        if !overrideGlobalTheme {
            subscribeToGlobalThemeUpdates()
        }
    }

    func subscribeToGlobalThemeUpdates() {
        notificationCenter.addObserver(self,
                                       selector: #selector(handleGlobalThemeNotification),
                                       name: notificationName,
                                       object: nil)
    }

    func updateTheme(_ theme: Theme) {
        overrideGlobalTheme = true
        guard let delegate = delegate else {
            return
        }

        for subview in delegate.subviews {
            if let themeRespondingSubview = subview as? ThemeResponding {
                themeRespondingSubview.setTheme(theme)
            }
        }

        delegate.theme = theme
    }

    // MARK: - Private Helpers

    @objc private func handleGlobalThemeNotification(_ notification: Notification) {
        if !overrideGlobalTheme, let globalTheme = notification.object as? Theme {
            delegate?.theme = globalTheme
        }
    }

    private func unsubscribeFromGlobalThemeUpdates() {
        notificationCenter.removeObserver(self)
    }
}
