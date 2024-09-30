//
//  HomeVC.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 30/09/24.
//

import UIKit
import SnapKit

class HomeVC: UIViewController {
    
    let headerView: HomeHeaderView = HomeHeaderView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureVC()
        self.configureHeaderView()
    }
    
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

}
