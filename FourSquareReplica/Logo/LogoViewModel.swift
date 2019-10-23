//
//  LogoViewModel.swift
//  FourSquareReplica
//
//  Created by Stephanie Ramirez on 10/23/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import Foundation
import ReactiveSwift
import CoreLocation
import MapKit

class LogoViewModel {
//	enum near {
//		case userLocation
//		case searchTerm
//		case empty
//	}

	func returnNear(locationStatus: CLAuthorizationStatus)-> String {

		switch locationStatus {
		case .notDetermined, .restricted, .denied:
			return ""
		case .authorizedAlways, .authorizedWhenInUse:
			return "near me"
		default:
			print("Unhandled case in returnNear location status")
			return ""
		}
	}
}
