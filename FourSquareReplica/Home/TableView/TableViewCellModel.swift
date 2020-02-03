//
//  TableViewCellViewModel.swift
//  FourSquareReplica
//
//  Created by Stephanie Ramirez on 10/15/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import Foundation
import ReactiveSwift
import CoreLocation
import MapKit

struct TableViewCellModel {
	var venueImage = MutableProperty<UIImage>(UIImage())
	let venue: Venue
	
	private(set) var venueName = ""
	private(set) var venueCategory = ""
	private(set) var venueDistance = ""
	private(set) var venueDescription = ""
	private(set) var venueDescriptionLineCount = 0
	
	init(venue: Venue) {
		self.venue = venue
		updateProperties()
	}
	private mutating func updateProperties() {
		self.venueCategory = self.getVenueCategory(venue: venue)
		self.venueName = venue.name
		self.venueDescription = self.getVenueDescription(venue: venue)
		self.venueDescriptionLineCount = venue.location.formattedAddress.count
		self.venueDistance = "Distance in meters: \(venue.location.distance?.description ?? "")"
	}

	func getImage() {
		ImageAPIClient.wrappedFunction().startWithResult { result in
				switch result {
				case .success(let returnedString):
					print(returnedString)
				case .failure(let returnedError):
					print(returnedError)

				}
			}
	}
}
extension TableViewCellModel {
	func getVenueCategory(venue: Venue) -> String {
		guard let venueCat = venue.categories.first?.name else {
			return "venue category not available"
		}
		return venueCat
	}

	func getVenueDescription(venue: Venue) -> String {
		var formattedVenueDescription = ""
		for str in venue.location.formattedAddress {
			formattedVenueDescription += str + "\n"
		}
		return formattedVenueDescription
	}
}
