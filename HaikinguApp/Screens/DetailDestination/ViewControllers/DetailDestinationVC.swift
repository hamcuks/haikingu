//
//  DetailDestinationVC.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 30/09/24.
//

import UIKit
import CoreLocation
import Swinject
import SnapKit

enum UserType {
    case leader
    case member
}

class DetailDestinationVC: UIViewController {
    
    /// Managers
    var centralManager: CentralBLEService?
    var workoutManager: WorkoutServiceIos?
    
    /// Delegates
    internal var addFriendDelegate: AddFriendVCDelegate?
    
    var selectedPlan: DestinationList?
    var selectedDestination: DestinationModel!
    var teamView: TeamsView!
    var alertNotRange: AlertRangeView = AlertRangeView()
    var isInrangeLocation: Bool = false
    var locationManager: CLLocationManager = {
       let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()
    var userLocation: CLLocation?
    var role: UserType = .leader
    var isSoloHiker: Bool = false
    
    private var horizontalStack: UIStackView = {
        let horizontal = UIStackView()
        horizontal.axis = .horizontal
        horizontal.spacing = 4
        horizontal.distribution = .fillEqually
        horizontal.alignment = .leading
        return horizontal
    }()
    
    private var titleDestination: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = .systemFont(ofSize: 24, weight: .semibold)
        title.textAlignment = .left
        return title
    }()
    
    private var assetPreview: UIView = {
        let assetPreview = UIView()
        assetPreview.backgroundColor = .blue
        assetPreview.layer.cornerRadius = 10
        assetPreview.clipsToBounds = true
        return assetPreview
    }()
    
    private var assetsImage: UIImageView = {
       let image = UIImageView()
        image.image = UIImage(named: "Bidadari")
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .blue
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 10
        
        return image
    }()
    
    private var selectButton: PrimaryButton = PrimaryButton(label: "Let’s Go!")
    
    init(centralManager: CentralBLEService?, workoutManager: WorkoutServiceIos?) {
        super.init(nibName: nil, bundle: nil)
        
        
        self.workoutManager = workoutManager
        self.centralManager = centralManager
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.centralManager?.setDelegate(self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.workoutManager?.setDelegateV2(self)
        workoutManager?.retrieveRemoteSession()
        view.backgroundColor = .white
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // Minta izin akses lokasi
        locationManager.startUpdatingLocation()
        
        teamView = TeamsView(frame: self.view.bounds, action: #selector(teamAction), isSolo: isSoloHiker)
        
        assetsImage.image = UIImage(named: "\(selectedDestination.image)")
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = selectedDestination?.name
        navigationController?.navigationBar.tintColor = .brown
        
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.isMovingFromParent {
            centralManager?.stopScanning()
        }
    }

    private func setupUI() {
        
        let estTimeDetail = DetailDestinationView(
            icon: "clock",
            title: "Est. Time",
            value: "\(selectedDestination?.estimatedTime ?? 0)"
        )
        
        let elevationDetail = DetailDestinationView(
            icon: "arrow.up.right",
            title: "Elevation",
            value: "\(selectedDestination?.maxElevation ?? 0) m"
        )
        
        let trackDetail = DetailDestinationView(
            icon: "point.topleft.down.to.point.bottomright.curvepath.fill",
            title: "Length",
            value: "\(selectedDestination?.trackLength ?? 0) m"
        )
        
        horizontalStack.addArrangedSubview(estTimeDetail)
        horizontalStack.addArrangedSubview(elevationDetail)
        horizontalStack.addArrangedSubview(trackDetail)
        
        teamView.isHidden = self.role == .member
        
        let stack = UIStackView(arrangedSubviews: [horizontalStack, teamView, assetsImage])
        stack.axis = .vertical
        stack.spacing = 24
        view.addSubview(stack)
        
        if isSoloHiker {
            stack.subviews.indices.forEach { if stack.subviews[$0] == teamView {
                stack.subviews[$0].isHidden = true
            } }
        }
        
        stack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        view.addSubview(selectButton)
        selectButton.isEnabled = self.role == .leader
        selectButton.backgroundColor = self.role == .member ? .lightGray : selectButton.backgroundColor
        
        if role == .member {
            selectButton.setTitle("Waiting for others to join", for: .normal)
        }
        
        selectButton.addTarget(self, action: #selector(actionButton), for: .touchDown)

        selectButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            make.leading.trailing.equalTo(horizontalStack)
            make.height.equalTo(50)
        }
        
        assetsImage.snp.makeConstraints { make in
            make.height.equalTo(320)
        }
    }
    
    @objc
    func teamAction() {
        self.centralManager?.startScanning()
        
        showModalAddFriend()
        
    }
    
    func showModalAddFriend() {
        let addFriendVC = AddFriendVC()
        addFriendVC.manager = centralManager
        addFriendVC.selectedPlan = selectedPlan
        addFriendVC.modalPresentationStyle = .formSheet
        
        self.addFriendDelegate = addFriendVC
        
        if let sheet = addFriendVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            present(addFriendVC, animated: true)
        }
    }
    
//    func startHikingOnWatch() {
//        Task {
//            do {
//                try await workoutManager?.startWatchWorkout(workoutType: .hiking)
//            } catch {
//                print("gagal start watch workout")
//            }
//        }
//    }

}

extension DetailDestinationVC: CLLocationManagerDelegate {
    
