//
//  RoundedButton.swift
//  Things
//
//  Created by Derek on 12/22/16.
//  Copyright © 2016 Bonnected. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
	
	@IBInspectable override var cornerRadius: CGFloat {
		
		didSet {
			layer.cornerRadius = cornerRadius
			layer.masksToBounds = cornerRadius > 0
		}
	}
	
	@IBInspectable var borderWidth: CGFloat = 0.0 {
		didSet {
			layer.borderWidth = borderWidth
		}
	}
	
	@IBInspectable var borderColor: UIColor? {
		didSet {
			layer.borderColor = borderColor?.cgColor
		}
		
	}

	/*init(frame: CGRect, title: String, color: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat) {
		
		super.init(frame: frame)
		
		setTitle(title, for: .normal)
		backgroundColor = color
		
		layer.cornerRadius = cornerRadius
		layer.borderWidth = borderWidth
		layer.borderColor = color.cgColor
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}*/
}
