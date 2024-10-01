//
//  HikingMetricsIconTextView.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 01/10/24.
//

import UIKit
import SnapKit

class HikingMetricsIconTextView: UIView {

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
    
    init(icon: String, value: String, title: String) {
        super.init(frame: .zero)
        
        iconView.image = UIImage(systemName: icon)
        valueLabel.text = value
        titleLabel.text = title
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
