//
//  AlertMessage.swift
//  FourSquareReplica
//
//  Created by Stephanie Ramirez on 11/12/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import Foundation
import UIKit

class AlertMessage {
	func alertMessage(alertState: HomeViewModel.AlertState, style: UIAlertController.Style) -> UIAlertController { //move function out of home. This will be used across the app
		let alertController = UIAlertController(title: alertState.title, message: alertState.message, preferredStyle: style)
		switch alertState {
		case .locationAlert, .mapAlert:
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
			return alertController
		case .optionsAlert:
			//style is actionsheet
			let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
			alertController.addAction(cancelAction)
			return alertController
		}
	}
}
