//
//  MapViewModel.swift
//  FourSquareReplica
//
//  Created by Stephanie Ramirez on 10/31/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import CoreLocation
import MapKit

class MyAnnotation: MKPointAnnotation {
	var tag: Int!
}
class MapViewModel {
	let venues = MutableProperty<[Venue]>([])
	let annotations = MutableProperty<[MyAnnotation]>([])
	let region = MutableProperty<MKCoordinateRegion>(MKCoordinateRegion())
//when venues is set I want annotations to get set through the get annotations func
	init() {
	}
}
