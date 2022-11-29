//
//  CampaignLinkDemo.swift
//
//  Created by Lucille Benoit on 11/9/22.
//

import Catch
import UIKit

class CampaignLinkDemo: WidgetDemo {

    let campaignLinkView = CampaignLink(campaignName: Constant.campaignName)

    init() {
        super.init(title: Constant.campaignLinkName, widget: campaignLinkView)
    }

    @available(*, unavailable)
    required internal init?(coder: NSCoder) { nil }
}
