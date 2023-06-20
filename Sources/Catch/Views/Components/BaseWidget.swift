// swiftlint:disable type_name
//
//  BaseWidget.swift
//  Catch
//
//  Created by Lucille Benoit on 10/28/22.
//

import UIKit

public class _BaseWidget: UIView, NotificationResponding, BorderConfiguring, BaseWidgetDelegate {

    // MARK: - Subviews
    internal let stack: UIStackView = UIStackView()
    internal var logo: CatchLogo
    lazy internal var label: EarnRedeemLabel = EarnRedeemLabel(type: earnRedeemLabelType,
                                                               style: theme.earnRedeemLabelStyle(size: .small))
    internal var earnRedeemLabelType: EarnRedeemLabelType

    // MARK: - View Configuration Properties

    internal var theme: Theme {
        didSet {
            didUpdateTheme()
        }
    }

    internal var didSetLocalTheme: Bool
    internal var styleOverrides: WidgetStyle?
    internal var widgetType: StyleResolver.WidgetType {
        fatalError("Subclass of BaseWidget must override widget type")
    }

    internal final var resolvedStyling: WidgetStyle?

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
    internal var orderedSubviews: [UIView] { return [] }

    override public var intrinsicContentSize: CGSize {
        let stackContentSize = stack.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: stackContentSize.width + insets.left + insets.right,
                      height: stackContentSize.height + insets.top + insets.bottom)
    }

    // MARK: - Initializers

    /**
     Internal initializer prevents others from initializing the BaseWidget class directly.
     */
    internal init(config: BaseWidgetConfig) {
        self.theme = config.theme ?? Catch.getTheme()
        self.didSetLocalTheme = config.theme != nil
        self.styleOverrides = config.styleOverrides
        self.borderStyle = config.borderConfig.style ?? .none
        self.insets = config.borderConfig.insets
        self.logo = CatchLogo(theme: config.theme)
        self.earnRedeemLabelType = config.earnRedeemLabelConfig

        super.init(frame: .zero)
        resolveWidgetStyle()
        initializeViewModel(config: config)
        stack.translatesAutoresizingMaskIntoConstraints = false
        configureSubviews()
        if config.theme == nil {
            subscribeToGlobalThemeUpdates()
        }
    }
    @objc
    required internal init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    public func setTheme(_ theme: Theme) {
        didSetLocalTheme = true
        unsubscribeFromNotifications()
        self.theme = theme
    }

    // MARK: - Internal Functions

    internal func didReceiveNotification(_ notification: Notification) {
        if let globalTheme = notification.object as? Theme {
            theme = globalTheme
        }
    }

    internal func initializeViewModel(config: BaseWidgetConfig) {
        fatalError("Subclass of BaseWidget must implement initialize view model")
    }

    internal func didUpdateTheme() {
        resolveWidgetStyle()
        label.style = createBenefitTextStyle()
        layer.borderColor = theme.borderColor
        logo.setTheme(theme)
    }

    internal func createBenefitTextStyle() -> EarnRedeemLabelStyle {
        return resolvedStyling?.earnRedeemLabelStyle() ?? theme.earnRedeemLabelStyle(size: .small)
    }

    // MARK: - AutoLayout

    internal func setConstraints() {
        let stackConstraints = [
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: insets.left),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -insets.right),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: insets.top),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -insets.bottom)
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
        invalidateIntrinsicContentSize()
    }

    func updateEarnRedeemMessage(reward: Reward, type: EarnRedeemLabelType) {
        // Ensures UI updates are completed on the main thread
        DispatchQueue.main.async { [weak self] in
            self?.label.updateData(reward: reward, type: type)
        }
    }
    // handler for tap on link in earn redeem label
    internal func didTapEarnRedeemLabel() {}
}

// MARK: - Private Helpers

private extension _BaseWidget {

    func configureEarnRedeemLabel() {
        label = EarnRedeemLabel(type: earnRedeemLabelType,
                                style: createBenefitTextStyle())
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

    func resolveWidgetStyle() {
        let localTheme  = didSetLocalTheme ? theme : nil
        resolvedStyling = StyleResolver.resolved(widgetType: widgetType,
                                                 localTheme: localTheme,
                                                 localOverrides: styleOverrides)
    }
}
// swiftlint:enable type_name
