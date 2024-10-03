//
//  HeaderView.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 01/10/24.
//

import UIKit
import SnapKit

class HeaderView: UIView {
    
    private var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private var roundedRectangleView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 20.0
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.systemOrange.cgColor
        view.layer.borderWidth = 3
        return view
    }()
    
    private var verticalStack: UIStackView = {
        let vertical = UIStackView()
        vertical.axis = .vertical
        vertical.spacing = 0
        vertical.distribution = .fillProportionally
        vertical.alignment = .center
        return vertical
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 52, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "00:00"
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        return label
    }()
    
    //    init(status: TimingState, value: TimeInterval) {
    //        super.init(frame: .zero)
    //
    ////        configureValueRemaining(value)
    ////        configureValueState(status)
    //
    //        configureUI()
    //    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(statusLabel)
        addSubview(roundedRectangleView)
        
        roundedRectangleView.addSubview(verticalStack)
        
        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(subtitleLabel)
        
        statusLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            //            make.height.equalTo(40)
        }
        
        roundedRectangleView.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(24)
            make.leading.trailing.equalTo(statusLabel)
            make.bottom.equalToSuperview()
            make.height.equalTo(121)
        }
        
        verticalStack.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(roundedRectangleView)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.width.equalTo(329)
            //            make.height.equalTo(60)
        }
        
    }
    
    func configureValueState(_ state: TimingState) {
        
        switch state {
        case .timeToRest:
            self.statusLabel.text = "Rest Time!"
            self.subtitleLabel.text = "Take a rest for a while, drink your water"
            self.roundedRectangleView.backgroundColor = .clear
        case .timeToWalk:
            self.statusLabel.text = "Keep Moving!"
            self.subtitleLabel.text = "Hiking time for 1670 m"
            self.roundedRectangleView.backgroundColor = .clear
        }
    }
    
    func configureValueRemaining(_ value: TimeInterval) {
        let minutes = Int(value) / 60
        let seconds = Int(value) % 60
        let formattedTime = String(format: "%02d.%02d", minutes, seconds)
        titleLabel.text = formattedTime
    }
    
    func personNotmove() {
        roundedRectangleView.backgroundColor = .systemOrange
        statusLabel.text = "Not Moving!"
        subtitleLabel.text = "Check your friends doing!"
        
    }
    
    func personLost() {
        roundedRectangleView.backgroundColor = .systemOrange
        statusLabel.text = "Lost Friend!"
        //        titleLabel.text = "Lost Friend!"
        subtitleLabel.text = "Re-check your friend!"
        
    }
    
    func bpmHigh() {
        roundedRectangleView.backgroundColor = .systemOrange
        statusLabel.text = "BPM Alert!!!"
//        titleLabel.text = "BPM Alert!!!"
        subtitleLabel.text = "Your friends BPM is high. Take a rest immediately!"
        
    }
    
    func personNormal() {
        roundedRectangleView.backgroundColor = .clear
        statusLabel.text = "Keep Moving!"
        subtitleLabel.text = "Hiking time for 1670 m"
    }
    
}
