//
//  DetailDestinationVC.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 30/09/24.
//

import UIKit

class DetailDestinationVC: UIViewController {
    
    /// Managers
    var centralManager: CentralBLEService?
    
    /// Delegates
    internal var addFriendDelegate: AddFriendVCDelegate?
    
    var selectedDestination: DestinationModel!
    var teamView: TeamsView!
    var alertNotRange: AlertRangeView = AlertRangeView()
    var isInrangeLocation: Bool = false
    
    private var horizontalStack: UIStackView = {
        let horizontal = UIStackView()
        horizontal.axis = .horizontal
        horizontal.spacing = 4
        horizontal.distribution = .fillProportionally
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
    
    init(centralManager: CentralBLEService?) {
        super.init(nibName: nil, bundle: nil)
        
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
        
        view.backgroundColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = selectedDestination?.name
        
        setupUI()

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
        view.addSubview(horizontalStack)
        
        horizontalStack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        teamView = TeamsView(action: #selector(teamAction))
        view.addSubview(teamView)
        
        teamView.snp.makeConstraints { make in
            make.top.equalTo(horizontalStack.snp.bottom).offset(12)
            make.leading.trailing.equalTo(horizontalStack)
        }
        
        view.addSubview(assetsImage)
        assetsImage.snp.makeConstraints { make in
            make.top.equalTo(teamView.snp.bottom).offset(24)
            make.leading.trailing.equalTo(horizontalStack)
        }
        
        view.addSubview(selectButton)
        selectButton.addTarget(self, action: #selector(actionButton), for: .touchDown)

        selectButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
            make.leading.trailing.equalTo(horizontalStack)
            make.height.equalTo(50)
        }
    
    }
    
    @objc
    func actionButton() {
        
        if isInrangeLocation {
            // MARK: - Navigation into next screen
            
        } else {
            alertNotRange.showAlert(on: self)
        }
        print("Let's go button is tapped")
        
    }
    
    @objc
    func teamAction() {
        self.centralManager?.startScanning()
        
        showModalAddFriend()
        
    }
    
    func showModalAddFriend() {
        let addFriendVC = AddFriendVC()
        addFriendVC.manager = centralManager
        addFriendVC.modalPresentationStyle = .formSheet
        
        self.addFriendDelegate = addFriendVC
        
        if let sheet = addFriendVC.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.medium(), .large()]
            present(addFriendVC, animated: true)
        }
    }

}

import Swinject

#Preview(traits: .defaultLayout, body: {
    let vc = Container.shared.resolve(DetailDestinationVC.self)
    
    return vc ?? ViewController()
})
