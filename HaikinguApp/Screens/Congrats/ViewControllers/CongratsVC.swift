//
//  CongratsVC.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 01/10/24.
//

import UIKit
import SnapKit

class CongratsVC: UIViewController {
    
    var headerCongratsView: HeaderCongratsView!
    
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    var backgroundImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "background")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    var profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "camera.fill")
        image.contentMode = .center
        image.tintColor = .black
        image.backgroundColor = .lightGray
        image.isUserInteractionEnabled = true
        image.layer.cornerRadius = 25
        image.layer.masksToBounds = true
        return image
    }()
    
    var hikingSummaryView: HikingSummaryView!
    var reminderBackView: ReminderView!
    
    var imagePickerController: UIImagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        headerCongratsView = HeaderCongratsView(
            destinationTitle: "Bidadari lake",
            destinationTime: "1 Hour 25 Minutes"
        )
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
        
        configureUI()
    }
    
    private func configureUI() {
        
        view.addSubview(headerCongratsView)
        view.addSubview(backgroundView)
        backgroundView.addSubview(profileImageView)
        backgroundView.addSubview(backgroundImageView)
        backgroundView.bringSubviewToFront(profileImageView)
        
        headerCongratsView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(20)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(headerCongratsView.snp.bottom).offset(16)
            make.leading.equalTo(headerCongratsView.snp.leading)
            make.trailing.equalTo(headerCongratsView.snp.trailing)
            make.height.equalTo(203)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalTo(backgroundView)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.bottom.equalTo(backgroundView.snp.bottom).inset(20)
            make.centerX.equalTo(backgroundView.snp.centerX)
            make.height.width.equalTo(50)
        }
        
    }
    
    @objc func profileImageTapped() {
        // Show action sheet to choose between photo library or camera
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true

        let actionSheet = UIAlertController(title: "Upload your Picture", message: "Let's documented your journey, choose a source picture", preferredStyle: .actionSheet)
        
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

}

extension CongratsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UIImagePickerControllerDelegate method for image selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            backgroundImageView.image = editedImage
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            backgroundImageView.image = originalImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate method for cancellation
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
