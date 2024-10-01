//
//  DetailDestinationVC.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 30/09/24.
//

import UIKit
import CoreLocation

class DetailDestinationVC: UIViewController {
    
    var destinationSelected: DestinationModel!
    var teamView: TeamsView!
    var alertNotRange: AlertRangeView = AlertRangeView()
    var isInrangeLocation: Bool = false
    var locationManager: CLLocationManager = {
       let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()
    var userLocation: CLLocation?
    
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
       let assets = UIImageView()
        assets.contentMode = .scaleAspectFill
        assets.backgroundColor = .blue
        return assets
    }()
    
    private var selectButton: PrimaryButton = PrimaryButton(label: "Let’s Go!")
    
    init(destination: DestinationModel) {
        super.init(nibName: nil, bundle: nil)
        
        destinationSelected = destination
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization() // Minta izin akses lokasi
        locationManager.startUpdatingLocation()
        
        teamView = TeamsView(action: #selector(teamAction))
        
        assetsImage.image = UIImage(named: "\(destinationSelected.image)")
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "\(destinationSelected?.name ?? "Bidadari Lake")"
        
        setupUI()

    }

    private func setupUI() {
//        view.addSubview(titleDestination)
        view.addSubview(horizontalStack)
        view.addSubview(teamView)
        view.addSubview(assetPreview)
        view.addSubview(selectButton)
        view.bringSubviewToFront(selectButton)
        
        selectButton.addTarget(self, action: #selector(actionButton), for: .touchDown)
        assetPreview.addSubview(assetsImage)
//        titleDestination.text = destinationSelected?.name ?? "Bidadari Lake"
        
        let estTimeDetail = DetailDestinationView(
            icon: "clock",
            title: "Est. Time",
            value: "\(destinationSelected?.estimatedTime ?? TimeInterval())"
        )
        
        let elevationDetail = DetailDestinationView(
            icon: "arrow.up.right",
            title: "Elevation",
            value: "\(destinationSelected?.maxElevation ?? 100) m"
        )
        
        let trackDetail = DetailDestinationView(
            icon: "point.topleft.down.to.point.bottomright.curvepath.fill",
            title: "Length",
            value: "\(destinationSelected?.trackLength ?? 0) m"
        )
        
        horizontalStack.addArrangedSubview(estTimeDetail)
        horizontalStack.addArrangedSubview(elevationDetail)
        horizontalStack.addArrangedSubview(trackDetail)
        
//        titleDestination.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.leading.trailing.equalToSuperview().offset(20)
//        }
        
        horizontalStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(20)
            
        }
        
        teamView.snp.makeConstraints { make in
            make.top.equalTo(horizontalStack.snp.bottom).offset(12)
            make.leading.trailing.equalTo(horizontalStack)
        }
        
        assetPreview.snp.makeConstraints { make in
            make.top.equalTo(teamView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(240)
        }
        
        assetsImage.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        selectButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(316)
            make.height.equalTo(50)
        }
    }
    
    @objc
    func teamAction() {
        print("add friends button tapped")
        showModalAddFriend()
        
    }
    
    func showModalAddFriend() {
        let addFriendVC = AddFriendVC()
        addFriendVC.modalPresentationStyle = .formSheet
        
        if let sheet = addFriendVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            present(addFriendVC, animated: true)
        }
    }

}

extension DetailDestinationVC: CLLocationManagerDelegate {
    
    @objc
    private func actionButton() {
        
        guard let userLocation = userLocation else { return print("User Location is Unavailable")}
        let rangeDistance = checkInRangeDestination(currentLocation: userLocation)
        let maximumDistance = 200.0
        
        if rangeDistance < maximumDistance {
            print("Disctance is less than maximum distance: \(rangeDistance)")
            let hikingSessionVC = HikingSessionVC()
            navigationController?.pushViewController(hikingSessionVC, animated: true)
        } else {
            alertNotRange.showAlert(on: self)
//            let hikingSessionVC = HikingSessionVC()
//            navigationController?.pushViewController(hikingSessionVC, animated: true)
            print("Distance is greater than maximum distance: \(rangeDistance)")
        }
        
    }
    
    private func checkInRangeDestination(currentLocation: CLLocation) -> CLLocationDistance {
        let locationDestination = destinationSelected.locationPoint
        let distance = currentLocation.distance(from: locationDestination)
        return distance
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            self.userLocation = currentLocation
            print("Lokasi terkini diperbarui: \(currentLocation)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Err: \(error.localizedDescription)")
    }
    
}
