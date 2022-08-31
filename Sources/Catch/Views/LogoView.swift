//
//  CatchLogo.swift
//
//
//  Created by Lucille Benoit on 8/22/22.
//

import UIKit

public class CatchLogo: UIView {
    private var label = UILabel(frame: .zero)

    public init() {
        super.init(frame: .zero)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    internal func initialize() {
        configureLabel()
    }

    internal func configureLabel() {
        label.text = "Catch"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        setLabelConstraints()
    }

    internal func setLabelConstraints() {
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalTo: widthAnchor),
            label.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
}
