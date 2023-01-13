//
//  Platform.swift
//  Catch
//
//  Created by Lucille Benoit on 12/13/22.
//

import Foundation

/**
 Contains the name and version of the platform in use.
 */
public struct Platform: Codable {
    /// Name of the platform the merchant is on.
    let platformType: String?

    /// Version of the platform the merchant is on.
    let platformVersion: String?

    /// Initializes a Platform object which contains the name and version of the platform in use.
    public init(platformType: String?, platformVersion: String?) {
        self.platformType = platformType
        self.platformVersion = platformVersion
    }
}
