//
//  SearchBarView.swift
//  FourSquareReplica
//
//  Created by Stephanie Ramirez on 2/19/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

protocol SearchBarViewDelegate: AnyObject {
    func userLocationButton()
}

class SearchBarView: UIView {
    
    weak var delegate: SearchBarViewDelegate?
	var viewModel: SearchBarViewModel!

    lazy var queryTextField: UITextField = {
			let textField = UITextField()
			textField.placeholder = "Search FourSquares"
			textField.textColor = .black
			textField.layer.cornerRadius = 10
			textField.layer.borderWidth = 2
			textField.layer.borderColor = UIColor.gray.cgColor
			textField.backgroundColor = #colorLiteral(red: 0.6924440265, green: 0.6956507564, blue: 0.7034814358, alpha: 1)
			textField.textAlignment = .center
			return textField
		}()
    
    lazy var nearMeButton:UIButton = {
			let button = UIButton()
			button.setBackgroundImage(UIImage(named: "icons8-marker"), for: .normal)
			button.addTarget(self, action: #selector(nearMeButtonPressed), for: .touchUpInside)
			button.clipsToBounds = true
			return button
		}()
	@objc func nearMeButtonPressed() {
		print("near me pressed")
		delegate?.userLocationButton()

	}
	lazy var locationTextField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "ex. Miami"
		textField.textColor = .black
		textField.layer.cornerRadius = 10
		textField.layer.borderWidth = 2
		textField.layer.borderColor = UIColor.gray.cgColor
		textField.backgroundColor = #colorLiteral(red: 0.6924440265, green: 0.6956507564, blue: 0.7034814358, alpha: 1)
		textField.textAlignment = .center

		return textField
	}()

	override init(frame: CGRect) {
		super.init(frame: UIScreen.main.bounds)
		commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	private func commonInit() {
		//these should be moved to a point in the code after the viewModel exists
		self.viewModel.near <~ self.locationTextField.reactive.textValues //nil
		self.viewModel.query <~ self.queryTextField.reactive.textValues //nil
		setupView()
		setupSubViews()
	}

}
extension SearchBarView {
	func setupView() {
		backgroundColor = #colorLiteral(red: 0.2660466433, green: 0.2644712925, blue: 0.2672616839, alpha: 1)
	}
	func setupSubViews() {
		setupQueryTextField()
		setupLocationTextField()
		setupNearMeButton()
	}
	func setupQueryTextField() {
		addSubview(queryTextField)
		queryTextField.translatesAutoresizingMaskIntoConstraints = false
		queryTextField.topAnchor.constraint(equalTo: topAnchor).isActive = true
		queryTextField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		queryTextField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		queryTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true
	}
	func setupLocationTextField() {
		addSubview(locationTextField)
		locationTextField.translatesAutoresizingMaskIntoConstraints = false
		locationTextField.topAnchor.constraint(equalTo: topAnchor).isActive = true
		locationTextField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		locationTextField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		locationTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true
	}
	func setupNearMeButton() {
		addSubview(nearMeButton)
		nearMeButton.translatesAutoresizingMaskIntoConstraints = false
		nearMeButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		nearMeButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
	}
}
