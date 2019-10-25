//
//  HomeListTableViewCellViewModel.swift
//  FourSquareReplica
//
//  Created by Stephanie Ramirez on 10/15/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import Foundation
import ReactiveSwift
import CoreLocation
import MapKit

struct HomeListTableViewCellModel {
	var venueImage = MutableProperty<UIImage>(UIImage())
	private let venue: Venue
	
	var venueName: String {
		return self.venue.name
	}
	var venueCategory: String? {
		return self.venue.categories.first?.name
	}
	var venueDistance: String {
		return "Distance in meters: \(self.venue.location.distance?.description ?? "")"
	}
	var venueDescription: String {
		var formattedVenueDescription = ""
		for str in self.venue.location.formattedAddress {
			formattedVenueDescription += str + "\n"
		}
		return formattedVenueDescription
	}
	var venueDescriptionLineCount: Int {
		return self.venue.location.formattedAddress.count
	}
	
	init(venue: Venue) {
		self.venue = venue
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
	
//	ImageHelper.fetchImageFromNetwork(urlString: imageInfo, completion: { (appError, image) in
//		if let appError = appError {
//			print("imageHelper error - \(appError)")
//		} else if let image = image {
//			cell.cellImage.image = image
//		}
//	})
}
