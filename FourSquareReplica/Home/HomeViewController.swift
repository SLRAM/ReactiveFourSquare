//
//  HomeViewController.swift
//  FourSquareReplica
//
//  Created by Stephanie Ramirez on 2/8/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation
import ReactiveCocoa
import ReactiveSwift

class HomeViewController: UIViewController {

//	private var homeView = HomeView()
	private var homeViewModel = HomeViewModel()

	private let mapKitView = MapView()
//	let mapViewModel = ?

	private let searchBarView = SearchBarView()
//	let searchBarModel = ?

	private let tableView = TableView()
	let tableViewModel = TableViewModel()


	public let identifer = "marker"


	var query: String! //better to put value in model***
	var near: String!
	var locationString = String()
	var statusRawValue = Int32()
	var userLocation : CLLocationCoordinate2D?
	var updatedUserLocation = CLLocationCoordinate2D()
	class MyAnnotation: MKPointAnnotation {
		var tag: Int!
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.mapListButton()
//		setupLocation()
	//        centerOnMap(location: initialLocation)


		self.tableView.reactive.reloadData <~ self.tableViewModel.venues.producer.map {_ in}
		self.searchBarView.queryTextField.text = self.query!
		self.searchBarView.locationTextField.text = self.near!
		let nearValue = Property(initial: near, then: self.searchBarView.locationTextField.reactive.textValues)
		let queryValue = Property(initial: query, then: self.searchBarView.queryTextField.reactive.textValues)
//the properties for binding are nav title, remove view, add view
		self.reactive.makeBindingTarget { (this, state) in
				self.navigationItem.rightBarButtonItem?.title = state.toggleTitle
				switch state {
				case .mapView:
					UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
						if self.tableView.isDescendant(of: self.view) {
							self.tableView.removeFromSuperview()
						}
						self.setupMapView()
					})
				case .listView:
					UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
						if self.mapKitView.isDescendant(of: self.view) {
							self.mapKitView.removeFromSuperview()
						}
						self.setupTableView()
					})
				}
			} <~ self.homeViewModel.state.producer

		self.reactive.makeBindingTarget { (this, searchTerms) in

			let (query, near) = searchTerms
			near == "near me" ? self.tableViewModel.getVenues(near: "", query: query!) : self.tableViewModel.getVenues(near: near!, query: query!)
//			self.tableViewModel.getVenues(near: near!, query: query!)
//			print("number of rows: \(self.tableViewModel.numberOfRowsInSection())")
			} <~ SignalProducer.combineLatest(
				queryValue,
				nearValue//combine with near
		)
		self.homeViewControllerSetup()

	   // setupAnnotations()
	}
