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
//	private let venue: Venue
	
	let venueName: String
	let venueCategory: String?
	let venueDistance: String
	let venueDescription: String
	let venueDescriptionLineCount: Int
	
	init(venue: Venue) {
		self.venueName = venue.name
		self.venueCategory = venue.categories.first?.name
		self.venueDistance = "Distance in meters: \(venue.location.distance?.description ?? "")"
		var formattedVenueDescription = ""
		for str in venue.location.formattedAddress {
			formattedVenueDescription += str + "\n"
		}
		self.venueDescription = formattedVenueDescription
		self.venueDescriptionLineCount = venue.location.formattedAddress.count
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
