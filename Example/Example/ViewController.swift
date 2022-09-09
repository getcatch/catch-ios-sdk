//
//  ViewController.swift
//  Example
//
//  Created by Lucille Benoit on 8/22/22.
//

import Catch
import UIKit

class ViewController: UIViewController {
    let logoView = CatchLogo(theme: .lightColor)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let size = CGSize(width: 100, height: 60)
        logoView.frame = CGRect(origin: .zero, size: size)
        logoView.center = view.center
        view.addSubview(logoView)
        view.backgroundColor = .systemBackground
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *) {
            logoView.theme = self.traitCollection.userInterfaceStyle == .dark ? .darkColor : .lightColor
        }
    }

}
