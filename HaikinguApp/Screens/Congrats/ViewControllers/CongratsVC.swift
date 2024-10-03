//
//  CongratsVC.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 01/10/24.
//

import UIKit
import SnapKit

class CongratsVC: UIViewController {
    
    lazy private var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy private var backgroundImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "background")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy private var profileImageView: UIImageView = {
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
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.borderColor = UIColor.systemBrown.cgColor
        tableView.layer.borderWidth = 1
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        return tableView
    }()
    
    lazy private var reminderTitleView = ReminderTitleView()
    
    lazy private var setReminderButton: PrimaryButton = PrimaryButton(label: "Back Home")
    
    lazy private var shareButton: IconButton = IconButton(imageIcon: "square.and.arrow.up")
    
    lazy private var horizontalStack: UIStackView = {
        let horizontal = UIStackView()
        horizontal.axis = .horizontal
        horizontal.spacing = 10
        horizontal.distribution = .fillProportionally
        horizontal.alignment = .leading
        return horizontal
    }()
    
    private var headerCongratsView: HeaderCongratsView!
    
    private var hikingSummaryView: HikingSummaryView!
    
    private var selectedTime: String = "Set"
    
    private var selectedAlert: String = "None"
    
    private var imagePickerController: UIImagePickerController = UIImagePickerController()
    
    private var workoutManager: WorkoutServiceIos!
    var destinationDetail: DestinationModel!
    
    init(workoutManager: WorkoutServiceIos?) {
        super.init(nibName: nil, bundle: nil)
        
        self.workoutManager = workoutManager
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        navigationItem.hidesBackButton = true
        
        hikingSummaryView = HikingSummaryView(destinationDetail: destinationDetail, workoutManager: workoutManager)
        
        headerCongratsView = HeaderCongratsView(
            destinationTitle: "\(destinationDetail.name)",
            destinationTime: "1 Hour 25 Minutes"
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        
        reminderTitleView.isHidden = true
        tableView.isHidden = true
        setReminderButton.isEnabled = true
        shareButton.isHidden = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
        
        configureUI()
        
        setReminderButton.addTarget(self, action: #selector(setReminderTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
    }
    
    private func addSubViewsAll() {
        view.addSubview(headerCongratsView)
        view.addSubview(backgroundView)
        view.addSubview(hikingSummaryView)
        view.addSubview(reminderTitleView)
        view.addSubview(tableView)
        view.addSubview(horizontalStack)
        
        backgroundView.addSubview(profileImageView)
        backgroundView.addSubview(backgroundImageView)
        backgroundView.bringSubviewToFront(profileImageView)
        
        horizontalStack.addArrangedSubview(setReminderButton)
        horizontalStack.addArrangedSubview(shareButton)
    }
    
    func validateInputs() {
        let isTimeValid = selectedTime != "Set"
        let isAlertValid = selectedAlert != "None"
        
        // Jika kedua nilai valid, aktifkan tombol, jika tidak nonaktifkan
        setReminderButton.isEnabled = isTimeValid && isAlertValid
    }
    
    private func configureUI() {
        
        addSubViewsAll()
        
        headerCongratsView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-80)
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
        
        hikingSummaryView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom).offset(20)
            make.leading.equalTo(headerCongratsView.snp.leading)
            make.trailing.equalTo(headerCongratsView.snp.trailing)
            make.height.equalTo(115)
        }
        
        reminderTitleView.snp.makeConstraints { make in
            make.top.equalTo(hikingSummaryView.snp.bottom).offset(20)
            make.leading.equalTo(hikingSummaryView.snp.leading)
            make.trailing.equalTo(hikingSummaryView.snp.trailing)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(reminderTitleView.snp.bottom).offset(12)
            make.leading.equalTo(reminderTitleView.snp.leading)
            make.trailing.equalTo(reminderTitleView.snp.trailing)
            make.height.equalTo(120)
        }
        
        horizontalStack.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.leading.equalTo(tableView.snp.leading)
            make.trailing.equalTo(tableView.snp.trailing)
        }
        
        setReminderButton.snp.makeConstraints { make in
            make.height.equalTo(54)
        }
        
        shareButton.snp.makeConstraints { make in
            make.height.width.equalTo(54)
        }
    }
    
    @objc
    func setReminderTapped() {
//        // Dapatkan waktu pengingat dan waktu alert
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        if let reminderTime = formatter.date(from: selectedTime) {
//            
//            let alertIntervals: [String: TimeInterval] = [
//                "None": 0,
//                "At time of activity": 0,
//                "15 minutes before": 15 * 60,
//                "30 minutes before": 30 * 60
//            ]
//            
//            let alertInterval = alertIntervals[selectedAlert] ?? 0
//            
//            let notificationManager = NotificationManager()
//            notificationManager.createReminder(for: "Reminder", body: "Your hike is starting soon!", date: reminderTime, reminder: alertInterval)
//            
//            // Pindah ke root (HomeVC)
//            navigationController?.popToRootViewController(animated: true)
//        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc
    func shareTapped() {
        let congratsShareVC = CongratsSharableVC()
        congratsShareVC.selectedImage = backgroundImageView.image
        navigationController?.pushViewController(congratsShareVC, animated: true)
    }
    
    @objc func profileImageTapped() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Upload your Picture", message: "Let's documented your journey, choose a source picture", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}

extension CongratsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // UIImagePickerControllerDelegate method for image selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            backgroundImageView.image = editedImage
            shareButton.isEnabled = false // MARK: Kalau sudah selesai develop share, di true
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            shareButton.isEnabled = false
            backgroundImageView.image = originalImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension CongratsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomCell
        
        if indexPath.row == 0 {
            cell!.configure(iconName: "clock", title: "Time", buttonTitle: selectedTime, isBordered: true)
            cell!.actionButton.addTarget(self, action: #selector(presentTimePicker), for: .touchUpInside)
        } else if indexPath.row == 1 {
            cell!.configure(iconName: "bell", title: "Alert", buttonTitle: selectedAlert, isBordered: false)
            cell!.actionButton.addTarget(self, action: #selector(presentAlertPicker), for: .touchUpInside)
        }
        
        return cell!
    }
    
    @objc private func presentTimePicker() {
        let timePickerVC = UIAlertController(title: "Set Time", message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
        
        let pickerView = UIDatePicker()
        pickerView.datePickerMode = .time
        pickerView.preferredDatePickerStyle = .wheels
        pickerView.locale = Locale(identifier: "en_GB") // Format 24 hours
        timePickerVC.view.addSubview(pickerView)
        
        pickerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(timePickerVC.view.snp.top).offset(20)
        }
        
        let setAction = UIAlertAction(title: "Set", style: .default) { _ in
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            self.selectedTime = formatter.string(from: pickerView.date)
            self.tableView.reloadData()
            
            self.validateInputs()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        timePickerVC.addAction(setAction)
        timePickerVC.addAction(cancelAction)
        
        self.present(timePickerVC, animated: true, completion: nil)
    }
    
    @objc private func presentAlertPicker() {
        let alertPickerVC = UIAlertController(title: "Set Alert", message: nil, preferredStyle: .actionSheet)
        
        let options = ["None", "At time of activity", "15 minutes before", "30 minutes before"]
        
        for option in options {
            let action = UIAlertAction(title: option, style: .default) { _ in
                self.selectedAlert = option
                self.tableView.reloadData()
                self.validateInputs()
            }
            alertPickerVC.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertPickerVC.addAction(cancelAction)
        
        self.present(alertPickerVC, animated: true, completion: nil)
    }
}
