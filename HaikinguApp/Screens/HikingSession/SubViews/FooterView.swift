//
//  FooterView.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 01/10/24.
//

import UIKit
import SnapKit

class FooterView: UIView {
    
    private var verticalStackBodyView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private var horizontalStack: UIStackView = {
        let horizontal = UIStackView()
        horizontal.axis = .horizontal
        horizontal.spacing = 32
        horizontal.distribution = .fillEqually
        horizontal.alignment = .center
        return horizontal
    }()
    
    private var estTimeView: HikingMetricsIconTextView = {
        let view = HikingMetricsIconTextView(icon: "clock", value: "00:00:00", title: "Estimated Time")
        return view
    }()
    
    private var distanceView: HikingMetricsIconTextView = {
        let view = HikingMetricsIconTextView(icon: "point.topleft.filled.down.to.point.bottomright.curvepath", value: "1000 m", title: "Distance")
        return view
    }()
    
    private var restTakenView: HikingMetricsIconTextView = {
        let view = HikingMetricsIconTextView(icon: "figure.mind.and.body", value: "2x", title: "Rest Taken")
        return view
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
    
    private var hikingMetricsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.text = "Hiking Metrics"
        return label
    }()
    
//    init(icon: String, value: String, title: String) {
//        super.init(frame: .zero)
//        
//        setup()
//    }
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addSubview(verticalStackBodyView)
        
        verticalStackBodyView.addArrangedSubview(hikingMetricsLabel)
        verticalStackBodyView.addArrangedSubview(deviderTopView)
        verticalStackBodyView.addArrangedSubview(horizontalStack)
        verticalStackBodyView.addArrangedSubview(deviderBottomView)
        
        horizontalStack.addArrangedSubview(estTimeView)
        horizontalStack.addArrangedSubview(distanceView)
        horizontalStack.addArrangedSubview(restTakenView)
        
        verticalStackBodyView.snp.makeConstraints { make in
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
