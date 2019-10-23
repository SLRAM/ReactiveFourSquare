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
	let venue: Venues
	let imageAPIClient: ImageAPIClient
//	private let disposable = ScopedDisposable(TypedSerialDisposable<CompositeDisposable>())

//	this.disposable.inner.inner += ImageLoader.shared.loadImage(type: cellModel.info.imageType, in: this.backgroundImageView)

	func getImage() {
//		ImageAPIClient.wrappedFunction(imageAPIClient)
		ImageAPIClient.wrappedFunction().startWithResult { result in
			if let returnedString = result.value {
				print(returnedString)
			} else if let returnedError = result.error {
				print(returnedError)
			}
		}








//		ImageAPIClient.getImages(venueID: venue.id) { (appError, imageInfo) in
//			if let appError = appError {
//				print(appError)
//			}else if let imageInfo = imageInfo {
//				ImageHelper.fetchImageFromNetwork(urlString: imageInfo, completion: { (appError, image) in
//					if let appError = appError {
//						print("imageHelper error - \(appError)")
//					} else if let image = image {
//						self.venueImage.value = image
//					}
//				})
//			}
//		}

	}
}
