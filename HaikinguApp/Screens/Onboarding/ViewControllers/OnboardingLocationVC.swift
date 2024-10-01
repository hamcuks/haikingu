//
//  OnboardingLocationVC.swift
//  HaikinguApp
//
//  Created by Kelvin Ananda on 01/10/24.
//

import UIKit
import SnapKit
import CoreLocation

class OnboardingLocationVC: UIViewController, CLLocationManagerDelegate {

    // UI Components
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let allowButton = UIButton()

    // HealthKit store for requesting health data
    let locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        locationManager.delegate = self

        // Heart Icon ImageView from Assets
        imageView.image = UIImage(named: "OnboardingLocationIcon") // Replace with your asset image name
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        // Setup Constraints for ImageView (264x264)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(254)  // Set width and height to 264
        }

        // Title Label
        titleLabel.text = "Location & Motion Access Needed"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)

        // Description Label
        descriptionLabel.text = "We need access to your location and motion data to recommend nearby trails and monitor your hiking activity"
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)

        // Allow Health Access Button
        allowButton.setTitle("Allow Location & Motion Access", for: .normal)
        allowButton.backgroundColor = UIColor(red: 88/255, green: 113/255, blue: 96/255, alpha: 1.0)
        allowButton.layer.cornerRadius = 8
        allowButton.setTitleColor(.white, for: .normal)
        allowButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(allowButton)

        // Setup Constraints
        setupConstraints()
    }

    func setupConstraints() {
        // Heart Icon Constraints
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }

        // Title Label Constraints
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }

        // Description Label Constraints
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }
        
        // Allow Button Constraints
        allowButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
    }
    
    func showLocationAccessAlert() {
        let alert = UIAlertController(title: "Location Access Needed", message: "Please enable location services in settings.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    @objc func buttonTapped() {
        
        if locationManager.authorizationStatus == .notDetermined {
            requestLocationPermission()
        } else if locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .restricted {
            showLocationAccessAlert()
        } else {
            let profileVC = OnboardingHikingProfileVC()
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
    
    // CLLocationManagerDelegate method to handle authorization changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            let profileVC = OnboardingHikingProfileVC()
            navigationController?.pushViewController(profileVC, animated: true)
        case .denied, .restricted:
            showLocationAccessAlert()
        default:
            print("Error Something went wrong")
            break
        }
    }

    
    
}
