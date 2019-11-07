//
//  LogoViewController.swift
//  FourSquareReplica
//
//  Created by Stephanie Ramirez on 2/20/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LogoViewController: UIViewController {
	private let logoView = LogoView()
	var userLocation = CLLocationCoordinate2D()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.addSubview(logoView)
		logoView.delegate = self
	}
}
extension LogoViewController: LogoViewDelegate {
	func searchTerms(query: String, near: String) {
        let homeViewController = HomeViewController()
		let tableViewModel = TableViewModel()
		let mapViewModel = MapViewModel()
		var locationState: SearchBarViewModel.LocationState
		switch tableViewModel.authStatus {
		case .authorizedAlways, .authorizedWhenInUse:
			locationState = .on
		default:
			locationState = .off
		}
		let searchBarViewModel = SearchBarViewModel(query: query, near: near, locationState: locationState)
		let homeViewModel = HomeViewModel(searchBarViewModel: searchBarViewModel, tableViewModel: tableViewModel, mapViewModel: mapViewModel)

		homeViewController.homeViewModel = homeViewModel
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
}

