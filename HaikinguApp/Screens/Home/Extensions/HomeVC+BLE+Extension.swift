//
//  HomeVC+BLE+Extension.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 01/10/24.
//

import Foundation
import Swinject

extension HomeVC: PeripheralBLEManagerDelegate {
    func peripheralBLEManager(didUpdateEstTime time: TimeInterval) {
        self.hikingSessionDelegate?.didUpdateEstTime(time)
    }
    
    func peripheralBLEManager(didUpdateRestTaken restCount: Int) {
        self.hikingSessionDelegate?.didUpdateRestTaken(restCount)
    }
    
    func peripheralBLEManager(didUpdateDistance distance: Double) {
        self.hikingSessionDelegate?.didUpdateDistance(distance)
    }
    
    func peripheralBLEManager(didUpdateHikingState state: HikingStateEnum) {
        
        guard let viewController = Container.shared.resolve(HikingSessionVC.self) else {
            return print("Error occured")
        }
        
        self.hikingSessionDelegate = viewController
        
        if state == .started {
            guard let plan else {
                return
            }
            workoutManager?.retrieveRemoteSession()
            startHikingOnWatch()
            workoutManager?.sendStartToWatch()
            viewController.destinationDetail = plan.destinationSelected
            viewController.userRole = .member
            
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        self.hikingSessionDelegate?.didReceivedHikingState(state)
        
    }
    
    func peripheralBLEManagerDidReceiveInvitation(from invitor: Hiker, plan: String) {
        self.showInvitationSheet(from: invitor)
        
    }
    
    func peripheralBLEManager(didReceivePlanData plan: String) {
        print("receive plan id: ", plan)
        
        guard let viewController = Container.shared.resolve(DetailDestinationVC.self) else {
            return
        }
        
        self.plan = DestinationList(rawValue: plan)
        
        guard let plan = self.plan else { return }
        
        viewController.selectedDestination = plan.destinationSelected
        viewController.selectedPlan = plan
        viewController.role = .member
        workoutManager?.sendDestinationNameToWatch(destination: plan.destinationSelected.name)
        workoutManager?.sendDestinationElevMaxToWatch(elevMax: plan.destinationSelected.maxElevation)
        workoutManager?.sendDestinationElevMinToWatch(elevMin: plan.destinationSelected.minElevation)
        self.navigationController?.pushViewController(viewController, animated: true)
        print("ini roleeh: \(viewController.role)")
    }
    
    func peripheralBLEManager(didDisconnect hiker: Hiker) {
        self.navigationController?.popToRootViewController(animated: true)
        #warning("implement show alert when disconnected from leader")
    }
    
    func peripheralBLEManager(didReceiveRequestForRest type: TypeOfRestEnum) {
        self.notificationManager?.requestRest(for: type, name: nil)
    }
    
    func peripheralBLEManager(_ restType: TypeOfRestEnum, didReceive response: HaikinguRequestResponseEnum) {
        
    }
    
}
