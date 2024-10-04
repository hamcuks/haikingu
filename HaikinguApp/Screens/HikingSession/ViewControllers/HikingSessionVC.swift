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
    var timeElapsed: TimeElapsedView!
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
    
    var userData: User?
    
    var naismithTime: Double?
    var naismithDefault: Double?
    var restTakenCount: Int = 0
    
    @Published var iconButton: String = "pause.fill"
    
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
        headerView.configureValueState(workoutManager?.whatToDo ?? .timeToRest)
        timeElapsed.updateLabel(workoutManager!.elapsedTimeInterval)
        
        userData = userDefaultManager?.getUserData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.workoutManager?.setDelegate(self)
        view.backgroundColor = .white
        
        timeElapsed = TimeElapsedView(workoutManager: workoutManager!)
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
        
        naismithDefault = calculateHikingTime(distance: Double(destinationDetail.trackLength), elevationGain: Double(destinationDetail.maxElevation), speed: 1.2) * 60
        
    }
    
    private func configureUI() {
        
        view.addSubview(headerView)
        view.addSubview(bodyView)
        view.addSubview(timeElapsed)
        view.addSubview(footerView)
        view.addSubview(horizontalStack)
        
        horizontalStack.addArrangedSubview(endButton)
        horizontalStack.addArrangedSubview(actionButton)
        
        horizontalStack.subviews.first?.isHidden = true
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
        let timeForDistance = distance / (speed * 3600)
        let timeForElevation = elevationGain / 600
        let totalTime = timeForDistance + timeForElevation
        return totalTime
    }
    
    @objc
    func actionButtonTapped() {
        guard let user = userData else { return }
        
        switch user.role {
        case .member:
            
            if iconButton == "pause.fill" {
                print("paused button member tapped")
                iconButton = "clock.fill"
                actionButton.isEnabled = false
            }
            
            actionButton.setImage(UIImage(systemName: iconButton), for: .normal)
            
        case .leader:
            
            if iconButton == "pause.fill" {
                print("play button leader tapped")
                iconButton = "play.fill"
                //                horizontalStack.addArrangedSubview(endButton)
                horizontalStack.subviews.first?.isHidden = false
                workoutManager?.sendPausedToWatch()
                
            } else if iconButton == "play.fill" {
                print("paused button leader tapped")
                iconButton = "pause.fill"
                //                horizontalStack.removeArrangedSubview(endButton)
                //                endButton.removeFromSuperview()
                horizontalStack.subviews.first?.isHidden = true
                workoutManager?.sendResumedToWatch()
                
                //                // Modifikasi workoutManager menggunakan serial queue
                DispatchQueue.main.async {
                    if self.workoutManager?.whatToDo == .timeToRest {
                        self.workoutManager?.whatToDo = .timeToWalk
                    }
                }
                
                //                DispatchQueue.main.async {
                //                    if self.workoutManager?.whatToDo == .timeToRest {
                //                        self.workoutManager?.whatToDo = .timeToWalk
                //                    } else if self.workoutManager?.whatToDo == .timeToWalk {
                //                        self.workoutManager?.whatToDo = .timeToRest
                //                    }
                //                }
                
            }
            
            actionButton.setImage(UIImage(systemName: iconButton), for: .normal)
            
        }
    }
    
    @objc
    func endActionTapped() {
        workoutManager?.stopTimer()
        workoutManager?.sessionState = .ended
        guard let finishVC = Container.shared.resolve(CongratsVC.self) else { return }
        finishVC.destinationDetail = destinationDetail
        finishVC.restTakenTotal = restTakenCount
        navigationController?.pushViewController(finishVC, animated: true)
    }
    
    func checkDistance() {
        if Double(destinationDetail.trackLength) == workoutManager?.distance {
            workoutManager?.stopTimer()
            workoutManager?.sessionState = .ended
            guard let finishVC = Container.shared.resolve(CongratsVC.self) else { return }
            finishVC.destinationDetail = destinationDetail
            navigationController?.pushViewController(finishVC, animated: true)
        }
    }
    
}

/// This extension used for CoreBluetooth Peripheral (Hiking Member)
extension HikingSessionVC: HikingSessionVCDelegate {
    
    func didUpdateEstTime(_ time: TimeInterval) {
        print("didUpdateEstTime: ", time)
        guard let naismithTime = naismithTime else { return }
        guard let userData = self.userData else { return }
        
        if naismithTime.isNaN || naismithTime.isInfinite {
            footerView.updateEstTime("\(Int(naismithDefault ?? 0)) min")
            if userData.role == .leader {
                centralManager?.updateEstTime(naismithDefault ?? 0)
            }
        } else {
            let naismithTimeInt = Int(naismithTime)
            footerView.updateEstTime("\(naismithTimeInt) min")
            if userData.role == .leader {
                centralManager?.updateEstTime(naismithTime)
            }
        }
        
    }
    
    func didUpdateRestTaken(_ restCount: Int) {
        guard let userData = self.userData else { return }
        if userData.role == .leader {
            centralManager?.updateRestTaken(restTakenCount)
        }
        self.footerView.updateRestTaken("\(restTakenCount)x")
        
    }
    
    func didReceivedHikingState(_ state: HikingStateEnum) {
        /// Update hiking member component based on hiking state
        print("Current Hiking State: \(state.rawValue)")
        
        switch state {
            
        case .paused:
            centralManager?.requestRest(for: .timeToBreak, exclude: nil)
        case .notStarted:
            /// ini ngapain kak?
            print("current state is not started")
        case .started:
            centralManager?.requestRest(for: .timeToWalk, exclude: nil)
            
        }
    }
    
}

