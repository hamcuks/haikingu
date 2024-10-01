//
//  PersonImageView.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 01/10/24.
//

import UIKit

class PersonImageView: UIView {

    private var circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.tintColor = .black
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 32
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black

        return label
    }()
    
    private var profileStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    init(imagePerson: String, namePerson: String) {
        super.init(frame: .zero)
        
        circleImageView.image = UIImage(named: imagePerson)
        nameLabel.text = namePerson
        
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(profileStack)
        profileStack.addArrangedSubview(circleImageView)
        profileStack.addArrangedSubview(nameLabel)
        
        circleImageView.snp.makeConstraints { make in
            make.width.height.equalTo(63)
        }
        
        profileStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
         }
    }

}
