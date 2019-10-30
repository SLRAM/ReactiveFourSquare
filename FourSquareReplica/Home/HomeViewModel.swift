//
//  HomeViewModel.swift
//  FourSquareReplica
//
//  Created by Stephanie Ramirez on 10/29/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import CoreLocation
import MapKit

class HomeViewModel {
	var state = MutableProperty(ViewState.listView)
	let searchBarViewModel: SearchBarViewModel
	let tableViewModel: TableViewModel
//	let mapViewModel: MapViewModel

	init(searchBarViewModel: SearchBarViewModel, tableViewModel: TableViewModel) {
		self.searchBarViewModel = searchBarViewModel
		self.tableViewModel = tableViewModel
		SignalProducer.combineLatest(
			searchBarViewModel.query,
			searchBarViewModel.near).startWithValues { [unowned self] query, near in //.throttle. adds a time interval
				self.getVenues(near: near, query: query)
		}
	}

	func getVenues(near: String, query: String) {
		FourSquareAPI.searchFourSquare(userLocation: LocationApplicationService.currentLocation ?? CLLocationCoordinate2D(latitude: 40.781594, longitude: -73.965816), near: near, query: query) { [weak self] (appError, venues) in
			if let appError = appError {
			print("getVenue - \(appError)")
		} else if let venues = venues {
				self?.tableViewModel.venues.value = venues
			}
		}
	}

	enum ViewState {
		case listView
		case mapView

		var toggleTitle: String {
			switch self {
			case .listView:
				return "Map"
			case .mapView:
				return "List"
			}
		}
	}
}