extension HikingSessionVC: WorkoutDelegate {
    
    func didWorkoutPaused(_ isWorkoutPaused: Bool) {
        if isWorkoutPaused {
            self.iconButton = "play.fill"
            self.horizontalStack.subviews.first?.isHidden = false
            self.centralManager?.updateHikingState(for: .paused)
        } else {
            self.iconButton = "pause.fill"
            self.horizontalStack.subviews.first?.isHidden = true
            self.centralManager?.updateHikingState(for: .started)
        }
        
        self.actionButton.setImage(UIImage(systemName: self.iconButton), for: .normal)
    }
    
    func didUpdateRestAmount(_ restTaken: Int) {
        guard let userData = self.userData else { return }
        if userData.role == .leader {
            centralManager?.updateRestTaken(restTaken)
        }
        self.footerView.updateRestTaken("\(restTaken)x")
        restTakenCount = restTaken
        print("Rest Takken : \(restTaken)")
    }
    
    func didUpdateWhatToDo(_ whatToDo: TimingState) {
        print("Current whatToDo: \(whatToDo)")
        
        guard let userData = self.userData else { return }
        
        if whatToDo == .timeToRest {
            if userData.role == .leader {
                self.centralManager?.updateHikingState(for: .paused)
                self.centralManager?.requestRest(for: .mandatoryBreak, exclude: nil)
                self.centralManager?.requestRest(for: .timeToBreak, exclude: nil)
            }
            iconButton = "play.fill"
            horizontalStack.subviews.first?.isHidden = false
            headerView.configureValueState(whatToDo)
        } else if whatToDo == .timeToWalk {
            if userData.role == .leader {
                self.centralManager?.updateHikingState(for: .started)
                self.centralManager?.requestRest(for: .timeToWalk, exclude: nil)
            }
            iconButton = "pause.fill"
            horizontalStack.subviews.first?.isHidden = true
            headerView.configureValueState(whatToDo)
        }
        
        actionButton.setImage(UIImage(systemName: iconButton), for: .normal)
        print("this what to do \(whatToDo)")
    }
    
    func didUpdateElapsedTimeInterval(_ elapsedTimeInterval: TimeInterval) {
        /// gaada sync time elapsed dari central?
        timeElapsed.updateLabel(elapsedTimeInterval)
    }
    
    func didUpdateRemainingTime(_ remainingTime: TimeInterval) {
        headerView.configureValueRemaining(remainingTime)
//        guard let speed = workoutManager?.speed else {
//            if workoutManager?.speed == nil {
//                print("speed nil")
//            } else {
//                print("value speed : \((workoutManager?.speed)!)")
//            }
//            return
//        }
//        didUpdateSpeed(speed)
    }
    
    func didUpdateHeartRate(_ heartRate: Double) {
        print("heart rate")
        
        if workoutManager?.isPersonTired() ?? false {
            workoutManager?.pauseTimer()
            headerView.bpmHigh()
            self.peripheralManager?.requestRest(for: .abnormalBpm)
        } else if workoutManager?.isPersonTired() == false {
            //            headerView.personNormal()
            //            workoutManager?.resumeTimer()
            self.peripheralManager?.requestRest(for: .bpmAlreadyNormal)
        }
        
    }
    
    func didUpdateDistance(_ distance: Double) {
        if Double(destinationDetail.trackLength) == workoutManager?.distance {
            checkDistance()
        }
        /// From CoreBluetooth
        self.footerView.updateDistance("\(Int(distance)) m")
        
        guard let userData = self.userData else { return }
        
        /// Broadcast to other member if any update distance
        if userData.role == .leader {
            self.centralManager?.updateDistance(distance)
        }
        
        print("Ini distance : \(distance)")
    }
    
    func didUpdateSpeed(_ speed: Double) {
        
        naismithTime = calculateHikingTime(distance: Double(destinationDetail.trackLength), elevationGain: Double(destinationDetail.maxElevation), speed: speed) * 60
        
        guard let naismithTime = naismithTime else { return }
        guard let userData = self.userData else { return }
        
        if naismithTime.isNaN || naismithTime.isInfinite {
            footerView.updateEstTime("\(Int(naismithDefault ?? 0)) min")
            if userData.role == .leader {
                centralManager?.updateEstTime(naismithDefault ?? 0)
            }
        } else {
            let naismithTimeInt = Int(naismithTime)
            footerView.updateEstTime("\(naismithTimeInt) min")
            if userData.role == .leader {
                centralManager?.updateEstTime(naismithTime)
            }
        }
        
        if speed < 0.3 && workoutManager?.whatToDo == .timeToWalk {
            
            print("speed == \(speed) | \(workoutManager!.whatToDo) | not moving")
            headerView.personNotmove()
            
            guard let userData = self.userData else { return }
            
            if userData.role == .leader {
                notificationManager?.requestRest(for: .notMoving, name: nil)
                /// Broadcast to other member if any update est time
                centralManager?.updateEstTime(naismithTime)
                
            } else {
                /// Tell central if member not moving
                peripheralManager?.requestRest(for: .notMoving)
            }
            
            workoutManager?.pauseTimer()
            
        } else if speed >= 0.3 && workoutManager?.whatToDo == .timeToWalk {
            print("header : normal time")
            headerView.configureValueState(workoutManager?.whatToDo ?? .timeToRest)
            
        } else {
            headerView.configureValueState(workoutManager?.whatToDo ?? .timeToRest)
            print("what to do : \(workoutManager?.whatToDo ?? .timeToRest)")
        }
        
    }
    
}
