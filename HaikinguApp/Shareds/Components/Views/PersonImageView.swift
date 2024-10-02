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
    
    private var checkLabel: UILabel = {
        let label = UILabel()
        label.text = "CHECK!"
        label.font = .systemFont(ofSize: 11, weight: .semibold)
        label.textColor = .white
        label.backgroundColor = .red
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
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
    
    func setData(image: String, name: String, state: HikerStateEnum?) {
        nameLabel.text = name
        
        if let state, state != .notJoined {
            stateLabel.text = state.rawValue
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
        
        addSubview(checkLabel)
        
        circleImageView.snp.makeConstraints { make in
            make.width.height.equalTo(self.snp.width)
        }
        
        profileStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        checkLabel.snp.makeConstraints { make in
            make.centerX.equalTo(circleImageView.snp.centerX)
            make.top.equalTo(circleImageView.snp.top).offset(-10)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
    }
    
    override func layoutSubviews() {
        circleImageView.layer.cornerRadius = circleImageView.frame.height / 2
    }
}

#Preview(traits: .defaultLayout, body: {
    let person = PersonImageView()
    
    person.setData(image: "", name: "Test User", state: .waiting)
    
    return person
})
