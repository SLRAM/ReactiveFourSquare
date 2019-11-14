//
//  HomeView.swift
//  FourSquareReplica
//
//  Created by Stephanie Ramirez on 2/20/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit
import MapKit
import ReactiveSwift

class MapView: UIView {

	let viewModel = MutableProperty<MapViewModel?>(nil)


	lazy var mapView: MKMapView = {
		let view = MKMapView()
		view.mapType = MKMapType.standard
		view.isZoomEnabled = true
		view.isScrollEnabled = true
		view.center = self.center
		return view
		}()

	override init(frame: CGRect) {
		super.init(frame: UIScreen.main.bounds)
		commonInit()

	}
	override func layoutSubviews() {
		super.layoutSubviews()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	private func commonInit() {
//		setupGradient()
		setupHomeMapView()
		setupAnnotations()
	}
}
extension MapView {
//	func setupGradient() {
//		let gradient = CAGradientLayer()
//		gradient.frame = self.bounds
//		gradient.colors = [UIColor.magenta.cgColor,UIColor.red.cgColor,UIColor.purple.cgColor,UIColor.blue.cgColor]
//		self.layer.addSublayer(gradient)
//	}
	func setupAnnotations() {
		self.viewModel.producer.startWithValues { (model) in
			print(model)
		}
		self.reactive.makeBindingTarget { (this, _) in
			self.removeAnnotations()
			self.getAnnotations()
			self.mapView.addAnnotations(self.viewModel.value!.annotations.value)
			self.setRegion()
			} <~ self.viewModel.producer.skipNil().flatMap(.latest) { $0.venues.producer }

	}
	func setupHomeMapView() {
		addSubview(mapView)
		mapView.translatesAutoresizingMaskIntoConstraints = false
		mapView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
		mapView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
		mapView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
		mapView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor).isActive = true
	}

	func getAnnotations() {
		self.reactive.makeBindingTarget{ this, venues in
			var count = 0
			for venue in venues.value {
				let coordinate = CLLocationCoordinate2D.init(latitude: venue.location.lat!, longitude: venue.location.lng!)
				let annotation = MyAnnotation()
				annotation.coordinate = coordinate
				annotation.title = venue.name
				annotation.subtitle = venue.location.address
				annotation.tag = count
				self.viewModel.value?.annotations.value.append(annotation)
				count += 1
			}
		} <~ self.viewModel.producer.skipNil().map { $0.venues }
	}
	func removeAnnotations() {
		self.mapView.removeAnnotations(self.viewModel.value!.annotations.value)
		self.viewModel.value?.annotations.value = []
	}
	func setRegion() {
		if !self.viewModel.value!.venues.value.isEmpty {
			let currentRegion = MKCoordinateRegion(center: self.viewModel.value!.venues.value[0].location.coordinate, latitudinalMeters: 9000, longitudinalMeters: 9000)
			self.viewModel.value!.region.value = currentRegion
			self.mapView.setRegion(currentRegion, animated: true)
		}
	}
}
