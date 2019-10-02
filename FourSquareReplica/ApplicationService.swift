//
//  ApplicationService.swift
//  FourSquareReplica
//
//  Created by Stephanie Ramirez on 9/30/19.
//  Copyright © 2019 Stephanie Ramirez. All rights reserved.
//

import UIKit

protocol ApplicationService: UIApplicationDelegate {
}

extension ApplicationService {
	var window: UIWindow? {
		return UIApplication.shared.delegate?.window.flatMap { $0 } // Not sure why .window is a double-optional `??`?!
	}
}
