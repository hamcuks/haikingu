//
//  OnboardingVC.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 16/09/24.
//

import UIKit
import SnapKit
import Swinject

class OnboardingHikingProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UI Components
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let profileImageView = UIImageView()
    let nameTextField = UITextField()
    let saveButton = UIButton()
    var userDefaultManager: UserDefaultService?
    
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
        
        // Title Label
        titleLabel.text = "Customize Your Hiking Profile"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)
        
        // Subtitle Label
        subtitleLabel.text = "Enter your name and upload your photo to easily identify yourself in group hiking invitations."
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textColor = .darkGray
        view.addSubview(subtitleLabel)
        
        // Profile Image View
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.tintColor = .darkGray
        profileImageView.isUserInteractionEnabled = true
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.masksToBounds = true
        view.addSubview(profileImageView)
        
        // Name Text Field
        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .none
        nameTextField.font = UIFont.systemFont(ofSize: 18)
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = .gray
        nameTextField.addSubview(bottomBorder)
        bottomBorder.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        view.addSubview(nameTextField)
        
        // Save Button
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = UIColor(red: 149/255, green: 182/255, blue: 173/255, alpha: 1.0)
        saveButton.layer.cornerRadius = 8
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.addTarget(self, action: #selector(actionSaveButton), for: .touchUpInside)
        view.addSubview(saveButton)

        // Setup Constraints
        setupConstraints()
        
        // Tap gesture for image view (to upload photo)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
    }

    func setupConstraints() {
        // Title Label Constraints
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.left.right.equalToSuperview().inset(16)
        }

        // Subtitle Label Constraints
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
        }

        // Profile Image View Constraints
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(100)
        }

        // Name TextField Constraints
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(16)
        }

        // Save Button Constraints
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
    }
    
    @objc
    private func actionSaveButton() {
        
        guard let name = nameTextField.text, !name.isEmpty else {
            // Handle empty name
            print("Name is empty")
            return
        }
        
        // Convert UIImage to Data (optional)
        guard let imageData = profileImageView.image?.pngData() else {
            // Handle no image
            print("Image is empty")
            return
        }
        
        // Convert image data to base64 string
        let imageBase64String = imageData.base64EncodedString()
        
        // Create User object
        let user = User(name: name, image: imageBase64String, role: .leader)
        
        // Gunakan UserDefaultsManager untuk menyimpan data user
        userDefaultManager?.saveuserData(user: user)
        let userStored = userDefaultManager?.getUserData()
        
        print("name : \(String(describing: userStored?.name))")
        print("image : \(String(describing: userStored?.image))")
        print("role : \(String(describing: userStored?.role))")
    
        guard let finishVC = Container.shared.resolve(OnboardingFinishedVC.self) else { return }
        navigationController?.pushViewController(finishVC, animated: true)
    }
    
    private func saveUserToUserDefaults(_ user: User) {
        let defaults = UserDefaults.standard
        if let encodedUser = try? JSONEncoder().encode(user) {
            defaults.set(encodedUser, forKey: "savedUser")
        }
    }

    // Action for profile image tap
    @objc func profileImageTapped() {
        // Show action sheet to choose between photo library or camera
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true

        let actionSheet = UIAlertController(title: "Profile Picture", message: "Choose a source", preferredStyle: .actionSheet)
        
        // Option 1: Camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }

        // Option 2: Photo Library
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))

        // Option to cancel
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(actionSheet, animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate method for image selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = originalImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate method for cancellation
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
