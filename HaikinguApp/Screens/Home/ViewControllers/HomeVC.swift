//
//  HomeVC.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 30/09/24.
//

import UIKit
import SnapKit
import Swinject

class HomeVC: UIViewController {
    
    /// Managers
    var peripheralManager: PeripheralBLEService?
    var notificationManager: NotificationService?
    var userDefaultManager: UserDefaultService?
    var workoutManager: WorkoutServiceIos?
    
    /// Delegates
    var hikingSessionDelegate: HikingSessionVCDelegate?
    
    var plan: DestinationList?
    
    /// SubViews
    var headerView: HomeHeaderView = HomeHeaderView()
    lazy var hikingModeControlView: HikingModeControlView = {
        let control = HikingModeControlView(items: ["Solo", "Group"])
        control.selectedSegmentIndex = 0
        
        return control
    }()
    
    lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var contentStack: UIStackView = UIStackView()
    lazy var imageView: UIImageView = UIImageView()
    lazy var backToHomeMessageView: BackToHomeMessageView = BackToHomeMessageView()
    lazy var startButton: PrimaryButton = PrimaryButton(label: " Start\nHiking")
    var isSoloMode: Bool = true
    
    /// Constructors
    init(peripheralManager: PeripheralBLEService?, notificationManager: NotificationService?, userDefaultManager: UserDefaultService?, workoutManager: WorkoutServiceIos?) {
        super.init(nibName: nil, bundle: nil)
        
        self.peripheralManager = peripheralManager
        self.notificationManager = notificationManager
        self.userDefaultManager = userDefaultManager
        self.workoutManager = workoutManager
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startHikingOnWatch()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedAvatar))
        headerView.avatarView.addGestureRecognizer(tapGesture)
        
        self.configureVC()
        self.configureHeaderView()
        self.configureHikingModeControlView()
        self.configureContentStackView()
        self.peripheralManager?.setDelegate(self)
        self.configureButtonStartHiking()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let userData = userDefaultManager?.getUserData() {
            // Perbarui UI berdasarkan data user
            updateUserInterface(with: userData)
        }
        self.notificationManager?.requestPermission()
        view.bringSubviewToFront(headerView.avatarView)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headerView.avatarView.isUserInteractionEnabled = true
        let point = headerView.avatarView.center
        let viewAtPoint = view.hitTest(point, with: nil)

    }
    
    @objc
    func tappedAvatar() {
        guard let editProfileVC = Container.shared.resolve(EditProfileVC.self) else { return }
        navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    private func updateUserInterface(with user: User) {
        // Perbarui nama pada header view (misalnya jika ada label nama di header)
        
        // Perbarui gambar profil pada imageView
        if let imageData = Data(base64Encoded: user.image), let userImage = UIImage(data: imageData) {
            headerView.setUserName(user.name, userImage)
        } else {
            // Gambar default jika tidak ada gambar
            let defaultImage = UIImage(systemName: "person.circle")
            headerView.setUserName(user.name, defaultImage)
        }
    }
    
    /// Private Functions
    private func configureVC() {
        self.view.backgroundColor = .systemBackground
    }
    
    private func configureHeaderView() {
        view.addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(64)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func configureHikingModeControlView() {
        view.addSubview(hikingModeControlView)
        
        hikingModeControlView.addTarget(self, action: #selector(onHikingModeControlValueChanged), for: .valueChanged)
        
        hikingModeControlView.snp.makeConstraints { make in
            make.top.equalTo((headerView.snp.bottom)).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(46)
        }
    }
    
    private func configureContentStackView() {
        view.addSubview(contentStack)
        
        self.configureTipsLabel()
        contentStack.addArrangedSubview(tipsLabel)
        
        self.configureImageView()
        contentStack.addArrangedSubview(imageView)
        
        contentStack.spacing = 75
        contentStack.axis = .vertical
        
        contentStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(hikingModeControlView.snp.bottom).offset(16)
        }
    }
    
    private func configureTipsLabel() {
        tipsLabel.text = "Going solo? No worries! Enjoy your solo adventure with confidence. We track your progress, and send gentle reminders to rest and recharge along the way."
    }
    
    private func configureImageView() {
        // MARK: Ganti image dengan hasil dari onboarding
        imageView.image = UIImage(named: "solo")
        imageView.tintColor = .label
        imageView.backgroundColor = .secondarySystemBackground
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(264)
        }
    }
    
    private func configureButtonStartHiking() {
        view.addSubview(startButton)
        startButton.addTarget(self, action: #selector(actionStartHiking), for: .touchUpInside)
        startButton.configuration?.background.cornerRadius = 50
        startButton.configuration?.titleAlignment = .center
        startButton.titleLabel?.adjustsFontSizeToFitWidth = true
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc
    private func actionStartHiking() {
        guard let destinationList = Container.shared.resolve(DestinationListVC.self) else { return }
        destinationList.isSoloHiker = isSoloMode
        navigationController?.pushViewController(destinationList, animated: true)
    }
    
    @objc private func onHikingModeControlValueChanged(_ sender: HikingModeControlView) {
        if sender.selectedSegmentIndex == 0 {
            tipsLabel.text = "Going solo? No worries! Enjoy your solo adventure with confidence. We track your progress, and send gentle reminders to rest and recharge along the way."
            isSoloMode = true
            imageView.image = UIImage(named: "solo")
        } else {
            tipsLabel.text = "Hiking with friends? Great choice! Enjoy the journey together. We track your group’s progress and sends reminders to take rests and stay energized along the way."
            isSoloMode = false
            imageView.image = UIImage(named: "group")
        }
        
        print(sender.selectedSegmentIndex == 0 ? "Choosen: Solo" : "Choosen: Group")
    }
    
    func showInvitationSheet(from hiker: Hiker) {
        let viewController = HikingInvitationVC()
        viewController.hiker = hiker
        viewController.delegate = self
        
        let navVC = UINavigationController(rootViewController: viewController)
        navVC.sheetPresentationController?.detents = [.medium()]
        
        self.present(navVC, animated: true)
    }
    
    func startHikingOnWatch() {
        Task {
            do {
                try await workoutManager?.startWatchWorkout(workoutType: .hiking)
            } catch {
                print("gagal start watch workout")
            }
        }
    }
}
