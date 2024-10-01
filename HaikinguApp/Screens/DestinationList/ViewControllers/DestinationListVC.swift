//
//  DestinationListVC.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 30/09/24.
//

import UIKit

class DestinationListVC: UIViewController {
    
    private var destinationArray = DestinationList.allCases
    
    private var selectButton: PrimaryButton = PrimaryButton(label: "Select Destination")
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HikingCell.self, forCellReuseIdentifier: "HikingCell")
        tableView.separatorStyle = .none
        tableView.layer.borderColor = UIColor.red.cgColor
        tableView.layer.borderWidth = 1
        return tableView
    }()
    
    var selectedDestination: DestinationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.title = "Choose Hiking Spot"
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(selectButton)
        view.bringSubviewToFront(selectButton)
        
        selectButton.isEnabled = false
        selectButton.addTarget(self, action: #selector(actionButton), for: .touchDown)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalTo(selectButton.snp.top).inset(-50)
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
        guard let selectedDestination = selectedDestination else {
            selectButton.isEnabled = false
            return print("Selected Destination is Empty")
        }
        print("Select Destination is \(selectedDestination)")
        
    }
    
    private func presentDetailDestinationScreen() {
//        let destinationDetailScreen = DestinationDetailVC()
//        destinationView.modalPresentationStyle = .fullScreen
//        destinationView.routeCoordinate = routeCoordinate
        
//        if let sheet = destinationView.sheetPresentationController {
//            sheet.prefersGrabberVisible = true
//            sheet.detents = [.large()]
//            present(destinationView, animated: true)
//        }
        
    }
}

extension DestinationListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HikingCell", for: indexPath) as? HikingCell
        let destination = destinationArray[indexPath.row].destinationSelected
        cell?.configure(with: destination)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDestination = destinationArray[indexPath.row].destinationSelected
        selectButton.isEnabled = true
        print("Current destination: \(selectedDestination!.name)")
    }
    
    // Atur tinggi cell jika diperlukan
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58 
    }
    
}
