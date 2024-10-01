//
//  DetailDestinationVC.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 30/09/24.
//

import UIKit

class DetailDestinationVC: UIViewController {
    
    var destinationSelected: DestinationModel!
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
       let assets = UIImageView()
        assets.image = UIImage(named: "Bidadari")
        assets.contentMode = .scaleAspectFill
        assets.backgroundColor = .blue
        return assets
    }()
    
    private var selectButton: PrimaryButton = PrimaryButton(label: "Let’s Go!")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        teamView = TeamsView(action: #selector(teamAction))
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "Detail Hiking Spot"
        
        setupUI()

    }

    private func setupUI() {
        view.addSubview(titleDestination)
        view.addSubview(horizontalStack)
        view.addSubview(teamView)
        view.addSubview(assetPreview)
        view.addSubview(selectButton)
        view.bringSubviewToFront(selectButton)
        
        selectButton.addTarget(self, action: #selector(actionButton), for: .touchDown)
        assetPreview.addSubview(assetsImage)
        titleDestination.text = destinationSelected?.name ?? "Bidadari Lake"
        
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
        
        titleDestination.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().offset(20)
        }
        
        horizontalStack.snp.makeConstraints { make in
            make.top.equalTo(titleDestination.snp.bottom).offset(8)
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
