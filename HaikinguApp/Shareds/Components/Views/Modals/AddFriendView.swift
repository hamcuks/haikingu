//
//  AddFriendView.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 01/10/24.
//

//  TextIconButton(icon: "person.2.fill", title: "Add Friends", color: .systemBrown)

import UIKit

class AddFriendView: UIView {
    
    

}


class headerAddFriendView: UIView {
    private var iconPerson: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "person.2.fill")
        icon.tintColor = .black
        return icon
    }()
    
    private var addFriendTitle: UILabel = {
        let title = UILabel()
        title.text = "Add Friends"
        title.font = .systemFont(ofSize: 20, weight: .semibold)
        title.textColor =.black
        return title
    }()
    
    private var addFriendSubtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.text = "People found around you"
        subtitle.font = .systemFont(ofSize: 17, weight: .regular)
        subtitle.textColor = .black.withAlphaComponent(0.5)
        return subtitle
    }()
    
    
    private var horizontalStack: UIStackView = {
        let horizontal = UIStackView()
        horizontal.axis = .horizontal
        horizontal.spacing = 5
        horizontal.distribution = .fillProportionally
        horizontal.alignment = .leading
        return horizontal
    }()
    
    private var verticalStack: UIStackView = {
        let vertical = UIStackView()
        vertical.axis = .vertical
        vertical.spacing = 0
        vertical.distribution = .fillProportionally
        vertical.alignment = .leading
        return vertical
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(horizontalStack)
        
        verticalStack.addArrangedSubview(addFriendTitle)
        verticalStack.addArrangedSubview(addFriendSubtitle)
        
        horizontalStack.addArrangedSubview(self.iconPerson)
        horizontalStack.addArrangedSubview(self.verticalStack)
        
        horizontalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconPerson.snp.makeConstraints { make in
            make.width.equalTo(55)
            make.height.equalTo(41)
        }
    }
}
