//
//  ThingItemTableViewCell.swift
//  Things
//
//  Created by Derek on 12/21/16.
//  Copyright © 2016 Bonnected. All rights reserved.
//

import UIKit

class ThingItemTableViewCell: UITableViewCell {
	
	override func layoutSubviews() {
		
		super.layoutSubviews()
		
		let hMargin: CGFloat = 5.0
		let vMargin: CGFloat = 15.0
		let imgWidth: CGFloat = 10.0
		
		self.imageView?.frame = CGRect(x: hMargin, y: vMargin, width: imgWidth + hMargin, height: self.frame.height - (2 * vMargin))
		self.imageView?.contentMode = .center
		
		if let defaultTextLabelFrame = textLabel?.frame {
			
			textLabel?.frame = CGRect(x: 25, y: defaultTextLabelFrame.origin.y, width: defaultTextLabelFrame.width, height: defaultTextLabelFrame.height)
			
		}
		
		if let defaultDetailLabelFrame = detailTextLabel?.frame {
			
			detailTextLabel?.frame = CGRect(x: 25, y: defaultDetailLabelFrame.origin.y, width: defaultDetailLabelFrame.width, height: defaultDetailLabelFrame.height)
			
		}
	}
	
}
