//
//  HikingSummaryView.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 01/10/24.
//

import UIKit

class HikingSummaryView: UIView {
    
    var hikingSummaryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = "Hiking Summary"
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
        
        verticalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }

}