//	func setupLocation() {
//
//		guard let userLocation = userLocation,
//			let query = query else {return}
//		switch userLocation.latitude {
//		case 0.0:
//			near = "NYC"
//			homeView.locationTextField.text = near
//			locationString = near
//			if !query.isEmpty {
//				//if user deny and no query = use near only
//				homeView.queryTextField.text = query
//			}
//			self.homeViewModel.getVenues(near: near, query: query)
//
//		default:
//			homeView.locationTextField.text = "near me"
//			homeView.locationTextField.isEnabled = false
//			homeView.nearMeButton.setImage(UIImage(named: "icons8-location_filled"), for: .normal)
//			let myCurrentRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 9000, longitudinalMeters: 9000)
//			homeView.mapView.setRegion(myCurrentRegion, animated: true)
//
//	//            homeView.nearMeButton.backgroundColor = #colorLiteral(red: 0.4481958747, green: 0.5343003273, blue: 0.7696674466, alpha: 1)
//			if !query.isEmpty {
//				//if user accept and no query = use user location only
//				homeView.queryTextField.text = query
//			}
//			self.homeViewModel.getVenues(near: "", query: query)
//		}
//	}
//	func setupAnnotations(){
//		var count = 0
//
//		self.homeView.mapView.removeAnnotations(self.homeView.mapView.annotations)
//		for venue in self.homeViewModel.venues.value {
//
//			print("venue number: \(count)")
//			let regionRadius: CLLocationDistance = 9000
//			let coordinate = CLLocationCoordinate2D.init(latitude: venue.location.lat!, longitude: venue.location.lng!)
//			let coordinateRegion = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
//	//            let annotation = MKPointAnnotation()
//			let annotation = MyAnnotation()
//			annotation.coordinate = coordinate
//			annotation.title = venue.name
//			annotation.subtitle = venue.location.address
//			annotation.tag = count
//
//			homeView.mapView.setRegion(coordinateRegion, animated: true)
//			homeView.mapView.addAnnotation(annotation)
//			count += 1
//
//		}
//		let myCurrentRegion = MKCoordinateRegion(center: self.homeViewModel.venues.value[0].location.coordinate, latitudinalMeters: 9000, longitudinalMeters: 9000)
//		homeView.mapView.setRegion(myCurrentRegion, animated: true)
//
//	}

	func mapListButton() {
		navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Map", style: .plain, target: self, action: #selector(toggle))
	}

	@objc func toggle() {
		print("pressed toggle")//edit toggle to account or adjust state
		switch tableViewModel.authStatus {
		case .notDetermined, .restricted, .denied:
			if (self.searchBarView.locationTextField.text?.isEmpty)! {
				let alertController = UIAlertController(title: "Please provide a search location or allow this app access to your location to see this feature.", message: nil, preferredStyle: .alert)
				let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
				let settingsAction = UIAlertAction(title: "Open Settings", style: .default, handler: { (action) -> Void in
					if let url = URL(string:UIApplication.openSettingsURLString) {
						if UIApplication.shared.canOpenURL(url) {
							UIApplication.shared.open(url, options: [:], completionHandler: nil)
						}
					}
				})
				alertController.addAction(okAction)
				alertController.addAction(settingsAction)
				present(alertController, animated: true)
			} else {
				if navigationItem.rightBarButtonItem?.title == "List" {
					navigationItem.rightBarButtonItem?.title = "Map"
				} else {
					navigationItem.rightBarButtonItem?.title = "List"
				}
				homeViewControllerSetup()
			}
		case .authorizedAlways, .authorizedWhenInUse:
			if navigationItem.rightBarButtonItem?.title == "List" {
				navigationItem.rightBarButtonItem?.title = "Map"
			} else {
				navigationItem.rightBarButtonItem?.title = "List"
			}
			homeViewControllerSetup()
		default:
			print("Unhandled case in locationManager for map/list toggle pressed")
		}
	}
	func homeViewControllerSetup() {
		setupSearchBarView()
		if navigationItem.rightBarButtonItem?.title == "Map" {//homevm should have a state on which to show: map or tableview
			UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
				if self.mapKitView.isDescendant(of: self.view) {
					self.mapKitView.removeFromSuperview()
				}
				self.setupTableView()
			})
		} else {
			UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {
				if self.tableView.isDescendant(of: self.view) {
					self.tableView.removeFromSuperview()
				}
				self.setupMapView()


			})

		}
	}
	func setupSearchBarView() {
		self.searchBarView.delegate = self
		self.searchBarView.locationTextField.delegate = self
		self.searchBarView.queryTextField.delegate = self
		self.view.addSubview(searchBarView)
		self.searchBarView.translatesAutoresizingMaskIntoConstraints = false
		self.searchBarView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
		self.searchBarView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
		self.searchBarView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
		self.searchBarView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.08).isActive = true
	}
	func setupTableView() {
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.view.addSubview(tableView)
		self.tableView.translatesAutoresizingMaskIntoConstraints = false
		self.tableView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.92).isActive = true
		self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
		self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
		self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
	}
	func setupMapView() {
		mapKitView.mapView.delegate = self
		self.view.addSubview(mapKitView)
		self.mapKitView.translatesAutoresizingMaskIntoConstraints = false
		self.mapKitView.topAnchor.constraint(equalTo: self.searchBarView.bottomAnchor).isActive = true
//		self.mapKitView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.92).isActive = true
		self.mapKitView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
		self.mapKitView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
		self.mapKitView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
	}

}
extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.tableViewModel.numberOfRowsInSection()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {return UITableViewCell()}
		
		let venueVM = self.tableViewModel.venuesAtIndex(indexPath.row)
		cell.model = venueVM
		cell.locationName.text = "\(indexPath.row + 1). \(venueVM.venueName)"
		cell.locationDistance.text = venueVM.venueDistance
		cell.locationDescription.numberOfLines = venueVM.venueDescriptionLineCount
		cell.locationDescription.text = venueVM.venueDescription
