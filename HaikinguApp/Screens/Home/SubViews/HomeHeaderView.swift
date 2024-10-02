//
//  HomeHeaderView.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 30/09/24.
//

import UIKit
import SnapKit

class HomeHeaderView: UIStackView {
    
    weak var delegate: HomeHeaderViewDelegate?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hi, Ivan!"
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    let readyToHikeLabel: UILabel = {
        let label = UILabel()
        label.text = "Ready to Hike?"
        label.font = .boldSystemFont(ofSize: 34)
        
        return label
    }()
    
    let avatarView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 27
        view.layer.masksToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.axis = .horizontal
        self.alignment = .center
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, readyToHikeLabel])
        stack.axis = .vertical
        
        self.addArrangedSubview(stack)
        self.addArrangedSubview(avatarView)
        
        // Tambahkan gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        avatarView.addGestureRecognizer(tapGesture)
        
        avatarView.snp.makeConstraints { make in
            make.width.height.equalTo(54)
        }
    }
    
    func setUserName(_ name: String, _ photo: UIImage?) {
        nameLabel.text = "Hi, \(name)!"
        avatarView.image = photo
    }
    
    @objc private func avatarTapped() {
        delegate?.didTapAvatar()
    }
    
}

protocol HomeHeaderViewDelegate: AnyObject {
    func didTapAvatar()
}

