//
//  PostMessageHandler.swift
//  Catch
//
//  Created by Lucille Benoit on 11/14/22.
//

import WebKit

protocol PostMessageHandler: AnyObject {
    func handlePostMessage(_ postMessage: PostMessageAction, data: Any?)
}
