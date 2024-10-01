//
//  DetailDestinationView.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 30/09/24.
//

import UIKit

class DetailDestinationView: UIView {
    
    private var icon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.tintColor = .black
        return image
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    }()
    
    private var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private var horizontalStack: UIStackView = {
        let horizontal = UIStackView()
        horizontal.axis = .horizontal
        horizontal.spacing = 4
        horizontal.alignment = .bottom
        return horizontal
    }()
    
    private var verticalStack: UIStackView = {
        let vertical = UIStackView()
        vertical.axis = .vertical
        vertical.distribution = .fillEqually
        vertical.alignment = .leading
        return vertical
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(icon: String, title: String, value: String) {
        super.init(frame: .zero)
        
        self.icon.image = UIImage(systemName: icon)
        self.titleLabel.text = title
        self.valueLabel.text = value
        
        self.configure()
    }

    private func configure() {
        // Menambahkan subview ke horizontal stack
        addSubview(horizontalStack)
        
        horizontalStack.addArrangedSubview(icon)
        horizontalStack.addArrangedSubview(verticalStack)
        
        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(valueLabel)

//        horizontalStack.layer.borderColor = UIColor.blue.cgColor
//        horizontalStack.layer.borderWidth = 1
        
        horizontalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        
    }
}

#Preview(traits: .defaultLayout, body: {
    DetailDestinationView(icon: "person.circle", title: "Est. Time", value: "1h 20m")
})
