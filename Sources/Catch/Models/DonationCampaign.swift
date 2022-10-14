//
//  DonationCampaign.swift
//  
//
//  Created by Lucille Benoit on 9/15/22.
//

import Foundation

struct DonationCampaign: Codable {
    let enabled: Bool
    let donationRecipient: DonationRecipient?
}
