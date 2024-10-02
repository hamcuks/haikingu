//
//  HikingSessionVC.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 01/10/24.
//

import UIKit
import SnapKit
import Swinject

protocol HikingSessionVCDelegate: AnyObject {
    func didReceivedHikingState(_ state: HikingStateEnum)
    func didUpdateEstTime(_ time: TimeInterval)
    func didUpdateDistance(_ distance: Double)
    func didUpdateRestTaken(_ restCount: Int)
}

class HikingSessionVC: UIViewController {
    
    var headerView: HeaderView!
    var bodyView: BodyView!
    var timeElapsed: TimeElapsedView!
    var footerView: FooterView!
    var actionButton: IconButton!
    var endButton: IconButton = IconButton(imageIcon: "stop.fill")
    var destinationDetail: DestinationModel!
    
    /// Managers
    var peripheralManager: PeripheralBLEService?
    var centralManager: CentralBLEService?
    var userDefaultManager: UserDefaultService?
    
    var naismithTime: Double?
    var iconButton: String = {
        let icon: String = "play.fill"
        return icon
    }()
    private var horizontalStack: UIStackView = {
        let horizontal = UIStackView()
        horizontal.axis = .horizontal
        horizontal.spacing = 32
        horizontal.distribution = .fillEqually
        horizontal.alignment = .center
        return horizontal
    }()
    
    /// managers
    var workoutManager: WorkoutServiceIos?
    
    init(workoutManager: WorkoutServiceIos?, userDefaultManager: UserDefaultService?, centralManager: CentralBLEService?, peripheralManager: PeripheralBLEService?) {
        super.init(nibName: nil, bundle: nil)
        
        self.workoutManager = workoutManager
        self.userDefaultManager = userDefaultManager
        self.peripheralManager = peripheralManager
        self.centralManager = centralManager
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.workoutManager?.retrieveRemoteSession()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        footerView = FooterView(destination: destinationDetail, estValue: "\(String(describing: naismithTime))", restValue: "0")
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.hidesBackButton = true
        
        headerView = HeaderView(status: "Keep Moving", title: "00.00", subtitle: "Hiking time for 1670 m", backgroundColor: .clear)
        bodyView = BodyView(backgroundCircleColor: .clear)
        timeElapsed = TimeElapsedView(value: "00.32.31,59")
        actionButton = IconButton(imageIcon: "\(iconButton)")
        
        self.workoutManager?.setDelegate(self)
        
        configureUI()
        
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        endButton.addTarget(self, action: #selector(endActionTapped), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        naismithTime = calculateHikingTime(distance: Double(destinationDetail.trackLength), elevationGain: Double(destinationDetail.maxElevation), speed: workoutManager!.speed)
        
    }
    
    private func configureUI() {
        
        view.addSubview(headerView)
        view.addSubview(bodyView)
        view.addSubview(timeElapsed)
        view.addSubview(footerView)
        view.addSubview(horizontalStack)
        
        horizontalStack.addArrangedSubview(actionButton)
        
        headerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-80)
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
        
        horizontalStack.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
            make.top.equalTo(footerView.snp.bottom).offset(10)
//            make.width.height.equalTo(120)
            make.centerX.equalTo(footerView)
        }
        
        actionButton.snp.makeConstraints { make in
            make.width.height.equalTo(77)
        }
        
        endButton.snp.makeConstraints { make in
            make.width.height.equalTo(77)
        }
        
    }
    
    func calculateHikingTime(distance: Double, elevationGain: Double, speed: Double) -> Double {
        // Implementasi Naismith's Rule
        // distance dalam meter
        // speed dalam m/s maka dikali 3600
        let timeForDistance = distance / (speed * 3600) // perkiraan waktu tenpa elevasi dimana speed itu didapet dari current pace dan idealnya 4000m/jam
        let timeForElevation = elevationGain / 600 // menambahkan 1 jam setiap 600 meter elevasi
        
        // Total waktu dalam jam
        let totalTime = timeForDistance + timeForElevation
        return totalTime // dalam jam
    }
    
    @objc
    func actionButtonTapped() {
        guard let user = userDefaultManager?.getUserData() else { return }
        
        switch user.role {
        case .member:
            
            if iconButton == "play.fill" {
                print("paused button member tapped")
                iconButton = "clock.fill"
                actionButton.isEnabled = false
            }
            
            actionButton.setImage(UIImage(systemName: iconButton), for: .normal)
            
        case .leader:
            
            if iconButton == "play.fill" {
                print("play button leader tapped")
                iconButton = "pause.fill"
                horizontalStack.addArrangedSubview(endButton)
                
            } else if iconButton == "pause.fill" {
                print("paused button leader tapped")
                iconButton = "play.fill"
                horizontalStack.removeArrangedSubview(endButton)
                endButton.removeFromSuperview()
            }
            
            actionButton.setImage(UIImage(systemName: iconButton), for: .normal)
            
        }
    }
    
    @objc
    func endActionTapped() {
        guard let finishVC = Container.shared.resolve(CongratsVC.self) else { return }
        finishVC.destinationDetail = destinationDetail
        navigationController?.pushViewController(finishVC, animated: true)
    }
    
}

extension HikingSessionVC: HikingSessionVCDelegate {
    func didUpdateEstTime(_ time: TimeInterval) {
        print("didUpdateEstTime: ", time)
        self.footerView.updateEstTime("\(time)")
    }
    
    func didUpdateRestTaken(_ restCount: Int) {
        
    }
    
    func didReceivedHikingState(_ state: HikingStateEnum) {
        /// Update label based on state
        print("Current Hiking State: \(state.rawValue)")
    }

}

extension HikingSessionVC: WorkoutDelegate {
    func didUpdateHeartRate(_ heartRate: Double) {
        print("heart rate")
        
        if workoutManager?.isPersonTired() ?? false {
            self.peripheralManager?.requestRest(for: .abnormalBpm)
        } else {
            self.peripheralManager?.requestRest(for: .bpmAlreadyNormal)
        }
    }
    
    func didUpdateDistance(_ distance: Double) {
        
        if Double(destinationDetail.trackLength) == workoutManager?.distance {
            // MARK: Logic stop workout manager then go to congrats vc
        }
        
    }
    
    func didUpdateSpeed(_ speed: Double) {
        naismithTime = calculateHikingTime(distance: Double(destinationDetail.trackLength), elevationGain: Double(destinationDetail.maxElevation), speed: speed) * 60
        
        footerView.updateEstTime("\(naismithTime ?? 0)")
        
        guard speed < 0.2 else { return }
        
        guard let userData = userDefaultManager?.getUserData() else { return }
        
        if userData.role == .leader {
            centralManager?.requestRest(for: .notMoving, exclude: nil)
        } else {
            peripheralManager?.requestRest(for: .notMoving)
        }
        
    }
    
}
