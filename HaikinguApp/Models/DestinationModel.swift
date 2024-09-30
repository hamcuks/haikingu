
//  DestinationModel.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 30/09/24.



//
//  DestinationModel.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 30/09/24.
//

import Foundation
import CoreLocation

struct DestinationModel: Identifiable {
    let id: UUID = UUID()
    let name: String
    let image: String
    let location: String
    let locationPoint: CLLocationCoordinate2D
    let trackLength: Int
    let estimatedTime: TimeInterval
    let minElevation: Int
    let maxElevation: Int
}

enum DestinationList: CaseIterable {
    case bintanBesarMountains
    case jantanMountain
    case BidadariLake
    case BukitKandap
    case DuriangkangEastTrail
    case PongkarWaterfall
    case SeiLadiForestTrack
    case SenimbaHill
    
    var destinationSelected : DestinationModel {
        switch self {
        case .bintanBesarMountains:
            return DestinationModel(
                name: "Bintan Besar Mountain",
                image: "Bintan",
                location: "Batam, ID",
                locationPoint: CLLocationCoordinate2D(
                    latitude: 1.06612,
                    longitude: 104.4515
                ),
                trackLength: 2100,
                estimatedTime: 0,
                minElevation: 25,
                maxElevation: 365
            )
        case .jantanMountain:
            return DestinationModel(
                name: "Jantan Mountain",
                image: "Jantan",
                location: "Batam, ID",
                locationPoint: CLLocationCoordinate2D(
                    latitude: 1.08123,
                    longitude: 103.34281
                ),
                trackLength: 3078,
                estimatedTime: 0,
                minElevation: 12,
                maxElevation: 25
            )
        case .BidadariLake:
            return DestinationModel(
                name: "Bidadari Lake",
                image: "Bidadari",
                location: "Batam, ID",
                locationPoint: CLLocationCoordinate2D(
                    latitude: 1.06809,
                    longitude: 104.01358
                ),
                trackLength: 5245,
                estimatedTime: 0,
                minElevation: 24,
                maxElevation: 92
            )
        case .BukitKandap:
            return DestinationModel(
                name: "Kandap Hill",
                image: "Kandap",
                location: "Batam, ID",
                locationPoint: CLLocationCoordinate2D(
                    latitude: 0.69605,
                    longitude: 104.22691
                ),
                trackLength: 6465,
                estimatedTime: 0,
                minElevation: 29,
                maxElevation: 187
            )
        case .DuriangkangEastTrail:
            return DestinationModel(
                name: "Duriangkang Lake (East Trail)",
                image: "Duriangkang",
                location: "Batam, ID",
                locationPoint: CLLocationCoordinate2D(
                    latitude: 1.10062,
                    longitude: 104.09431
                ),
                trackLength: 11611,
                estimatedTime: 0,
                minElevation: 8,
                maxElevation: 42
            )
        case .PongkarWaterfall:
            return DestinationModel(
                name: "Pongkar Waterfall",
                image: "Pongkar",
                location: "Batam, ID",
                locationPoint: CLLocationCoordinate2D(
                    latitude: 1.10306,
                    longitude: 103.36912
                ),
                trackLength: 12141,
                estimatedTime: 0,
                minElevation: 11,
                maxElevation: 45
            )
        case .SeiLadiForestTrack:
            return DestinationModel(
                name: "Sei Ladi Forest",
                image: "SeiLadi",
                location: "Batam, ID",
                locationPoint: CLLocationCoordinate2D(
                    latitude: 1.10717,
                    longitude: 104.00128
                ),
                trackLength: 13801,
                estimatedTime: 0,
                minElevation: 24,
                maxElevation: 68
            )
        case .SenimbaHill:
            return DestinationModel(
                name: "Senimba Hill",
                image: "Senimba",
                location: "Batam, ID",
                locationPoint: CLLocationCoordinate2D(
                    latitude: 1.07633,
                    longitude: 103.96144
                ),
                trackLength: 14392,
                estimatedTime: 0,
                minElevation: 24,
                maxElevation: 147
            )
        }
    }
    
}
