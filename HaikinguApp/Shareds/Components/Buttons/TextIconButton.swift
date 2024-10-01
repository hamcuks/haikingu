//
//  AddFriendsButton.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 30/09/24.
//

import UIKit

import UIKit

class TextIconButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    init(icon: String, title: String, color: UIColor) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        self.setImage(UIImage(systemName: "\(icon)"), for: .normal)
        self.tintColor = color
        self.setTitleColor(color, for: .normal)
    }
    
    private func setup() {
        // Pengaturan untuk tombol tanpa border

        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.configuration = .borderless()
        self.contentHorizontalAlignment = .left
        self.isUserInteractionEnabled = true
    }
}
