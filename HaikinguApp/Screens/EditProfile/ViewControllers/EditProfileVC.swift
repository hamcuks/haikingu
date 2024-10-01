//
//  EditProfileVC.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 01/10/24.
//

import UIKit
import SnapKit

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UI Components
    lazy private var profileImageView = UIImageView()
    lazy private var nameTextField = UITextField()
    lazy private var horizontalStack: UIStackView = {
        let horizontal = UIStackView()
        horizontal.axis = .horizontal
        horizontal.spacing = 4
        horizontal.distribution = .fillProportionally
        horizontal.alignment = .leading
        return horizontal
    }()
    lazy private var saveButton = PrimaryButton(label: "Save")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
    }

    func setupUI() {
        
        view.addSubview(saveButton)
        
        view.addSubview(horizontalStack)
        view.addSubview(saveButton)
        horizontalStack.addArrangedSubview(profileImageView)
        horizontalStack.addArrangedSubview(nameTextField)
        
        // Profile Image View
        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.tintColor = .darkGray
        profileImageView.isUserInteractionEnabled = true
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.masksToBounds = true
        
        // Name Text Field
        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .none
        nameTextField.font = UIFont.systemFont(ofSize: 18)
        nameTextField.keyboardType = .default
        nameTextField.returnKeyType = .done
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = .gray
        nameTextField.addSubview(bottomBorder)
        bottomBorder.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        // Profile Image View Constraints
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(90)
        }
        
        // Name TextField Constraints
        nameTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        horizontalStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(30)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(30)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(30)
            make.height.equalTo(100)
        }

        // Save Button Constraints
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30)
            make.leading.trailing.equalTo(horizontalStack)
            make.height.equalTo(50)
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
