//
//  TofuPath.swift
//  Catch
//
//  Created by Lucille Benoit on 11/10/22.
//

import Foundation

/**
 Paths to the different configurations of the tofu modal: how it works, earn more and earnings breakdown.
 */
enum TofuPath: String, Codable {
    case howItWorks = ""
    case breakdown = "breakdown"
    case earnMore = "earn-more"
}
