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
        }
    }

    @objc private func onHikingModeControlValueChanged(_ sender: HikingModeControlView) {
        print(sender.selectedSegmentIndex == 0 ? "Choosen: Solo" : "Choosen: Group")
    }
}
