//
//  HikingSummaryView.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 01/10/24.
//

import UIKit
import SnapKit

class HikingSummaryView: UIView {
    
    var hikingSummaryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = "Hiking Summary"
        label.textColor = .black
        return label
    }()
    
    private var verticalStack: UIStackView = {
        let vertical = UIStackView()
        vertical.axis = .vertical
        vertical.spacing = 2
        vertical.distribution = .fillProportionally
        vertical.alignment = .center
        return vertical
    }()
    
    private var horizontalStack: UIStackView = {
        let horizontal = UIStackView()
        horizontal.axis = .horizontal
        horizontal.spacing = 32
        horizontal.distribution = .fillEqually
        horizontal.alignment = .center
        return horizontal
    }()
    
    private var deviderTopView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    private var deviderBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    private var eleGainView: HikingMetricsIconTextView = {
        let view = HikingMetricsIconTextView(icon: "arrow.up.right", value: "97 m", title: "Elv. Gain")
        return view
    }()
    
    private var distanceView: HikingMetricsIconTextView = {
        let view = HikingMetricsIconTextView(icon: "point.topleft.filled.down.to.point.bottomright.curvepath", value: "1000 m", title: "Distance Hiked")
        return view
    }()
    
    private var restTakenView: HikingMetricsIconTextView = {
        let view = HikingMetricsIconTextView(icon: "figure.mind.and.body", value: "2x", title: "Rest Taken")
        return view
    }()
//
//    init(destinationTitle: String, destinationTime: String) {
//        super.init(frame: .zero)
//        
//        self.configureUI()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(verticalStack)
        
        verticalStack.addArrangedSubview(hikingSummaryLabel)
        verticalStack.addArrangedSubview(deviderTopView)
        verticalStack.addArrangedSubview(horizontalStack)
        verticalStack.addArrangedSubview(deviderBottomView)
        
        horizontalStack.addArrangedSubview(eleGainView)
        horizontalStack.addArrangedSubview(distanceView)
        horizontalStack.addArrangedSubview(restTakenView)
        
        verticalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        deviderTopView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(361)
        }
        
        deviderBottomView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(361)
        }
        
    }

}
