//
//  BackToHomeMessageView.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 30/09/24.
//

import UIKit

class BackToHomeMessageView: UIView {
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.text = "Time to Go Home!"
        
        return label
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "After enjoying Bidadari Lake, don’t forget to head back in time and keep your energy up!"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        label.text = "1.20.59 Left"
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.layer.cornerRadius = 25
        self.layer.borderWidth = 1
        
        let remainingTimeStack = UIStackView()
        remainingTimeStack.spacing = 8
        remainingTimeStack.alignment = .center
        
        let icon = UIImageView(image: UIImage(systemName: "clock"))
        
        remainingTimeStack.addArrangedSubview(icon)
        remainingTimeStack.addArrangedSubview(remainingTimeLabel)
        
        let stack = UIStackView(arrangedSubviews: [ titleLabel, messageLabel, remainingTimeStack ])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 8
        
        self.addSubview(stack)
        
        stack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(12)
        }
    }
    
}
