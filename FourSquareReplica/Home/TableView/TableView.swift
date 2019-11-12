//
//  TableView.swift
//  FourSquareReplica
//
//  Created by Stephanie Ramirez on 10/28/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit

class TableView: UITableView {

	override init(frame: CGRect, style: UITableView.Style) {
		super.init(frame: UIScreen.main.bounds, style: style)
		commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	private func commonInit() {
		setupView()
	}

}
extension TableView {
	func setupView() {
		register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
		rowHeight = (UIScreen.main.bounds.width)/2
		backgroundColor = .clear
	}
}
