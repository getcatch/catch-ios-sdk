//
//  PriceSlider.swift
//  Example
//
//  Created by Lucille Benoit on 11/3/22.
//

import UIKit

// MARK: - PRICE SLIDER

protocol PriceSliderDelegate: AnyObject {
    func updatePrice(price: Int)
}

class PriceSlider: UIView {
    weak var delegate: PriceSliderDelegate?

    var price: Int {
        return Int(slider.value) * 100
    }

    private let priceLabel = UILabel(frame: .zero)
    private let slider = UISlider(frame: .zero)
    private let priceLabelFormat = Strings.sliderLabelFormat
    private let spacing = Constant.defaultMargin

    init() {
        super.init(frame: .zero)
        slider.minimumValue = Constant.minPriceValue
        slider.maximumValue = Constant.maxPriceValue
        slider.isContinuous = true
        slider.tintColor = Constant.catchGreen
        slider.addTarget(self, action: #selector(didChangeSliderValue(slider:event:)), for: .valueChanged)
        priceLabel.text = String(format: priceLabelFormat, 0)
        priceLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(priceLabel)
        addSubview(slider)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func didChangeSliderValue(slider: UISlider, event: UIEvent) {
        let value = Int(slider.value)
        priceLabel.text = String(format: priceLabelFormat, value)
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .ended:
                delegate?.updatePrice(price: value * 100)
            default:
                break
            }
        }
    }

    private func setConstraints() {
        slider.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -spacing),
            slider.heightAnchor.constraint(equalToConstant: Constant.priceSliderHeight),
            priceLabel.leadingAnchor.constraint(equalTo: slider.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: slider.trailingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -spacing)

        ])
    }
}
