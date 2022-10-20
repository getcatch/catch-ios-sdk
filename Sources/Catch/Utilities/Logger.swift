//
//  Logger.swift
//  
//
//  Created by Lucille Benoit on 10/10/22.
//

import Foundation

final class Logger {
    init() { }

    func log(error: Error) {
        #if DEBUG
        print("------------- ERROR -------------")
        print("\(error)")
        #endif
    }
}
