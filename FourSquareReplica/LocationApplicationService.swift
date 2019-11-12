//
//  LocationApplicationService.swift
//  FourSquareReplica
//
//  Created by Stephanie Ramirez on 9/30/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import CoreLocation
import Foundation
import ReactiveSwift

//extension DefaultsKeys {
//	fileprivate static let savedUserLocation = DefaultsKey<CLLocation?>("savedUserLocation")
//}

final class LocationApplicationService: NSObject, ApplicationService {
	static let shared = LocationApplicationService()
	var status : CLAuthorizationStatus
	static var currentLocation: CLLocationCoordinate2D?//change to mutable property

	private lazy var clLocationManager = CLLocationManager()

	override private init() {
		LocationApplicationService.self.currentLocation = nil
		self.status = .notDetermined
		super.init()
		self.setupLocationManager()

	}

	private func setupLocationManager() {
		self.clLocationManager.delegate = self
	}
}
extension LocationApplicationService: CLLocationManagerDelegate {

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//		print("user has changed locations")
		guard let currentLocation = locations.last else {return}
		LocationApplicationService.self.currentLocation = currentLocation.coordinate
//		print("The user is in lat: \(currentLocation.coordinate.latitude) and long:\(currentLocation.coordinate.longitude)")
	}

	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//		print("user changed the authorization")
		self.status = status
		switch status {
		case .notDetermined, .restricted, .denied:
			LocationApplicationService.self.currentLocation = nil
			clLocationManager.requestWhenInUseAuthorization()
		case .authorizedAlways, .authorizedWhenInUse:
			clLocationManager.startUpdatingLocation()
			clLocationManager.desiredAccuracy = kCLLocationAccuracyBest
			LocationApplicationService.self.currentLocation = clLocationManager.location?.coordinate
		default:
			print("Unhandled case in locationManager didChangeAuthorization")
			clLocationManager.requestWhenInUseAuthorization()
		}
	}
}
