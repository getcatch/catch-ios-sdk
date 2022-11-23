//
//  BaseEarnRedeemWidget.swift
//  Catch
//
//  Created by Lucille Benoit on 11/18/22.
//

import Foundation

public class BaseEarnRedeemWidget: BaseWidget {
    // MARK: - Info Button Properties

    lazy internal var infoButton = InfoButton(style: infoButtonStyle)
    internal var infoButtonStyle: NSAttributedStringStyle
    internal var viewModel: BaseEarnRedeemWidgetViewModel?

    // MARK: - Initializers

    /**
     Internal initializer prevents others from initializing the BaseEarnRedeemWidget class directly.
     */
    override internal init(config: BaseWidgetConfig) {
        self.infoButtonStyle = NSAttributedStringStyle(font: CatchFont.infoButton, lineSpacing: 0)

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

    }

    internal func didTapInfoButton() {

    }

    private func configureInfoButton() {
        infoButton.setStyle(NSAttributedStringStyle.infoButtonStyle(theme: theme))
    }
}
