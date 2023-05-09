//
//  WidgetContent.swift
//  Catch
//
//  Created by Lucille Benoit on 4/17/23.
//

import Foundation

struct WidgetContent: Codable {
    let earnedRewards: EarnedRewardsSummary?
    let publicUserData: WidgetContentPublicUserData
}
