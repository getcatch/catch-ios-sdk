//
//  JSScript.swift
//  Catch
//
//  Created by Lucille Benoit on 11/15/22.
//

import Foundation

/**
 Used to generate Javascript scripts  which can be injected into WKWebViews.
 */
enum JSScript {
    /// Gets an item with the given name from local storage.
    case getLocalStorageItem(name: String)
    /// Sets a value in local storage for an item with the given name.
    case setLocalStorageItem(name: String, value: String)
    /// Forwards post messages to the webkit message handler with the given name.
    case addPostMessageListener(name: String)
    /// Sends a post message to the webview with a given action and data.
    case postMessage(action: PostMessageAction, dataObject: [String: Any])

    /// String value for the JS script
    var value: String? {
        switch self {
        case .getLocalStorageItem(let name):
            return String(format: JSScriptFormat.getLocalStorageItem, name)
        case .setLocalStorageItem(let name, let value):
            return String(format: JSScriptFormat.setLocalStorageItem, name, value)
        case .addPostMessageListener(let name):
            return String(format: JSScriptFormat.addPostMessageListener, name)
        case .postMessage(let action, let dataObject):
            return postMessageScript(action: action, dataObject: dataObject)
        }
    }

    private func postMessageScript(action: PostMessageAction, dataObject: [String: Any]) -> String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dataObject, options: []),
              let jsonString = String(data: jsonData, encoding: .utf8) else { return nil }
        return String(format: JSScriptFormat.postMessage, action.rawValue, jsonString)
    }

    static let deviceTokenKey = "device_token"
    static let actionKey = "action"
    static let dataKey = "data"
}
