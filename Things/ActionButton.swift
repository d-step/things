//
//  ActionButton.swift
//  Things
//
//  Created by Derek on 12/21/16.
//  Copyright © 2016 Bonnected. All rights reserved.
//

import UIKit

class ActionButton: UIButton {

	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		let margin: CGFloat = 5.0
		
		let area = self.bounds.insetBy(dx: -margin, dy: -margin)
		
		return area.contains(point)
	}

}
