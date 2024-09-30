//
//  HikingSessionVC.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 30/09/24.
//

import UIKit
import SnapKit

class HikingSessionVC: UIViewController {
    
    var verticalStackHeaderView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()
    
    var horizontalStackBodyView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 32
        return stackView
    }()
    
    var horizontalStackTeamView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()
    
    var titleHikingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        return label
    }()
    
    var statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 52, weight: .bold)
        return label
    }()
    
    var statusDetailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    var timerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 48, weight: .regular)
        return label
    }()
    
    var timeElapsedLabel: UILabel = {
        let label = UILabel()
        label.text = "Time Elapsed"
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    var hikingMetricsLabel: UILabel = {
        let label = UILabel()
        label.text = "Hiking Metrics"
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    var estTimeView: BodyView = {
        let view = BodyView(
            icon: "clock",
            value: "00:00",
            title: "Est. Time"
        )
        view.backgroundColor = .brown
        return view
    }()
    
    var distanceView: BodyView = {
        let view = BodyView(
            icon: "point.topleft.filled.down.to.point.bottomright.curvepath",
            value: "0 m",
            title: "Distance"
        )
        view.backgroundColor = .yellow
        return view
    }()
    
    var restView: BodyView = {
        let view = BodyView(
            icon: "figure.mind.and.body",
            value: "0x",
            title: "Rest Taken"
        )
        view.backgroundColor = .orange
        return view
    }()
    
    var yourTeamLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        setupTextLabel()
        setupLayout()

        // Do any additional setup after loading the view.
    }
    
    func setupTextLabel(){
        
        titleHikingLabel.text = "Hiking Session"
        statusLabel.text = "Not Moving"
        statusDetailLabel.text = "Check Your Friend!"
        timerLabel.text = "00:00:00"
        timeElapsedLabel.text = "Time Elapsed"
        hikingMetricsLabel.text = "Hiking Metrics"
        estTimeView.valueTitle = "1h 45min"
        distanceView.valueTitle = "120 m"
        restView.valueTitle = "0x"
        yourTeamLabel.text = "Your Team 5/5"
        
        
    }
    
    private func setupLayout(){
        view.addSubview(titleHikingLabel)
        view.addSubview(timerLabel)
        view.addSubview(timeElapsedLabel)
        view.addSubview(hikingMetricsLabel)

        view.addSubview(verticalStackHeaderView)
        verticalStackHeaderView.addArrangedSubview(statusLabel)
        verticalStackHeaderView.addArrangedSubview(statusDetailLabel)

        view.addSubview(horizontalStackBodyView)
        horizontalStackBodyView.addArrangedSubview(estTimeView)
        horizontalStackBodyView.addArrangedSubview(distanceView)
        horizontalStackBodyView.addArrangedSubview(restView)
        
//        view.bringSubviewToFront(horizontalStackBodyView)
        view.addSubview(horizontalStackTeamView)

        
        titleHikingLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(65)
            make.centerX.equalToSuperview()
        }
        verticalStackHeaderView.snp.makeConstraints { make in
            make.top.equalTo(titleHikingLabel.snp.bottom).offset(24)
            make.centerX.equalTo(titleHikingLabel.snp.centerX)
        }
        timerLabel.snp.makeConstraints { make in
            make.top.equalTo(statusDetailLabel.snp.bottom).offset(24)
            make.centerX.equalTo(statusDetailLabel.snp.centerX)
        }
        timeElapsedLabel.snp.makeConstraints { make in
            make.top.equalTo(timerLabel.snp.bottom).offset(0)
            make.centerX.equalTo(timerLabel.snp.centerX)
        }
        hikingMetricsLabel.snp.makeConstraints { make in
            make.top.equalTo(timeElapsedLabel.snp.bottom).offset(24)
            make.centerX.equalTo(timeElapsedLabel.snp.centerX)
        }
        horizontalStackBodyView.snp.makeConstraints { make in
            make.top.equalTo(hikingMetricsLabel.snp.bottom).offset(24)
            make.centerX.equalTo(hikingMetricsLabel.snp.centerX)
        }

        
        
    }

}
