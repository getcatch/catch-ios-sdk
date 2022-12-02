//
//  TooltipViewController.swift
//  Catch
//
//  Created by Lucille Benoit on 11/3/22.
//

import Foundation

/**
 A wrapper controller around TooltipView 
 */
class TooltipViewController: UIViewController {
    init(text: String, highlightText: String, theme: Theme, delegate: TooltipDelegate) {
        super.init(nibName: nil, bundle: nil)
        let tooltipView = TooltipView(text: text, actionText: highlightText, theme: theme)
        tooltipView.delegate = delegate
        view = tooltipView
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
