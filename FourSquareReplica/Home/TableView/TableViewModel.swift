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

class TableViewModel {
//	var homeView = HomeView() DO NOT REFER TO IN VIEW MODEL
	var venues = MutableProperty<[Venue]>([])
	
	var authStatus = LocationApplicationService.shared.status

	enum LocationState {
		case on
		case off(String)
	}

//	func getVenues(near: String, query: String) {
//		FourSquareAPI.searchFourSquare(userLocation: LocationApplicationService.currentLocation ?? CLLocationCoordinate2D(latitude: 40.781594, longitude: -73.965816), near: near, query: query) { [weak self] (appError, venues) in
//			if let appError = appError {
//			print("getVenue - \(appError)")
//		} else if let venues = venues {
//			self?.venues.value = venues
//			}
//		}
//	}

	func numberOfRowsInSection() -> Int {
		return self.venues.value.count
	}
	func venuesAtIndex(_ index: Int) -> TableViewCellModel {
		let venue = self.venues.value[index]
		return TableViewCellModel(venue: venue)
	}

}
