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
	var homeViewModel: HomeViewModel!

	private let mapView = MapView()
	private let tableView = TableView()
	private let searchBarView = SearchBarView()

	class MyAnnotation: MKPointAnnotation {
		var tag: Int!
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.searchBarView.viewModel.value = homeViewModel.searchBarViewModel //displays inputs from logo add to homeviewmodel
		self.mapView.viewModel.value = homeViewModel.mapViewModel
		self.mapListButton()
		self.homeViewControllerSetup()
		self.homeViewModel.alertSignal.output.observeValues { [weak self] alert in
			self?.present(alert, animated: true)
		}
	}
	func mapListButton() {
		navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Map", style: .plain, target: self, action: #selector(toggleLocation))
	}

	@objc func toggleLocation() {
		self.homeViewModel.toggleLocation()
	}
	func homeViewControllerSetup() {
		setupSearchBarView()
		displayTableViewOrMapView()
	}
	func setupSearchBarView() {
		self.searchBarView.delegate = self
		self.searchBarView.locationTextField.delegate = self
		self.searchBarView.queryTextField.delegate = self
		self.adjustSearch()
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
		mapView.mapView.delegate = self
		self.view.addSubview(mapView)
		self.mapView.translatesAutoresizingMaskIntoConstraints = false
		self.mapView.topAnchor.constraint(equalTo: self.searchBarView.bottomAnchor).isActive = true
		self.mapView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
		self.mapView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
		self.mapView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
	}
	func displayTableViewOrMapView() {
		self.tableView.reactive.reloadData <~ self.homeViewModel.tableViewModel.venues.producer.map {_ in} //move to table view
		self.reactive.makeBindingTarget { (this, state) in
				self.navigationItem.rightBarButtonItem?.title = state.toggleTitle
				switch state {
				case .mapView:
					if self.tableView.isDescendant(of: self.view) {
						self.tableView.removeFromSuperview()
					}
					self.setupMapView()
				case .listView:
					if self.mapView.isDescendant(of: self.view) {
						self.mapView.removeFromSuperview()
					}
					self.setupTableView()
				}
			} <~ self.homeViewModel.state.producer
	}
	func adjustSearch() {
		self.searchBarView.locationTextField.reactive.makeBindingTarget { (this, state) in
			this.text = state.toggleNear.0
			this.placeholder = state.toggleNear.1
			this.isEnabled = state.toggleNear.2
		} <~ self.homeViewModel.searchBarViewModel.locationState// move to search bar view
	}
}
extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.homeViewModel.tableViewModel.numberOfRowsInSection()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {return UITableViewCell()}
		
		let venueVM = self.homeViewModel.tableViewModel.venuesAtIndex(indexPath.row)
		cell.model = venueVM
		cell.locationName.text = "\(indexPath.row + 1). \(venueVM.venueName)"
		cell.locationDistance.text = venueVM.venueDistance
		cell.locationDescription.numberOfLines = venueVM.venueDescriptionLineCount
		cell.locationDescription.text = venueVM.venueDescription
// images not returning ***
		cell.cellImage.reactive.image <~ cell.model.venueImage
		cell.model.getImage() //triggers func which will update a venueImage value

		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let selectedCell = self.tableView.cellForRow(at: indexPath) as? TableViewCell else {return}
		let venue = self.homeViewModel.tableViewModel.venues.value[indexPath.row]
		let detailVC = HomeDetailViewController()
		detailVC.venue = venue
		detailVC.homeDetailView.detailImageView.image = selectedCell.cellImage.image
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
		let venue = self.homeViewModel.tableViewModel.venues.value[myViewAnnotation.tag]
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
		textField.resignFirstResponder()
		mapView.mapView.reloadInputViews()
		return true
	}
}

extension HomeViewController: SearchBarViewDelegate {
	//this logic can go in vm
	func userLocationButton() {
		if self.homeViewModel.searchBarViewModel.locationState.value == .on {
			self.homeViewModel.searchBarViewModel.locationState.value = .off
		} else {
			self.homeViewModel.searchBarViewModel.locationState.value = .on
		}
	}
}

extension Reactive where Base: MKMapView {
	var reloadInputViews: BindingTarget<Void> {
		return self.makeBindingTarget { mapView, _ in
			return mapView.reloadInputViews()
		}
	}
}
