//
//  SearchBarViewModel.swift
//  FourSquareReplica
//
//  Created by Stephanie Ramirez on 10/30/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import Foundation
import ReactiveSwift
import UIKit

struct SearchBarViewModel {
//	locationMarkerImageState
	let placeholder = "ex. Miami"
	let query: MutableProperty<String>
	var near: MutableProperty<String>
	var locationState: MutableProperty<LocationState>

	init(query: String, near: String, locationState: LocationState) {
		self.query = MutableProperty(query)
		self.near = MutableProperty(near)
		self.locationState = MutableProperty(locationState)
	}

	enum LocationState {
		case on
		case off//(String)

		var toggleImage: UIImage {
			switch self {
			case .on:
				return UIImage(named: "icons8-location_filled")!
			case .off://(let locationString):
//				nearString = locationString
				return UIImage(named: "icons8-marker")!
			}
		}
	}
}
