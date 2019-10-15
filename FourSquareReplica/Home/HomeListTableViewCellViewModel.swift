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

class HomeListTableViewCellViewModel {
	var venueImage = MutableProperty<UIImage>(UIImage())

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
}
