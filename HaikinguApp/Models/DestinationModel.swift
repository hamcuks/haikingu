////
////  DestinationModel.swift
////  HaikinguApp
////
////  Created by Bayu Septyan Nur Hidayat on 30/09/24.
////
//
//import Foundation
//import CoreLocation
//
//struct DestinationModel: Identifiable {
//    let id: UUID = UUID()
//    let name: String
//    let location: String
//    let locationPoint: CLLocationCoordinate2D
//    let trackLength: Int
//    let estimatedTime: TimeInterval
//    let minElevation: Int
//    let maxElevation: Int
//}
//
//enum DestinationList: CaseIterable {
//    case bintanBesarMountains
//    case jantanMountain
//    case BidadariLake
//    case BukitKadap
//    case DuriangkangEastTrail
//    case PongkarWaterfall
//    case SeiLadiForestTrack
//    case SenimbaHill
//    
//    var destinationAll : [DestinationModel] {
//        switch self {
//        case .bintanBesarMountains:
//            return DestinationModel(
//                name: "Bintan Besar Mountain",
//                location: "Batam, ID",
//                locationPoint: CLLocationCoordinate2D(
//                    latitude: <#T##CLLocationDegrees#>,
//                    longitude: <#T##CLLocationDegrees#>
//                ),
//                trackLength: 2100,
//                estimatedTime: <#T##TimeInterval#>,
//                minElevation: <#T##Int#>,
//                maxElevation: <#T##Int#>
//            )
//        case .jantanMountain:
//            <#code#>
//        case .BidadariLake:
//            <#code#>
//        case .BukitKadap:
//            <#code#>
//        case .DuriangkangEastTrail:
//            <#code#>
//        case .PongkarWaterfall:
//            <#code#>
//        case .SeiLadiForestTrack:
//            <#code#>
//        case .SenimbaHill:
//            <#code#>
//        }
//    }
//    
//}
