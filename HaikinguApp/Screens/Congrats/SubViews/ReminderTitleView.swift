//
//  ReminderView.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 01/10/24.
//

import UIKit
import SnapKit

class ReminderTitleView: UIView {

    private var verticalStackBodyView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 2
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private var reminderTitle: UILabel = {
        let label = UILabel()
        label.text = "When will you go back?"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private var reminderSubtitle: UILabel = {
        let label = UILabel()
        label.text = "Choose when you’d like to head back and we’ll remind yourself to go back home."
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(verticalStackBodyView)
        verticalStackBodyView.addArrangedSubview(reminderTitle)
        verticalStackBodyView.addArrangedSubview(reminderSubtitle)
        
        verticalStackBodyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
