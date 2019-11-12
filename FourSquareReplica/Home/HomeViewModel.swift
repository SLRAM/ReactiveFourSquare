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
	var alert = MutableProperty(AlertState.locationAlert)

	let searchBarViewModel: SearchBarViewModel
	let tableViewModel: TableViewModel
	let mapViewModel: MapViewModel

	init(searchBarViewModel: SearchBarViewModel, tableViewModel: TableViewModel, mapViewModel: MapViewModel) {
		self.searchBarViewModel = searchBarViewModel
		self.tableViewModel = tableViewModel
		self.mapViewModel = mapViewModel
		SignalProducer.combineLatest(
			searchBarViewModel.query,
			searchBarViewModel.near).startWithValues { [unowned self] query, near in //.throttle. adds a time interval
				self.getVenues(near: near, query: query)
		}
		self.searchBarViewModel.locationState.producer.filter { $0.self == .on}.startWithValues { state in
			self.searchBarViewModel.near.value = state.toggleNear.0
		}
	}

	func getVenues(near: String, query: String) {
		FourSquareAPI.searchFourSquare(userLocation: LocationApplicationService.currentLocation ?? CLLocationCoordinate2D(latitude: 40.781594, longitude: -73.965816), near: near, query: query) { [weak self] (appError, venues) in
			if let appError = appError {
			print("getVenue - \(appError)")
		} else if let venues = venues {
				self?.tableViewModel.venues.value = venues
				self?.mapViewModel.venues.value = venues
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
	enum AlertState {
		case locationAlert
		case mapAlert
		case optionsAlert

		var title: String? {
			switch self {
			case .locationAlert:
				return "Please allow this app access to your user location in settings to enable this feature."
			case .mapAlert:
				return "Please provide a search location or allow this app access to your location to see the map."
			case .optionsAlert:
				return nil
			}
		}
		var message: String? {
			switch self {
			case .locationAlert:
				return nil
			case .mapAlert:
				return nil
			case .optionsAlert:
				return "Options"
			}
		}
	}
}
