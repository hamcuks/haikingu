//
//  HomeVC.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 30/09/24.
//

import UIKit
import SnapKit

class HomeVC: UIViewController {
    /// Managers
    var peripheralManager: PeripheralBLEService?
    
    /// SubViews
    let headerView: HomeHeaderView = HomeHeaderView()
    lazy var hikingModeControlView: HikingModeControlView = {
        let control = HikingModeControlView(items: ["Solo", "Group"])
        control.selectedSegmentIndex = 0
        
        return control
    }()
    
    lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.text = "“Lorem ipsum sit amet dolor Lorem ipsum sit amet dolorLorem ipsum sit amet dolorLorem ipsum sit” -Fitra Muh"
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var contentStack: UIStackView = UIStackView()
    lazy var imageView: UIImageView = UIImageView()
    lazy var backToHomeMessageView: BackToHomeMessageView = BackToHomeMessageView()
    
    /// Data
    var invitor: Hiker?
    
    /// Constructors
    init(peripheralManager: PeripheralBLEService?) {
        super.init(nibName: nil, bundle: nil)
        
        self.peripheralManager = peripheralManager
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureVC()
        self.configureHeaderView()
        self.configureHikingModeControlView()
        self.configureContentStackView()
        self.peripheralManager?.setDelegate(self)
        
    }
    
    /// Private Functions
    private func configureVC() {
        self.view.backgroundColor = .systemBackground
    }
    
    private func configureHeaderView() {
        view.addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(64)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func configureHikingModeControlView() {
        view.addSubview(hikingModeControlView)
        
        hikingModeControlView.addTarget(self, action: #selector(onHikingModeControlValueChanged), for: .valueChanged)
        
        hikingModeControlView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(46)
        }
    }
    
    private func configureContentStackView() {
        view.addSubview(contentStack)
        
        self.configureTipsLabel()
        contentStack.addArrangedSubview(tipsLabel)
        tipsLabel.isHidden = true
        
        self.configureBackToHomeMessageView()
        contentStack.addArrangedSubview(backToHomeMessageView)
        
        self.configureImageView()
        contentStack.addArrangedSubview(imageView)
        
        contentStack.spacing = 20
        contentStack.axis = .vertical
        
        contentStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(hikingModeControlView.snp.bottom).offset(16)
        }
    }

    private func configureTipsLabel() {
        
        
    }
    
    private func configureImageView() {
        
        imageView.image = UIImage(systemName: "photo.fill")
        imageView.tintColor = .label
        imageView.backgroundColor = .secondarySystemBackground
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(264)
        }
    }
    
    private func configureBackToHomeMessageView() {
        
    }
    
    @objc private func onHikingModeControlValueChanged(_ sender: HikingModeControlView) {
        print(sender.selectedSegmentIndex == 0 ? "Choosen: Solo" : "Choosen: Group")
    }
    
    func showInvitationSheet(from hiker: Hiker) {
        let vc = HikingInvitationVC()
        vc.hiker = hiker
        vc.delegate = self
        
        let navVC = UINavigationController(rootViewController: vc)
        navVC.sheetPresentationController?.detents = [.medium()]
        
        self.present(navVC, animated: true)
    }
}

#Preview(traits: .defaultLayout, body: {
    HomeVC(peripheralManager: HikerBLEManager())
})
