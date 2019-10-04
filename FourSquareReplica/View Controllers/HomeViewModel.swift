//
//  HomeViewModel.swift
//  FourSquareReplica
//
//  Created by Stephanie Ramirez on 9/27/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import Foundation
import ReactiveSwift
import CoreLocation
import MapKit

class HomeViewModel {
//	var homeView = HomeView() DO NOT REFER TO IN VIEW MODEL
	var venues = MutableProperty<[Venues]>([])
	var authStatus = LocationApplicationService.shared.status


	func getVenues(near: String, query: String) {
		FourSquareAPI.searchFourSquare(userLocation: LocationApplicationService.shared.currentLocation ?? CLLocationCoordinate2D(latitude: 40.781594, longitude: -73.965816), near: near, query: query) { [weak self] (appError, venues) in
			if let appError = appError {
			print("getVenue - \(appError)")
		} else if let venues = venues {
			self?.venues.value = venues
			}
		}
	}
}
