//
//  AddFriendView.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 01/10/24.
//

//  TextIconButton(icon: "person.2.fill", title: "Add Friends", color: .systemBrown)

import UIKit
import SnapKit

protocol AddFriendVCDelegate: AnyObject {
    func didReceiveNearbyHikers(_ hikers: Set<Hiker>)
}

class AddFriendVC: UIViewController {
    
    /// Delegates
    
    var header = HeaderAddFriendView()
    var yourTeam: BodyAddFriendView!
    var nearbyPerson: BodyAddFriendView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        yourTeam = BodyAddFriendView(titleText: "Your team (1/5)" )
        nearbyPerson = BodyAddFriendView(titleText: "Nearby Person" )
        
        configuration()

    }
    
    private func configuration() {
        view.addSubview(header)
        view.addSubview(yourTeam)
        view.addSubview(nearbyPerson)
        
//        header.layer.borderColor = UIColor.black.cgColor
//        header.layer.borderWidth = 1

        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
        }
        
        yourTeam.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(20)
            make.leading.trailing.equalTo(header)
        }
        
        nearbyPerson.snp.makeConstraints { make in
            make.top.equalTo(yourTeam.snp.bottom).offset(20)
            make.leading.trailing.equalTo(yourTeam)
        }
    }
}

extension AddFriendVC: AddFriendVCDelegate {
    func didReceiveNearbyHikers(_ hikers: Set<Hiker>) {
        print("didReceiveNearbyHikers: \n\(hikers)")
    }
}

class HeaderAddFriendView: UIView {
    
    private var iconPerson: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(systemName: "person.2.fill")
        icon.contentMode = .scaleAspectFit
        icon.tintColor = .black
        return icon
    }()
    
    private var addFriendTitle: UILabel = {
        let title = UILabel()
        title.text = "Add Friends"
        title.font = .systemFont(ofSize: 20, weight: .semibold)
        title.textColor = .black
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

class BodyAddFriendView: UIView {
    
    private var yourTeamLabel: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private var personImage = PersonImageView(
        imagePerson: "Bidadari",
        namePerson: "Person 1"
    )
    
    init(titleText: String) {
        super.init(frame: .zero)
        configureUI(title: titleText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(title: String) {
        addSubview(yourTeamLabel)
        addSubview(personImage)
        
        yourTeamLabel.text = title
        
        yourTeamLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        personImage.snp.makeConstraints { make in
            make.top.equalTo(yourTeamLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}
