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

class TableViewModel {
//	var homeView = HomeView() DO NOT REFER TO IN VIEW MODEL
	var venues = MutableProperty<[Venue]>([])
	
	var authStatus = LocationApplicationService.shared.status

	enum LocationState {
		case on
		case off(String)
	}
	func numberOfRowsInSection() -> Int {
		return self.venues.value.count
	}
	func venuesAtIndex(_ index: Int) -> TableViewCellModel {
		let venue = self.venues.value[index]
		return TableViewCellModel(venue: venue)
	}
}
