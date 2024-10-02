//
//  BodyView.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 01/10/24.
//

import UIKit
import SnapKit

class BodyView: UIView {
    
    private var verticalStackBodyView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4
        return stackView
    }()
    
    private var roundedRectangleView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20.0
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private var horizontalPersonStack: UIStackView = {
        let horizontal = UIStackView()
        horizontal.axis = .horizontal
        horizontal.spacing = 5
        horizontal.distribution = .fillProportionally
        horizontal.alignment = .center
        return horizontal
    }()
    
    private var yourTeamLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    init(backgroundCircleColor: UIColor) {
        super.init(frame: .zero)
        
        roundedRectangleView.backgroundColor = backgroundCircleColor
        
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(verticalStackBodyView)
        verticalStackBodyView.addArrangedSubview(yourTeamLabel)
        verticalStackBodyView.addArrangedSubview(roundedRectangleView)
        
        roundedRectangleView.addSubview(horizontalPersonStack)
        
        yourTeamLabel.text = "Your Team (1/5)"
        
        setupProfileStack()
        
        verticalStackBodyView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        roundedRectangleView.snp.makeConstraints { make in
            make.height.equalTo(120)
            make.width.equalTo(360)
        }
        
        horizontalPersonStack.snp.makeConstraints { make in
            make.leading.equalTo(roundedRectangleView.snp.leading).offset(8)
            make.centerY.equalTo(roundedRectangleView.snp.centerY)
        }

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
