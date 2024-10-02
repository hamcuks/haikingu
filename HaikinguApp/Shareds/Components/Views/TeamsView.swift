//
//  TeamsView.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 30/09/24.
//

import UIKit
import SnapKit

class TeamsView: UIView {
    
    var yourTeamLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    var addFriendsButton = TextIconButton(icon: "person.2.fill", title: "Add Friends", color: .systemBrown)
    
    var roundedRectangleView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20.0
        view.layer.masksToBounds = true
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private var horizontalStack: UIStackView = {
        let horizontal = UIStackView()
        horizontal.axis = .horizontal
        horizontal.spacing = 10
        horizontal.distribution = .fillProportionally
        horizontal.alignment = .leading
        return horizontal
    }()
    
    private var verticalStack: UIStackView = {
        let vertical = UIStackView()
        vertical.axis = .vertical
        vertical.spacing = 5
        vertical.distribution = .fillProportionally
        vertical.alignment = .leading
        return vertical
    }()
    
    private var horizontalPersonStack: UIStackView = {
        let horizontal = UIStackView()
        horizontal.axis = .horizontal
        horizontal.spacing = 5
        horizontal.distribution = .fillProportionally
        horizontal.alignment = .leading
        return horizontal
    }()
    
    init(action: Selector) {
        super.init(frame: .zero)
        configure(action: action)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(action: Selector) {
        
        yourTeamLabel.text = "Your team (1/5)"
        
        addSubview(verticalStack)
        
//        verticalStack.layer.borderColor = UIColor.black.cgColor
//        verticalStack.layer.borderWidth = 1
        
        horizontalStack.addArrangedSubview(yourTeamLabel)
        horizontalStack.addArrangedSubview(addFriendsButton)
        
        verticalStack.addArrangedSubview(horizontalStack)
        verticalStack.addArrangedSubview(roundedRectangleView)
        
        addFriendsButton.addTarget(nil, action: action, for: .touchUpInside)
        
        setupProfileStack()
        
        verticalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview() // Add padding around verticalStack
        }
        
        roundedRectangleView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(110)
            make.width.equalToSuperview()
        }
        
        roundedRectangleView.addSubview(horizontalPersonStack)
        
        horizontalPersonStack.snp.makeConstraints { make in
            make.leading.equalTo(roundedRectangleView.snp.leading).inset(8)
            make.trailing.equalTo(roundedRectangleView.snp.trailing).offset(-8)
            make.top.equalTo(roundedRectangleView.snp.top).inset(12)
            make.bottom.equalTo(roundedRectangleView.snp.bottom).offset(-12)
        }
        
//        horizontalPersonStack.layer.borderColor = UIColor.red.cgColor
//        horizontalPersonStack.layer.borderWidth = 1
                
    }
    
    func setupProfileStack() {
//        let person1: PersonImageView = PersonImageView(imagePerson: "Bidadari", namePerson: "Person 1")
//        let person2: PersonImageView = PersonImageView(imagePerson: "Bidadari", namePerson: "Person 2")
//        let person3: PersonImageView = PersonImageView(imagePerson: "Bidadari", namePerson: "Person 3")
//        let person4: PersonImageView = PersonImageView(imagePerson: "Bidadari", namePerson: "Person 4")
//        let person5: PersonImageView = PersonImageView(imagePerson: "Bidadari", namePerson: "Person 5")
//        
//        horizontalPersonStack.addArrangedSubview(person1)
//        horizontalPersonStack.addArrangedSubview(person2)
//        horizontalPersonStack.addArrangedSubview(person3)
//        horizontalPersonStack.addArrangedSubview(person4)
//        horizontalPersonStack.addArrangedSubview(person5)
    }

}
