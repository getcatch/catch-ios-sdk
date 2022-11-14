//
//  BaseWidget.swift
//  Catch
//
//  Created by Lucille Benoit on 10/28/22.
//

import UIKit

public class BaseWidget: UIView, ThemeResponding, BorderConfiguring, BaseWidgetDelegate {

    // MARK: - Subviews
    internal let stack: UIStackView = UIStackView()
    internal var logo: CatchLogo
    lazy internal var label: EarnRedeemLabel = EarnRedeemLabel(type: .expressCheckoutCallout,
                                                          style: EarnRedeemLabel.Style(),
                                                          tapHandler: {})

    // MARK: - View Configuration Properties

    internal var theme: Theme {
        didSet {
            didUpdateTheme()
        }
    }

    internal var borderStyle: BorderStyle {
        didSet {
            configureBorder(viewHeight: bounds.height, theme: theme)
        }
    }

    internal var additionalConstraints: [NSLayoutConstraint] {
        return [
            logo.heightAnchor.constraint(equalToConstant: label.intrinsicContentSize.height)
        ]
    }

    internal var insets: UIEdgeInsets
    internal var infoButtonStyle: NSAttributedStringStyle
    internal var orderedSubviews: [UIView] { return [] }
    internal var viewModel: BaseWidgetViewModelInterface?

    // MARK: - Initializers

    /**
     Internal initializer prevents others from initializing the BaseWidget class directly.
     */
    internal init(config: BaseWidgetConfig) {
        self.theme = config.theme ?? .lightColor
        self.borderStyle = config.borderConfig.style ?? .none
        self.infoButtonStyle = NSAttributedStringStyle(font: CatchFont.infoButton, lineSpacing: 0)
        self.insets = config.borderConfig.insets
        self.logo = CatchLogo(theme: theme)

        super.init(frame: .zero)
        initializeViewModel(config: config)
        stack.translatesAutoresizingMaskIntoConstraints = false
        configureSubviews()
        if config.theme == nil {
            subscribeToGlobalThemeUpdates()
        }
    }

    required internal init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    public func setTheme(_ theme: Theme) {
        updateLocalTheme(theme)
    }

    public func setPrice(_ price: Int) {
        label.isLoading = true
        viewModel?.updatePrice(price)
    }

    public func setBorderStyle(_ borderStyle: BorderStyle) {
        self.borderStyle = borderStyle
    }

    // MARK: - Internal Functions

    internal func initializeViewModel(config: BaseWidgetConfig) {
        self.viewModel = BaseWidgetViewModel(config: config, delegate: self)
    }

    internal func didUpdateTheme() {
        label.style = createBenefitTextStyle()
        layer.borderColor = theme.borderColor
        logo.setTheme(theme)
    }

    internal func createBenefitTextStyle() -> EarnRedeemLabel.Style {

        let earnStyle = NSAttributedStringStyle(font: CatchFont.linkSmall,
                                                textColor: theme.accentColor,
                                                isTappable: true)
        let redeemStyle = NSAttributedStringStyle(font: CatchFont.linkSmall,
                                                  textColor: theme.secondaryAccentColor,
                                                  isTappable: true)
        let fillerTextStyle = NSAttributedStringStyle(font: CatchFont.bodySmall,
                                                      textColor: theme.foregroundColor)
        return EarnRedeemLabel.Style(filler: fillerTextStyle, earn: earnStyle, redeem: redeemStyle)
    }

    // MARK: - AutoLayout

    internal func setConstraints() {
        let stackConstraints = [
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
            stack.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
        ]
        let constraints = stackConstraints + additionalConstraints
        NSLayoutConstraint.activate(constraints)
    }

    /**
     Configure the axis, alignment, distribution and spacing for the stacked subviews
     */
    internal func configureStack() {
        fatalError("Subclass of BaseWidget must implement configure stack")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        // Configure border after subviews have been laid out so that correct view height is used.
        configureBorder(viewHeight: bounds.height, theme: theme)
    }

    func updateEarnRedeemMessage(reward: Reward, type: EarnRedeemLabelType) {
        // Ensures UI updates are completed on the main thread
        DispatchQueue.main.async { [weak self] in
            self?.label.updateData(reward: reward, type: type)
        }
    }
}

// MARK: - Private Helpers

private extension BaseWidget {

    func configureEarnRedeemLabel() {
        guard let type = viewModel?.earnRedeemLabelType else { return }
        label = EarnRedeemLabel(type: type,
                                style: createBenefitTextStyle(),
                                tapHandler: {

        })
        label.sizeToFit()
    }

    func configureSubviews() {
        logo.translatesAutoresizingMaskIntoConstraints = false
        configureEarnRedeemLabel()

        for subview in orderedSubviews {
            stack.addArrangedSubview(subview)
        }
        label.setContentCompressionResistancePriority(.required, for: .horizontal)

        configureStack()
        addSubview(stack)

        setConstraints()
    }
}
