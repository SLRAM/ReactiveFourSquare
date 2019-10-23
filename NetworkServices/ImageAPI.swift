//
//  ImageAPI.swift
//  FourSquareReplica
//
//  Created by Stephanie Ramirez on 2/18/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import Foundation
import ReactiveSwift

final class ImageAPIClient {
	func wrappedFunction() -> SignalProducer<String, AppError> {
		return SignalProducer {observer, disposable in
			func getImages(venueID: String, completionHandler: @escaping ((AppError?, String?) -> Void)) {
				let URL = "https://api.foursquare.com/v2/venues/\(venueID)/photos?client_id=\(SecretKeys.clientID)&client_secret=\(SecretKeys.clientSecret)&v=220180323&limit=1"
				print(URL)
				NetworkHelper.shared.performDataTask(endpointURLString: URL) { (appError, data) in
					if let error = appError {
//						completionHandler(error, nil)
						observer.send(error: error)
					}
					if let data = data {
						do {
							let imageLinkData = try JSONDecoder().decode(ImageModel.self, from: data)
							if let safeImage = imageLinkData.response.photos.items.first {
								let imageLink = safeImage.prefix + "300x500" + safeImage.suffix
//								completionHandler(nil, imageLink)
								observer.send(value: imageLink)
								observer.sendCompleted()
							}
						} catch {
							observer.send(error: AppError.jsonDecodingError(error))
//							completionHandler(AppError.jsonDecodingError(error), nil)
						}
					}
				}
			}

		}
	}
//    static func getImages(venueID: String, completionHandler: @escaping ((AppError?, String?) -> Void)) {
//        let URL = "https://api.foursquare.com/v2/venues/\(venueID)/photos?client_id=\(SecretKeys.clientID)&client_secret=\(SecretKeys.clientSecret)&v=220180323&limit=1"
//        print(URL)
//        NetworkHelper.shared.performDataTask(endpointURLString: URL) { (appError, data) in
//            if let error = appError {
//                completionHandler(error, nil)
//            }
//            if let data = data {
//                do {
//                    let imageLinkData = try JSONDecoder().decode(ImageModel.self, from: data)
//                    if let safeImage = imageLinkData.response.photos.items.first {
//                        let imageLink = safeImage.prefix + "300x500" + safeImage.suffix
//                        completionHandler(nil, imageLink)
//                    }
//                } catch {
//                    completionHandler(AppError.jsonDecodingError(error), nil)
//                }
//            }
//        }
//    }
}
