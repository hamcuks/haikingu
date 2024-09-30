//
//  ListView.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 30/09/24.
//

import UIKit

class HikingCell: UITableViewCell {
    
    private var imageDestination: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private var labelDestination: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private var estIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "clock")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private var elevationIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "arrow.up.right")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private var distanceIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "point.topleft.down.to.point.bottomright.curvepath.fill")
        image.contentMode = .scaleAspectFit
        //width: 40, height: 25
        return image
    }()
    
    private var estLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private var elevationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private var distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private var verticalStack: UIStackView = {
        let vertical = UIStackView()
        vertical.axis = .vertical
        vertical.spacing = 4
        vertical.distribution = .fillEqually
        vertical.alignment = .center
        return vertical
    }()
    
    private var horizontalStack: UIStackView = {
        let horizontal = UIStackView()
        horizontal.axis = .horizontal
        horizontal.spacing = 4
        horizontal.distribution = .fillProportionally
        horizontal.alignment = .leading
        return horizontal
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
//        contentView.layer.borderColor = UIColor.blue.cgColor
//        contentView.layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    
    func configure(with destination: DestinationModel) {
        labelDestination.text = destination.name
        imageDestination.image = UIImage(named: destination.image)
        estLabel.text = "\(destination.estimatedTime) min"
        elevationLabel.text = "\(destination.maxElevation) m"
        distanceLabel.text = "\(Float((destination.trackLength) / 1000)) km"
        
    }
    
    
    private func setupViews() {
        
        contentView.addSubview(imageDestination)
        contentView.addSubview(verticalStack)
        
        horizontalStack.addArrangedSubview(estIcon)
        horizontalStack.addArrangedSubview(estLabel)
        horizontalStack.addArrangedSubview(elevationIcon)
        horizontalStack.addArrangedSubview(elevationLabel)
        horizontalStack.addArrangedSubview(distanceIcon)
        horizontalStack.addArrangedSubview(distanceLabel)
    
        verticalStack.addArrangedSubview(labelDestination)
        verticalStack.addArrangedSubview(horizontalStack)
        
        constraintsAll()
        
        
    }

    
    private func constraintsAll() {
        
        imageDestination.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(10)
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
        
        verticalStack.snp.makeConstraints { make in
            make.leading.equalTo(imageDestination.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
        horizontalStack.snp.makeConstraints { make in
            make.leading.trailing.equalTo(verticalStack)
            make.height.equalTo(20)
        }
        
        labelDestination.snp.makeConstraints { make in
            make.leading.trailing.equalTo(verticalStack)
        }

        estIcon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        
        elevationIcon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        
        distanceIcon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
    }

    
}

