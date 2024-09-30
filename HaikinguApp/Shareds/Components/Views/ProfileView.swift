//
//  ProfileView.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 30/09/24.
//

import UIKit
import SnapKit

class ProfileView: UIView {
    
    var imageProfile: UIImageView = {
        let imageProfile = UIImageView()
        imageProfile.image = UIImage(named: "profile")
        imageProfile.contentMode = .scaleAspectFill
        imageProfile.clipsToBounds = true
        imageProfile.layer.cornerRadius = 100
        return imageProfile
    }()
    
    var nameProfile: UILabel = {
        let nameProfile = UILabel()
        nameProfile.font = .systemFont(ofSize: 11, weight: .semibold)
        return nameProfile
    }()
    
    var verticalStack: UIStackView = {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.spacing = 10
        return verticalStack
    }()
    
    init(name: String, img: String) {
        super.init(frame: .zero)
        
        imageProfile.image = UIImage(named: img)
        nameProfile.text = name
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
    private func setup() {
        addSubview(imageProfile)
        addSubview(nameProfile)
        
        
    }
    

}
