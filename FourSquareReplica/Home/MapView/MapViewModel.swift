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
	}
	func getAnnotations() {
		var count = 0
		for venue in venues.value {

			print("venue number: \(count)")
			let coordinate = CLLocationCoordinate2D.init(latitude: venue.location.lat!, longitude: venue.location.lng!)

			let annotation = MyAnnotation()
			annotation.coordinate = coordinate
			annotation.title = venue.name
			annotation.subtitle = venue.location.address
			annotation.tag = count
			annotations.value.append(annotation)
//			mapView.addAnnotation(annotation)
			count += 1
		}
	}
	func removeAnnotations(mapView: MKMapView) {
		mapView.removeAnnotations(self.annotations.value)
		self.annotations = MutableProperty<[MyAnnotation]>([])
	}
	func setRegion(mapView: MKMapView) {
		if !venues.value.isEmpty {
			let currentRegion = MKCoordinateRegion(center: self.venues.value[0].location.coordinate, latitudinalMeters: 9000, longitudinalMeters: 9000)
			self.region.value = currentRegion
			mapView.setRegion(currentRegion, animated: true)
		}
	}
}
