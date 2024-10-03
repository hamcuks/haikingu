//
//  PrimaryButton.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 30/09/24.
//

import UIKit

class PrimaryButton: UIButton {

    init(label: String) {
        super.init(frame: .zero)
        
        self.setTitle(label, for: .normal)
        self.configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.configuration = .filled()
        self.configuration?.baseBackgroundColor = .systemOrange
        self.setTitleColor(.black, for: .normal)
        self.configuration?.background.cornerRadius = 16
        self.configuration?.titleAlignment = .center
    }

}
