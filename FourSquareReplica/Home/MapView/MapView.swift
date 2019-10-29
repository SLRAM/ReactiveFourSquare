//
//  HomeView.swift
//  FourSquareReplica
//
//  Created by Stephanie Ramirez on 2/20/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIView {

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
	}
}
extension MapView {
//	func setupGradient() {
//		let gradient = CAGradientLayer()
//		gradient.frame = self.bounds
//		gradient.colors = [UIColor.magenta.cgColor,UIColor.red.cgColor,UIColor.purple.cgColor,UIColor.blue.cgColor]
//		self.layer.addSublayer(gradient)
//	}
	func setupHomeMapView() {
		addSubview(mapView)
		mapView.translatesAutoresizingMaskIntoConstraints = false
		mapView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
		mapView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
		mapView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
		mapView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor).isActive = true
	}
}
