//
//  HikerCell.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 02/10/24.
//

import UIKit

class HikerCell: UICollectionViewCell {
    static let reuseIdentifier: String = "AddFriendCell"
    
    let personView = PersonImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(with hiker: Hiker) {
        print("Hiker: \(hiker.name)")
        personView.setData(image: "", name: hiker.name, state: hiker.state)
    }
    
    private func configure() {
        addSubview(personView)
        
        personView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
