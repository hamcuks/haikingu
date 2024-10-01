//
//  HikingSessionVC.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 01/10/24.
//

import UIKit
import SnapKit

class HikingSessionVC: UIViewController {
    
    var headerView: HeaderView!
    var bodyView: BodyView!
    var timeElapsed: TimeElapsedView!
    var footerView: FooterView = FooterView()
    var actionButton: IconButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        headerView = HeaderView(status: "Keep Moving", title: "24.59", subtitle: "Hiking time for 1670 m", backgroundColor: .clear)
        bodyView = BodyView(backgroundCircleColor: .clear)
        timeElapsed = TimeElapsedView(value: "00.32.31,59")
        actionButton = IconButton(imageIcon: "play.fill")
        
        configureUI()
    }
    
    private func configureUI() {
        
        view.addSubview(headerView)
        view.addSubview(bodyView)
        view.addSubview(timeElapsed)
        view.addSubview(footerView)
        view.addSubview(actionButton)

        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
        }
        
        bodyView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(headerView)
        }
        
        timeElapsed.snp.makeConstraints { make in
            make.top.equalTo(bodyView.snp.bottom).offset(16)
            make.leading.trailing.equalTo(headerView)
        }
        
        footerView.snp.makeConstraints { make in
            make.top.equalTo(timeElapsed.snp.bottom).offset(24)
            make.leading.trailing.equalTo(timeElapsed)
            
        }
        
        actionButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(24)
            make.width.height.equalTo(60)
            make.centerX.equalTo(footerView)
        }
    
    }

}
