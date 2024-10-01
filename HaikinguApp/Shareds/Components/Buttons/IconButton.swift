//
//  IconButton.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 01/10/24.
//

import UIKit

class IconButton: UIButton {
    
    init(imageIcon: String) {
        super.init(frame: .zero)
        
        self.setImage(UIImage(systemName: imageIcon), for: .normal)
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
        self.configuration = .bordered()
        self.configuration?.baseBackgroundColor = .systemOrange
        self.tintColor = .black
        self.configuration?.background.cornerRadius = 30
    }

}
