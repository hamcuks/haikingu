//
//  DestinationListVC.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 30/09/24.
//

import UIKit
import SnapKit
import Swinject

class DestinationListVC: UIViewController {
    
    private var destinationArray = DestinationList.allCases
    private var selectedPlan: DestinationList?
    var workoutManager: WorkoutServiceIos?
    
    private var selectButton: PrimaryButton = PrimaryButton(label: "Select Destination")
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HikingCell.self, forCellReuseIdentifier: "HikingCell")
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 20
        tableView.clipsToBounds = true
        return tableView
    }()
    
    var selectedDestination: DestinationModel?
    
    
    init(workoutManager: WorkoutServiceIos?) {
        super.init(nibName: nil, bundle: nil)
        
        self.workoutManager = workoutManager
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = 1
        
        tableView.isScrollEnabled = false
        
        selectButton.isEnabled = false
        selectButton.addTarget(self, action: #selector(actionButton), for: .touchDown)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalTo(selectButton.snp.top).inset(-100)
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
        workoutManager?.sendDestinationToWatch(destination: selectedDestination.name, elevmax: selectedDestination.maxElevation, elevmin: selectedDestination.minElevation)
        guard let destinationDetailVC = Container.shared.resolve(DetailDestinationVC.self) else { return }
        destinationDetailVC.selectedDestination = selectedDestination
        destinationDetailVC.selectedPlan = selectedPlan
        navigationController?.pushViewController(destinationDetailVC, animated: true)
    }

}

extension DestinationListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HikingCell", for: indexPath) as? HikingCell
        let destination = destinationArray[indexPath.row].destinationSelected
        
        // Reset state background for reuse cells
        cell?.backgroundColor = .white
        cell?.layer.cornerRadius = 20
        cell?.clipsToBounds = true
        
        cell?.configure(with: destination)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDestination = destinationArray[indexPath.row].destinationSelected
        selectButton.isEnabled = true
        selectedPlan = destinationArray[indexPath.row]
        
        let cell = tableView.cellForRow(at: indexPath) as? HikingCell
        
        // Set background color to indicate selection and make rounded edges
        cell?.backgroundColor = UIColor.systemGray5
        cell?.layer.cornerRadius = 20
        cell?.clipsToBounds = true
        
        print("Current destination: \(selectedDestination!.name)")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Reset the background color when cell is deselected
        let cell = tableView.cellForRow(at: indexPath) as? HikingCell
        cell?.backgroundColor = .white
    }
    
    // Atur tinggi cell jika diperlukan
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
}
