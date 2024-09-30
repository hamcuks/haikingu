//
//  OnboardingHealthAccessVC.swift
//  HaikinguApp
//
//  Created by Kelvin Ananda on 30/09/24.
//

import UIKit
import SnapKit
import HealthKit

class OnboardingHealthAccessVC: UIViewController {

    // UI Components
    let heartIconImageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let disclaimerLabel = UILabel()
    let allowButton = UIButton()

    // HealthKit store for requesting health data
    let healthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // Heart Icon ImageView
        heartIconImageView.image = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        heartIconImageView.contentMode = .scaleAspectFit
        heartIconImageView.layer.cornerRadius = 20
        heartIconImageView.layer.borderWidth = 2
        heartIconImageView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(heartIconImageView)

        // Title Label
        titleLabel.text = "Heart Rate Monitoring"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        view.addSubview(titleLabel)

        // Description Label
        descriptionLabel.text = "We need access to your health data to monitor your heart rate and suggest breaks."
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)

        // Disclaimer Label
        disclaimerLabel.text = "Your health data will never leave this device"
        disclaimerLabel.font = UIFont.systemFont(ofSize: 14)
        disclaimerLabel.textAlignment = .center
        disclaimerLabel.textColor = .gray
        view.addSubview(disclaimerLabel)

        // Allow Health Access Button
        allowButton.setTitle("Allow Health Access", for: .normal)
        allowButton.backgroundColor = UIColor(red: 88/255, green: 113/255, blue: 96/255, alpha: 1.0)
        allowButton.layer.cornerRadius = 8
        allowButton.setTitleColor(.white, for: .normal)
        allowButton.addTarget(self, action: #selector(allowHealthAccessTapped), for: .touchUpInside)
        view.addSubview(allowButton)

        // Setup Constraints
        setupConstraints()
    }

    func setupConstraints() {
        // Heart Icon Constraints
        heartIconImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }

        // Title Label Constraints
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(heartIconImageView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(20)
        }

        // Description Label Constraints
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
        }

        // Disclaimer Label Constraints
        disclaimerLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }

        // Allow Button Constraints
        allowButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
    }

    // Request HealthKit permissions
    @objc func allowHealthAccessTapped() {
        let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let typesToRead: Set = [heartRateType]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
            if success {
                DispatchQueue.main.async {
                    // Handle successful authorization here (e.g., navigate to the next screen)
                    print("Health data access granted!")
                }
            } else {
                DispatchQueue.main.async {
                    // Handle the error here (e.g., show an alert)
                    print("Authorization failed with error: \(String(describing: error))")
                }
            }
        }
    }
}
