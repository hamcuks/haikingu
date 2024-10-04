//
//  ViewController.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 16/09/24.
//

import UIKit
import SnapKit

class SplashScreen: UIViewController {
    
    lazy private var splashLabel: UILabel = {
        let label = UILabel()
        label.text = "Haikingu"
        label.font = .systemFont(ofSize: .init(40))
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(splashLabel)
    }
    
    private func setupConstraints() {
        splashLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

}
