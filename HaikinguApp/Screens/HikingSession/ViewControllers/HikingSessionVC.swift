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
    
    var headerView: HeaderView = HeaderView()
    var bodyView: BodyView!
    var timeElapsed: TimeElapsedView = TimeElapsedView()
    var footerView: FooterView!
    var actionButton: IconButton!
    var endButton: IconButton = IconButton(imageIcon: "stop.fill")
    var destinationDetail: DestinationModel!
    
    /// Managers
    var peripheralManager: PeripheralBLEService?
    var centralManager: CentralBLEService?
    var userDefaultManager: UserDefaultService?
    var notificationManager: NotificationService?
    var workoutManager: WorkoutServiceIos?
    
    var naismithTime: Double?
    var iconButton: String = {
        let icon: String = "pause.fill"
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
    
    init(workoutManager: WorkoutServiceIos?, userDefaultManager: UserDefaultService?, centralManager: CentralBLEService?, peripheralManager: PeripheralBLEService?, notificationManager: NotificationService?) {
        super.init(nibName: nil, bundle: nil)
        
        self.workoutManager = workoutManager
        self.userDefaultManager = userDefaultManager
        self.peripheralManager = peripheralManager
        self.centralManager = centralManager
        self.notificationManager = notificationManager
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        workoutManager?.retrieveRemoteSession()
        headerView.configureValueState(workoutManager!.whatToDo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        workoutManager?.retrieveRemoteSession()
        
        self.workoutManager?.setDelegate(self)
        view.backgroundColor = .white
        
        bodyView = BodyView(backgroundCircleColor: .clear)
        footerView = FooterView(destination: destinationDetail, estValue: "\(String(describing: naismithTime))", restValue: "0")
    
        actionButton = IconButton(imageIcon: "\(iconButton)")
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        endButton.addTarget(self, action: #selector(endActionTapped), for: .touchUpInside)
        
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.workoutManager?.retrieveRemoteSession()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.hidesBackButton = true
        
        naismithTime = calculateHikingTime(distance: Double(destinationDetail.trackLength), elevationGain: Double(destinationDetail.maxElevation), speed: workoutManager!.speed)
        
    }
    
    private func configureUI() {
        
        view.addSubview(headerView)
        view.addSubview(bodyView)
        view.addSubview(timeElapsed)
        view.addSubview(footerView)
        view.addSubview(horizontalStack)
        
        horizontalStack.addArrangedSubview(actionButton)
        
        timeElapsed.layer.borderColor = UIColor.black.cgColor
        timeElapsed.layer.borderWidth = 1
        
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
            
            if iconButton == "pause.fill" {
                print("play button leader tapped")
                iconButton = "play.fill"
                horizontalStack.addArrangedSubview(endButton)
                
            } else if iconButton == "play.fill" {
                print("paused button leader tapped")
                iconButton = "pause.fill"
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
    
    func checkDistance() {
        if Double(destinationDetail.trackLength) == workoutManager?.distance {
//            timeElapsed.stopStopwatch()
            // MARK: Pause Timer 
        }
        
    }
    
}

extension HikingSessionVC: HikingSessionVCDelegate {
    func didUpdateEstTime(_ time: TimeInterval) {
        print("didUpdateEstTime: ", time)
        self.footerView.updateEstTime("\(time)")
    }
    
    func didUpdateRestTaken(_ restCount: Int) {
        self.footerView.updateRestTaken("\(restCount)x")
    }
    
    func didReceivedHikingState(_ state: HikingStateEnum) {
        /// Update label based on state
        print("Current Hiking State: \(state.rawValue)")
    }
    
}

extension HikingSessionVC: WorkoutDelegate {
    
    func didUpdateWhatToDo(_ whatToDo: TimingState) {
           headerView.configureValueState(whatToDo)
        print("this what to do \(whatToDo)")
    }
    
    func didUpdateElapsedTimeInterval(_ elapsedTimeInterval: TimeInterval) {
        // tampilin di stopwatch maju
       print("nilai elapsed time \(elapsedTimeInterval)")
        
        timeElapsed.updateLabel(elapsedTimeInterval)
        
    }
    
    func didUpdateRemainingTime(_ remainingTime: TimeInterval) {
        headerView.configureValueRemaining(remainingTime)
    }
    
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
            checkDistance()
        }
        
        /// From CoreBluetooth
        self.footerView.updateDistance("\(Int(distance)) m")
        
        guard let userData = userDefaultManager?.getUserData() else { return }
        
        /// Broadcast to other member if any update distance
        if userData.role == .leader {
            self.centralManager?.updateDistance(distance)
        }
        
    }
    
    func didUpdateSpeed(_ speed: Double) {
        naismithTime = calculateHikingTime(distance: Double(destinationDetail.trackLength), elevationGain: Double(destinationDetail.maxElevation), speed: speed) * 60
        
        guard let naismithTime = naismithTime else { return }
        if naismithTime.isNaN || naismithTime.isInfinite {
            footerView.updateEstTime("calculating")
        } else {
            let naismithTimeInt = Int(naismithTime)
            footerView.updateEstTime("\(naismithTimeInt) min")
        }

        guard speed < 0.2 else { return }
        
        guard let userData = userDefaultManager?.getUserData() else { return }
        
        if userData.role == .leader {
            notificationManager?.requestRest(for: .notMoving, name: nil)
            
            /// Broadcast to other member if any update est time
            centralManager?.updateEstTime(naismithTime ?? 0)
            
        } else {
            /// Tell central if member not moving
            peripheralManager?.requestRest(for: .notMoving)
        }
        
    }
    
}
