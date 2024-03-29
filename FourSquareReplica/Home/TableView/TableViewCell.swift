//
//  TableViewCell.swift
//  FourSquareReplica
//
//  Created by Stephanie Ramirez on 2/8/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class TableViewCell: UITableViewCell {
	var model: TableViewCellModel!

	public lazy var cellImage: UIImageView = {
		let iv = UIImageView(image: UIImage(named: "Placeholder"))
		return iv
	}()

	lazy var locationName: UILabel = {
		let label = UILabel()
		label.textColor = .white
//        label.backgroundColor = #colorLiteral(red: 0.8485524058, green: 0.2901501656, blue: 0.2927404642, alpha: 1)
		label.text = "Location Name"
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		label.font = UIFont(name: "AvenirNext-Bold", size: 18)
		return label
	}()
	lazy var locationCategory: UILabel = {
		let label = UILabel()
		label.textColor = .white
//        label.backgroundColor = #colorLiteral(red: 0.8265092969, green: 0.4387800694, blue: 0.6773107052, alpha: 1)
		label.font = UIFont(name: "Avenir Next", size: 16)

		label.text = "Location Category"
		return label
	}()
	lazy var locationDistance: UILabel = {
		let label = UILabel()
		label.textColor = .white
//        label.backgroundColor = #colorLiteral(red: 0.5483704209, green: 0.3197382689, blue: 1, alpha: 1)
		label.font = UIFont(name: "Avenir Next", size: 16)

		label.text = "Location Distance"
		return label
	}()
	lazy var locationDescription: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.text = "Location Description"
		label.lineBreakMode = .byWordWrapping
		label.numberOfLines = 0
		label.textAlignment = .center
		label.font = UIFont(name: "Avenir Next", size: 16)
		return label
	}()

	override func awakeFromNib() {
		super.awakeFromNib()
//whenever new uiimage, uiimageview updates it's image
	}
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		backgroundColor = .red
		selectionStyle = .none
		setConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}



	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		//func sets selected cell for action ***

	}

}
extension TableViewCell {
	func setConstraints() {
		setImage()
		setNameLabel()
		setCategoryLabel()
		setDistanceLabel()
		setDescriptionLabel()

	}
	func setImage() {
		self.addSubview(cellImage)
		cellImage.translatesAutoresizingMaskIntoConstraints = false
		cellImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.22).isActive = true
		cellImage.heightAnchor.constraint(equalTo: cellImage.widthAnchor, multiplier: 1.0).isActive = true
		cellImage.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
		cellImage.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
	}
	func setNameLabel() {
		self.addSubview(locationName)
		locationName.translatesAutoresizingMaskIntoConstraints = false
//        locationName.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75).isActive = true
//        locationName.heightAnchor.constraint(equalTo: cellImage.heightAnchor, multiplier: 0.36).isActive = true
		locationName.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
//        locationName.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		locationName.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 15).isActive = true
		locationName.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
	}
	func setCategoryLabel() {
		self.addSubview(locationCategory)
		locationCategory.translatesAutoresizingMaskIntoConstraints = false
		locationCategory.heightAnchor.constraint(equalTo: cellImage.heightAnchor, multiplier: 0.32).isActive = true
		locationCategory.topAnchor.constraint(equalTo: locationName.bottomAnchor).isActive = true
		//        locationName.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		locationCategory.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 15).isActive = true
		locationCategory.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
	}
	func setDistanceLabel() {//adjust cell so that this label and description do not overlap with long name labels
		self.addSubview(locationDistance)
		locationDistance.translatesAutoresizingMaskIntoConstraints = false
		locationDistance.heightAnchor.constraint(equalTo: cellImage.heightAnchor, multiplier: 0.32).isActive = true
		locationDistance.topAnchor.constraint(equalTo: locationCategory.bottomAnchor).isActive = true
		//        locationName.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		locationDistance.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 15).isActive = true
		locationDistance.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
	}

	func setDescriptionLabel() {
		self.addSubview(locationDescription)
		locationDescription.translatesAutoresizingMaskIntoConstraints = false
		locationDescription.topAnchor.constraint(equalTo: cellImage.bottomAnchor).isActive = true
		locationDescription.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		locationDescription.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		locationDescription.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
	}



}