// images not returning***
		cell.cellImage.reactive.image <~ cell.model.venueImage
		cell.model.getImage() //triggers func which will update a venueImage value
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let selectedCell = self.tableView.cellForRow(at: indexPath) as? TableViewCell else {return}
		let venue = self.tableViewModel.venues.value[indexPath.row]
		let detailVC = HomeDetailViewController()
		detailVC.venue = venue
		detailVC.homeDetailView.detailImageView.image = selectedCell.cellImage.image
		//        detailVC
	//        UIView.animate(withDuration: 5.5, delay: 0.0, options: [], animations: {
	//        })
		navigationController?.pushViewController(detailVC, animated: true)
	}
	}
extension HomeViewController: MKMapViewDelegate{
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard annotation is MKPointAnnotation else { return nil }

		let identifier = "Annotation"
		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

		if annotationView == nil {
			annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
			annotationView?.rightCalloutAccessoryView = UIButton(type: .infoLight)
			annotationView!.canShowCallout = true
		} else {
			annotationView!.annotation = annotation
		}
		return annotationView
	}
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		guard let myViewAnnotation = view.annotation as? MyAnnotation else {
			return
		}

		let destinationVC = HomeDetailViewController()

		let venue = self.tableViewModel.venues.value[myViewAnnotation.tag]
		destinationVC.venue = venue
	//        destinationVC.homeDetailView.detailImageView.image = selectedCell.cellImage.image



		navigationController?.pushViewController(destinationVC, animated: true)
	}
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == self.searchBarView.queryTextField {
            print("query: \(String(describing: textField.text))")
            //guard for textfield stuff
            query = textField.text ?? ""
        }
		if textField == self.searchBarView.locationTextField {
            print("location: \(String(describing: textField.text))")
            locationString = textField.text ?? ""
        }
		if let userLocation = userLocation {
			self.tableViewModel.getVenues(near: locationString, query: query)
//           getVenues(userLocation: userLocation, near: locationString, query: query)
//            setupAnnotations()
        }
        
        textField.resignFirstResponder()
		mapKitView.mapView.reloadInputViews()
        return true
    }
}

extension HomeViewController: SearchBarViewDelegate {
	//this logic can go in vm
    func userLocationButton() {
		switch tableViewModel.authStatus {
		case .notDetermined, .restricted, .denied:
            let alertController = UIAlertController(title: "Please allow this app to access your user location in settings to enable this feature.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            let settingsAction = UIAlertAction(title: "Open Settings", style: .default, handler: { (action) -> Void in
                if let url = URL(string:UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            })
            alertController.addAction(okAction)
            alertController.addAction(settingsAction)
            present(alertController, animated: true)
		case .authorizedAlways, .authorizedWhenInUse:
			if searchBarView.nearMeButton.currentImage == UIImage(named: "icons8-marker") {
//            if homeView.nearMeButton.backgroundColor == #colorLiteral(red: 0.6193930507, green: 0.7189580798, blue: 0.9812330604, alpha: 1)  {
				searchBarView.nearMeButton.setImage(UIImage(named: "icons8-location_filled"), for: .normal)
//                homeView.nearMeButton.backgroundColor = #colorLiteral(red: 0.4481958747, green: 0.5343003273, blue: 0.7696674466, alpha: 1)
				print("highlighted")
				searchBarView.locationTextField.text = "near me"
				searchBarView.locationTextField.isEnabled = false

//				self.tableViewModel.getVenues(near: "", query: query)
//                getVenues(userLocation: updatedUserLocation, near: "", query: query)
			} else {
				searchBarView.nearMeButton.setImage(UIImage(named: "icons8-marker"), for: .normal)
//                homeView.nearMeButton.backgroundColor = #colorLiteral(red: 0.6193930507, green: 0.7189580798, blue: 0.9812330604, alpha: 1)
				searchBarView.locationTextField.isEnabled = true
				searchBarView.locationTextField.text = ""
				searchBarView.locationTextField.placeholder = "ex. Miami"
				print("not highlighted")
			}
		default:
			print("Unhandled case in locationManager after clicking userLocationButton")
		}
    }
}
