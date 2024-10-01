//
//  DetailEstTimeVC.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 01/10/24.
//

import UIKit

class DetailEstTimeVC: UIViewController {
    
    var detailEstTimeLabel: UILabel = {
       var label = UILabel()
        label.text = "The estimated travel time is based on the distance covered, the elevation of the terrain, and the rest time during the hike. Please note, the duration may vary depending on the speed of each hiker. Terrain with higher elevation will naturally require more energy, which can affect the overall travel time. Additionally, if unexpected circumstances such as fatigue or physical conditions that require more frequent breaks arise, the estimated hiking time will increase. Therefore, this estimate is dynamic and may change according to actual conditions on the ground."
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .black
        label.textAlignment = .justified
        label.numberOfLines = 20
        label.lineBreakMode = .byWordWrapping
        label.lineBreakStrategy = .standard
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Estimated Time"
        navigationItem.largeTitleDisplayMode = .inline
        
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(detailEstTimeLabel)
        
        detailEstTimeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }

}
