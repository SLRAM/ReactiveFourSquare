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
	var venues = MutableProperty<[Venue]>([])
	var annotations = MutableProperty<[MyAnnotation]>([])
	var region = MutableProperty<MKCoordinateRegion>(MKCoordinateRegion())
//when venues is set I want annotations to get set through the get annotations func
	init() {
//		self.reactive.makeBindingTarget { (this, state) in
//
//			} <~ self.venues.producer.map {_ in}
	}
	func getAnnotations() {
		var count = 0
		var annotations = [MyAnnotation]()

		for venue in self.venues.value {
//			let regionRadius: CLLocationDistance = 9000
			let coordinate = CLLocationCoordinate2D(latitude: venue.location.lat!, longitude: venue.location.lng!)
//			let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
			let annotation = MyAnnotation()
			annotation.coordinate = coordinate
			annotation.title = venue.name
			annotation.subtitle = venue.location.address
			annotation.tag = count
			count += 1
			annotations.append(annotation)

		}
		self.annotations.value = annotations
	}
	func setRegion() {
		let currentRegion = MKCoordinateRegion(center: self.venues.value[0].location.coordinate, latitudinalMeters: 9000, longitudinalMeters: 9000)
		self.region.value = currentRegion
	}
}