    @objc
    private func actionButton() {
        
        guard let userLocation = userLocation else { return print("User Location is Unavailable")}
        let rangeDistance = checkInRangeDestination(currentLocation: userLocation)
        let maximumDistance = 1000.0
        workoutManager?.sendStartToWatch()
//        startHikingOnWatch()
        
        if rangeDistance < maximumDistance {
            guard let hikingSessionVC = Container.shared.resolve(HikingSessionVC.self) else { return }
            hikingSessionVC.destinationDetail = selectedDestination
            navigationController?.pushViewController(hikingSessionVC, animated: true)
            print("Disctance is less than maximum distance: \(rangeDistance)")
            self.centralManager?.updateHikingState(for: .started)
        } else {
            alertNotRange.showAlert(on: self)
//            guard let hikingSessionVC = Container.shared.resolve(HikingSessionVC.self) else { return }
//            hikingSessionVC.destinationDetail = selectedDestination
//            navigationController?.pushViewController(hikingSessionVC, animated: true)
//            print("Distance is greater than maximum distance: \(rangeDistance)")
//            self.centralManager?.updateHikingState(for: .started)
        }
        
    }
    
    private func checkInRangeDestination(currentLocation: CLLocation) -> CLLocationDistance {
        let locationDestination = selectedDestination.locationPoint
        let distance = currentLocation.distance(from: locationDestination)
        return distance
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            self.userLocation = currentLocation
//            print("Lokasi terkini diperbarui: \(currentLocation)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Err: \(error.localizedDescription)")
    }
    
}

extension DetailDestinationVC: WorkoutDelegateV2{
    func didUpdateIsWorkoutStarted(_ isWorkoutStarted: Bool) {
        if isWorkoutStarted{
            guard let userLocation = userLocation else { return print("User Location is Unavailable")}
            let rangeDistance = checkInRangeDestination(currentLocation: userLocation)
            let maximumDistance = 1000.0
            workoutManager?.sendStartToWatch()
    //        startHikingOnWatch()
            
            if rangeDistance < maximumDistance {
                guard let hikingSessionVC = Container.shared.resolve(HikingSessionVC.self) else { return }
                hikingSessionVC.destinationDetail = selectedDestination
                navigationController?.pushViewController(hikingSessionVC, animated: true)
                print("Disctance is less than maximum distance: \(rangeDistance)")
                self.centralManager?.updateHikingState(for: .started)
            } else {
                alertNotRange.showAlert(on: self)
    //            guard let hikingSessionVC = Container.shared.resolve(HikingSessionVC.self) else { return }
    //            hikingSessionVC.destinationDetail = selectedDestination
    //            navigationController?.pushViewController(hikingSessionVC, animated: true)
    //            print("Distance is greater than maximum distance: \(rangeDistance)")
    //            self.centralManager?.updateHikingState(for: .started)
            }
        }
    }
    
    
}
