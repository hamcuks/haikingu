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
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textColor = .black

        return label
    }()
    
    private var stateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    private var profileStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .center
        return stack
    }()
    
    init() {
        super.init(frame: .zero)
        
        configure()
    }
    
    func setData(image: String, name: String, state: String? = nil) {
        nameLabel.text = name
        
        if let state {
            stateLabel.text = state
        }
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
        profileStack.addArrangedSubview(stateLabel)
        
        circleImageView.image = UIImage(systemName: "person.circle")
        
        circleImageView.snp.makeConstraints { make in
            make.width.height.equalTo(64)
        }
        
        profileStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
         }
    }
    
    override func layoutSubviews() {
        circleImageView.layer.cornerRadius = circleImageView.frame.height / 2
    }
}

#Preview(traits: .defaultLayout, body: {
    let person = PersonImageView()
    
    person.setData(image: "", name: "Test User", state: "Waiting")
    
    return person
})
