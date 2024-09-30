//
//  BodyView.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 30/09/24.
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
    
    private var iconView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    var iconImage: String?
    var valueTitle: String?
    var titleText: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init(icon: String, value: String, title: String) {
        super.init(frame: .zero)
        setup()
        
        iconView.image = UIImage(systemName: icon)
        valueLabel.text = value
        titleLabel.text = title
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.addSubview(verticalStackBodyView)
        
        verticalStackBodyView.addArrangedSubview(iconView)
        verticalStackBodyView.addArrangedSubview(valueLabel)
        verticalStackBodyView.addArrangedSubview(titleLabel)
        
        verticalStackBodyView.snp.makeConstraints { make in
            make.edges.equalToSuperview() 
        }
        
    }
    


}
