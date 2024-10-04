//
//  AlertRangeVC.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 01/10/24.
//

import UIKit
import SnapKit

class AlertRangeView: UIView {
    
    private let alertTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "You have not reached the starting point yet"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let alertDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "It’s a good idea to hold off on starting your activity until you get there"
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    lazy private var gotItButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Got it", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .alert
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(gotItButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let dimmedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Transparansi hitam
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
        
        self.addSubview(alertTitleLabel)
        self.addSubview(alertDescriptionLabel)
        self.addSubview(gotItButton)
        
        alertTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        alertDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(alertTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        gotItButton.snp.makeConstraints { make in
            make.top.equalTo(alertDescriptionLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
    }
    
    @objc private func gotItButtonTapped() {
        self.superview?.removeFromSuperview()
    }
    
    func showAlert(on viewController: UIViewController) {
        if let window = viewController.view.window {
            
            let containerView = UIView(frame: window.bounds)
            
            containerView.addSubview(dimmedBackgroundView)
            dimmedBackgroundView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            containerView.addSubview(self)
            self.snp.makeConstraints { make in
                make.center.equalTo(containerView)
                make.width.equalTo(containerView.snp.width).multipliedBy(0.8)
                make.height.equalTo(200)
            }
            
            window.addSubview(containerView)
        }
    }
}
