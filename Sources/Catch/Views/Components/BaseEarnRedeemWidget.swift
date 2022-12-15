//
//  BaseEarnRedeemWidget.swift
//  Catch
//
//  Created by Lucille Benoit on 11/18/22.
//

import Foundation

public class BaseEarnRedeemWidget: BaseWidget, InfoButtonDelegate, TofuPresenting {
    // MARK: - Info Button Properties

    lazy internal var infoButton = InfoButton(style: infoButtonStyle)
    internal var infoButtonStyle: TextStyle {
        resolvedLabelWidgetStyling?.infoButtonStyle ?? TextStyle()
    }
    internal var viewModel: BaseEarnRedeemWidgetViewModel?
    internal var resolvedLabelWidgetStyling: InfoWidgetStyle? { return resolvedStyling as? InfoWidgetStyle }

    // MARK: - Initializers

    /**
     Internal initializer prevents others from initializing the BaseEarnRedeemWidget class directly.
     */
    override internal init(config: BaseWidgetConfig) {
        super.init(config: config)
        configureInfoButton()
    }

    @available(*, unavailable)
    required internal init?(coder: NSCoder) { nil }

    // MARK: - Public Functions

    public func setPrice(_ price: Int) {
        label.isLoading = true
        viewModel?.updatePrice(price)
    }

    public func setBorderStyle(_ borderStyle: BorderStyle) {
        self.borderStyle = borderStyle
    }

    // MARK: - Internal Functions

    override internal func didUpdateTheme() {
        super.didUpdateTheme()
        configureInfoButton()
    }

    override internal func initializeViewModel(config: BaseWidgetConfig) {
        self.viewModel = BaseEarnRedeemWidgetViewModel(config: config, delegate: self)
    }

    override internal func didTapEarnRedeemLabel() {
        presentTofu(path: .breakdown)
    }

    internal func didTapInfoButton() {
        presentTofu(path: .howItWorks)
    }

    private func configureInfoButton() {
        infoButton.delegate = self
        infoButton.setStyle(infoButtonStyle)
    }

    private func presentTofu(path: TofuPath) {
        if let tofuData = viewModel?.rewardsResult {
            presentTofuModal(rewards: tofuData, path: path)
        }
    }
}
