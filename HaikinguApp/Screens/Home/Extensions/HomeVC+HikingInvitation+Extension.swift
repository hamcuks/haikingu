//
//  HomeVC+HikingInvitation+Extension.swift
//  HaikinguApp
//
//  Created by Ivan Nur Ilham Syah on 30/09/24.
//

import Foundation

extension HomeVC: HikingInvitationDelegate {
    func didRespondToInvitation(with respond: HaikinguRequestResponseEnum) {
        print("Invitation: ", respond == .accepted ? "Accpeted" : "Rejected")
        
        self.peripheralManager?.respondToInvitation(for: respond)
        
    }
}
