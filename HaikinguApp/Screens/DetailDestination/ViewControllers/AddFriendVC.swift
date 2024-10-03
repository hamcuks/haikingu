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
    
    var manager: CentralBLEService?
    
    /// Delegates
    var header = HeaderAddFriendView()
    var yourTeam: HikerGridView!
    var nearbyPerson: HikerGridView!
    var selectedPlan: DestinationList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configuration()
        
    }
    
    private func configuration() {
        view.addSubview(header)
        
        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
        }
        
        yourTeam = HikerGridView(frame: view.bounds, title: "Your Team")
        yourTeam.delegate = self
        nearbyPerson = HikerGridView(frame: view.bounds, title: "Nearby Hikers")
        nearbyPerson.delegate = self
        
        let stack = UIStackView(arrangedSubviews: [yourTeam, nearbyPerson])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        
        view.addSubview(stack)
        
        yourTeam.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        nearbyPerson.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        stack.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(20)
            make.trailing.leading.bottom.equalToSuperview().inset(16)
        }
    }
}

extension AddFriendVC: AddFriendVCDelegate {
    func didReceiveNearbyHikers(_ hikers: Set<Hiker>) {
        print("didReceiveNearbyHikers: \n\(hikers)")
        
        let notJoinedHiker: Set<Hiker> = hikers.filter { $0.state != .joined }
        self.nearbyPerson.updateData(on: Array(notJoinedHiker))
        
        let joinedHikers: Set<Hiker> = hikers.filter { $0.state == .joined }
        self.yourTeam.updateData(on: Array(joinedHikers))
    }
}

extension AddFriendVC: HikerGridViewDelegate {
    func didDisconnectHiker(_ hiker: Hiker) {
        print("didDisconnectHiker")
        self.manager?.disconnect(to: hiker)
    }
    
    func didConnectHiker(_ hiker: Hiker) {
        guard let selectedPlan else { return }
        self.manager?.connect(to: hiker, plan: selectedPlan.rawValue)
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

#Preview(traits: .defaultLayout, body: {
    AddFriendVC()
})

