//
//  HomeView.swift
//  FourSquareReplica
//
//  Created by Stephanie Ramirez on 2/20/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit

class HomeView: UIView {
	lazy var myTableView: UITableView = {
		let tv = UITableView()
		tv.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
		tv.rowHeight = (UIScreen.main.bounds.width)/2
		tv.backgroundColor = .clear
		return tv
	}()

	override init(frame: CGRect) {
		super.init(frame: UIScreen.main.bounds)
		commonInit()
		
	}
	override func layoutSubviews() {
		super.layoutSubviews()
//        nearMeButton.layer.cornerRadius = nearMeButton.bounds.width / 2.0
//        nearMeButton.clipsToBounds = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	private func commonInit() {
		setupHomeListView()
	}
	
}
extension HomeView {
	func setupHomeListView() {
		addSubview(myTableView)
		myTableView.translatesAutoresizingMaskIntoConstraints = false
		//        myTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
		myTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
		myTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
		myTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
		myTableView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.92).isActive = true
	}
	func setupGradient() {
		let gradient = CAGradientLayer()
		gradient.frame = self.bounds
		gradient.colors = [UIColor.magenta.cgColor,UIColor.red.cgColor,UIColor.purple.cgColor,UIColor.blue.cgColor]
		self.layer.addSublayer(gradient)
	}
}
