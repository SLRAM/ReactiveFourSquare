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
	var homeView = HomeView()
	var updatedUserLocation = LocationApplicationService.shared.currentLocation
	var authStatus = LocationApplicationService.shared.status

	private var venues = [Venues]() {
		didSet {
			self.homeView.reloadInputViews()
			self.homeView.myTableView.reloadData()
			self.homeView.mapView.reloadInputViews()
//			self.setupAnnotations()

		}
	}

	private func getVenues(userLocation: CLLocationCoordinate2D, near: String, query: String) {
	   FourSquareAPI.searchFourSquare(userLocation: userLocation, near: near, query: query) { [weak self] (appError, venues) in
		   if let appError = appError {
			   print("getVenue - \(appError)")
		   } else if let venues = venues {
			   self?.venues = venues
		   }
	   }
   }
}
