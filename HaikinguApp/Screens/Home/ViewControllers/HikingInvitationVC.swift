//
//  HikingInvitationVC.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 30/09/24.
//

import UIKit

class HikingInvitationVC: UIViewController {
    
    let avatarView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person.circle")
        
        view.snp.makeConstraints { make in
            make.height.width.equalTo(56)
        }
        
        return view
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Fitra"
        label.font = .preferredFont(forTextStyle: .headline)
        
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.text = "Hi, Bayu! I invite you to the team. Let's hiking and reach the destination together"
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        
        return label
    }()
    
    let joinButton: PrimaryButton = PrimaryButton(label: "Yes, I'm in!")
    let rejectButton: SecondaryButton = SecondaryButton(label: "Not now")

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureVC()
        self.configureInvitationStackView()
        self.configureButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Someone Added You"
        self.isModalInPresentation = true
    }
    
    private func configureVC() {
        self.view.backgroundColor = .white
    }
    
    private func configureInvitationStackView() {
        let invitorStackView: UIStackView = UIStackView()
        invitorStackView.axis = .vertical
        invitorStackView.spacing = 4
        invitorStackView.alignment = .center
        
        invitorStackView.addArrangedSubview(avatarView)
        invitorStackView.addArrangedSubview(nameLabel)
        
        let invitationStackView: UIStackView = UIStackView()
        invitationStackView.axis = .vertical
        invitationStackView.spacing = 16
        
        invitationStackView.addArrangedSubview(invitorStackView)
        invitationStackView.addArrangedSubview(descLabel)
        
        self.view.addSubview(invitationStackView)
        
        invitationStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(116)
            make.leading.trailing.equalToSuperview().inset(56)
        }
    }
    
    private func configureButtons() {
        let stack: UIStackView = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        
        stack.addArrangedSubview(joinButton)
        stack.addArrangedSubview(rejectButton)
        
        view.addSubview(stack)
        
        joinButton.addTarget(self, action: #selector(joinInvitation), for: .touchUpInside)
        rejectButton.addTarget(self, action: #selector(rejectInvitation ), for: .touchUpInside)
        
        stack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(24)
        }
        
        joinButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        rejectButton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    @objc func joinInvitation() {
        self.dismiss(animated: true)
        
        #warning("call join invitation function")
    }
    
    @objc func rejectInvitation() {
        self.dismiss(animated: true)
        
        #warning("call reject invitation function")
    }

}
