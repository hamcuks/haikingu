//
//  HeaderView.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 01/10/24.
//

import UIKit
import SnapKit

class HeaderView: UIView {
    
    private var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private var roundedRectangleView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20.0
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.systemOrange.cgColor
        view.layer.borderWidth = 3
        return view
    }()
    
    private var verticalStack: UIStackView = {
        let vertical = UIStackView()
        vertical.axis = .vertical
        vertical.spacing = 0
        vertical.distribution = .fillProportionally
        vertical.alignment = .center
        return vertical
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 52, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    init(status: String, title: String, subtitle: String, backgroundColor: UIColor) {
        super.init(frame: .zero)
        
        statusLabel.text = status
        titleLabel.text = title
        subtitleLabel.text = subtitle
        roundedRectangleView.backgroundColor = backgroundColor
        
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(statusLabel)
        addSubview(roundedRectangleView)
        
        roundedRectangleView.addSubview(verticalStack)
        
        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(subtitleLabel)
        
        statusLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
//            make.height.equalTo(40)
        }
        
        roundedRectangleView.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(24)
            make.leading.trailing.equalTo(statusLabel)
            make.bottom.equalToSuperview()
            make.height.equalTo(121)
        }
        
        verticalStack.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(roundedRectangleView)
        }
        
    }

}
