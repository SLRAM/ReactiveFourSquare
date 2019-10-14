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
//	var query = MutableProperty<String>("")
//	var near = MutableProperty<String>("")
	var authStatus = LocationApplicationService.shared.status
	var venueImage = MutableProperty<UIImage>(UIImage())


	func getVenues(near: String, query: String) {
		FourSquareAPI.searchFourSquare(userLocation: LocationApplicationService.shared.currentLocation ?? CLLocationCoordinate2D(latitude: 40.781594, longitude: -73.965816), near: near, query: query) { [weak self] (appError, venues) in
			if let appError = appError {
			print("getVenue - \(appError)")
		} else if let venues = venues {
			self?.venues.value = venues
			}
		}
	}

	func getImage(venue: Venues) {
		ImageAPIClient.getImages(venueID: venue.id) { (appError, imageInfo) in
			if let appError = appError {
				print(appError)
			}else if let imageInfo = imageInfo {
				ImageHelper.fetchImageFromNetwork(urlString: imageInfo, completion: { (appError, image) in
					if let appError = appError {
						print("imageHelper error - \(appError)")
					} else if let image = image {
						self.venueImage.value = image
					}
				})
			}
		}

	}



	func numberOfRowsInSection() -> Int {
		return venues.value.count
	}

}
