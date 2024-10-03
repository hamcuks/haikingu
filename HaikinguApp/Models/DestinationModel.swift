//  DestinationModel.swift
//  HaikinguApp
//
//  Created by Bayu Septyan Nur Hidayat on 30/09/24.

import Foundation
import CoreLocation

struct DestinationModel: Identifiable {
    let id: UUID = UUID()
    var name: String
    var image: String
    var location: String
    var locationPoint: CLLocation
    var trackLength: Int
    var estimatedTime: TimeInterval
    var minElevation: Int
    var maxElevation: Int
}

enum DestinationList: String, CaseIterable {
    case bintanBesarMountains
    case jantanMountain
    case bidadariLake
    case bukitKandap
    case duriangkangEastTrail
    case pongkarWaterfall
    case seiLadiForestTrack
    case senimbaHill
    
    var destinationSelected: DestinationModel {
        switch self {
        case .bintanBesarMountains:
            return DestinationModel(
                name: "Bintan Besar Mountain",
                image: "Bintan",
                location: "Batam, ID",
                locationPoint: CLLocation(
                    latitude: 1.06612,
                    longitude: 104.4515
                ),
                trackLength: 1377,
                estimatedTime: 0,
                minElevation: 25,
                maxElevation: 365
            )
        case .jantanMountain:
            return DestinationModel(
                name: "Jantan Mountain",
                image: "Jantan",
                location: "Batam, ID",
                locationPoint: CLLocation(
                    latitude: 1.08123,
                    longitude: 103.34281
                ),
                trackLength: 1701,
                estimatedTime: 0,
                minElevation: 12,
                maxElevation: 25
            )
        case .bidadariLake:
            return DestinationModel(
                name: "Bidadari Lake",
                image: "Bidadari",
                location: "Batam, ID",
                locationPoint: CLLocation(
                    latitude: 1.06809,
                    longitude: 104.01358
                ),
                trackLength: 30, //1268
                estimatedTime: 0,
                minElevation: 24,
                maxElevation: 92
            )
        case .bukitKandap:
            return DestinationModel(
                name: "Kandap Hill",
                image: "Kandap",
                location: "Batam, ID",
                locationPoint: CLLocation(
                    latitude: 0.69605,
                    longitude: 104.22691
                ),
                trackLength: 1219,
                estimatedTime: 0,
                minElevation: 29,
                maxElevation: 187
            )
        case .duriangkangEastTrail:
            return DestinationModel(
                name: "Duriangkang Lake (East Trail)",
                image: "Duriangkang",
                location: "Batam, ID",
                locationPoint: CLLocation(
                    latitude: 1.10062,
                    longitude: 104.09431
                ),
                trackLength: 5146,
                estimatedTime: 0,
                minElevation: 8,
                maxElevation: 42
            )
        case .pongkarWaterfall:
            return DestinationModel(
                name: "Pongkar Waterfall",
                image: "Pongkar",
                location: "Batam, ID",
                locationPoint: CLLocation(
                    latitude: 1.10306,
                    longitude: 103.36912
                ),
                trackLength: 529,
                estimatedTime: 0,
                minElevation: 11,
                maxElevation: 45
            )
        case .seiLadiForestTrack:
            return DestinationModel(
                name: "Sei Ladi Forest",
                image: "SeiLadi",
                location: "Batam, ID",
                locationPoint: CLLocation(
                    latitude: 1.10717,
                    longitude: 104.00128
                ),
                trackLength: 1660,
                estimatedTime: 0,
                minElevation: 24,
                maxElevation: 68
            )
        case .senimbaHill:
            return DestinationModel(
                name: "Senimba Hill",
                image: "Senimba",
                location: "Batam, ID",
                locationPoint: CLLocation(
                    latitude: 1.07633,
                    longitude: 103.96144
                ),
                trackLength: 591,
                estimatedTime: 0,
                minElevation: 24,
                maxElevation: 147
            )
        }
    }
    
}

