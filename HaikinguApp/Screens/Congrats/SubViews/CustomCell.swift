//
//  CustomCell.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 01/10/24.
//

import UIKit
import SnapKit

class CustomCell: UITableViewCell {
    
    private var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.tintColor = .systemBrown
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.systemBrown, for: .normal)
        return button
    }()
    
    private var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    func configure(iconName: String, title: String, buttonTitle: String, isBordered: Bool) {
        iconImageView.image = UIImage(systemName: iconName)
        titleLabel.text = title
        actionButton.setTitle(buttonTitle, for: .normal)
        if isBordered {
            actionButton.layer.cornerRadius = 10
            actionButton.layer.borderWidth = 1
            actionButton.layer.borderColor = UIColor.systemBrown.cgColor
            setupUI(widthBorder: 95)
        } else {
            setupUI(widthBorder: 130)
        }
        
    }
    
    private func setupUI(widthBorder: CGFloat = 10) {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(actionButton)
        contentView.addSubview(dividerView)
        
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(22)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(widthBorder)
            make.height.equalTo(40)
        }
        
        dividerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
