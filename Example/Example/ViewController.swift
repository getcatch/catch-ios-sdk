//
//  ViewController.swift
//  Example
//
//  Created by Lucille Benoit on 8/22/22.
//

import Catch
import UIKit

class ViewController: UIViewController {
    let logoView = CatchLogo()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let size = CGSize(width: 100, height: 60)
        logoView.frame = CGRect(origin: .zero, size: size)
        logoView.center = view.center
        view.addSubview(logoView)
    }

}
