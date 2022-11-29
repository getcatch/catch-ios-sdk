//
//  JSScriptFormat.swift
//  Catch
//
//  Created by Lucille Benoit on 11/15/22.
//

import Foundation

/**
 Formats for all Javascript scripts injected into our web views.
 */
enum JSScriptFormat {
    static let getLocalStorageItem = "localStorage.getItem(\"%@\")"
    static let setLocalStorageItem = "localStorage.setItem(\"%@\", \"%@\")"
    static let addPostMessageListener = """
        window.addEventListener('message', (event) => \
        window.webkit.messageHandlers.%@.postMessage(event.data))
    """
    static let postMessage = "window.postMessage({action: \"%@\", data: %@})"
}
