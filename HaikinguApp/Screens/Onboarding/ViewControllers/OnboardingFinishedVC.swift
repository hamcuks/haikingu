//
//  OnboardingFinishedVC.swift
//  HaikinguApp
//
//  Created by Kelvin Ananda on 01/10/24.
//

import UIKit
import SnapKit
import HealthKit

class OnboardingFinishedVC: UIViewController {
    
    /// managers
    var userDefaultManager: UserDefaultService?

    // UI Components
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let button = UIButton()

    // HealthKit store for requesting health data
    let healthStore = HKHealthStore()
    
    init(userDefault: UserDefaultService?) {
        super.init(nibName: nil, bundle: nil)
        self.userDefaultManager = userDefault
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // Heart Icon ImageView from Assets
        imageView.image = UIImage(named: "OnboardingFinishedIcon") // Replace with your asset image name
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        // Setup Constraints for ImageView (264x264)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(254)  // Set width and height to 264
        }

        // Title Label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        view.addSubview(titleLabel)

        // Description Label
        descriptionLabel.text = "Now you’re ready to explore hiking destinations and connect with your group"
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .darkGray
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)

        // Allow Health Access Button
        button.setTitle("Continue", for: .normal)
        button.backgroundColor = UIColor(red: 88/255, green: 113/255, blue: 96/255, alpha: 1.0)
        button.layer.cornerRadius = 8
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(button)

        // Setup Constraints
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let userData = userDefaultManager?.getUserData() {
                // Perbarui UI berdasarkan data user
                updateUserInterface(with: userData)
        }
        
    }
    
    private func updateUserInterface(with user: User) {
        // Perbarui nama pada header view (misalnya jika ada label nama di header)
        titleLabel.text = "You’re All Set, \(user.name)!"
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
        button.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.left.right.equalToSuperview().inset(40)
            make.height.equalTo(50)
        }
    }

    // Request HealthKit permissions
    @objc func buttonTapped() {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.markFirstUserComplete()
            sceneDelegate.navigateToHomeVC()
        }
    }
}
