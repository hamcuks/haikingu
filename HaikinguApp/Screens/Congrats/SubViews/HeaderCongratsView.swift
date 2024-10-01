//
//  HeaderView.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 01/10/24.
//

import UIKit
import SnapKit

class HeaderCongratsView: UIView {
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = "Great Job, Team!"
        label.textColor = .black
        return label
    }()
    
    var destinationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    var valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private var verticalStack: UIStackView = {
        let vertical = UIStackView()
        vertical.axis = .vertical
        vertical.spacing = 0
        vertical.distribution = .fillProportionally
        vertical.alignment = .center
        return vertical
    }()

    init(destinationTitle: String, destinationTime: String) {
        super.init(frame: .zero)
        
        destinationLabel.text = "\(destinationTitle) Done in"
        valueLabel.text = "\(destinationTime)"
        
        self.configureUI()
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.configureUI()
//    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(verticalStack)
        
        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(destinationLabel)
        verticalStack.addArrangedSubview(valueLabel)
        
        verticalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }

}
