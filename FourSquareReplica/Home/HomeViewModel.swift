//
//  HomeViewModel.swift
//  FourSquareReplica
//
//  Created by Stephanie Ramirez on 10/29/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import Foundation
import ReactiveSwift
import CoreLocation
import MapKit

class HomeViewModel {
	var state = MutableProperty(ViewState.listView)


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
}
