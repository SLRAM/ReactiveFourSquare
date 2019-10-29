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
    //need to get user location on this controller and segue its initial value to homeviewcontroller

//    let locationManager = CLLocationManager()

    private let logoView = LogoView()
    var userLocation = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoView)
        logoView.delegate = self
//        locationManager.delegate = self
//        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
//            //we need to say how accurate the data should be
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.startUpdatingLocation()
//        } else {
//            locationManager.requestWhenInUseAuthorization()
//        }
    }

}
extension LogoViewController: LogoViewDelegate {
	func searchTerms(query: String, near: String) {
        let detailVC = HomeViewController()
        detailVC.query = query
		detailVC.near = near
        detailVC.userLocation = userLocation
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

