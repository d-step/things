//
//  ButtonView.swift
//  Things
//
//  Created by Derek on 12/13/16.
//  Copyright © 2016 Bonnected. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
	
	@IBInspectable var shadow: Bool {
		get {
			return layer.shadowOpacity > 0.0
		}
		set {
			if newValue {
				self.addShadow()
			}
		}
	}
	
	@IBInspectable var cornerRadius: CGFloat {
		get {
			return self.layer.cornerRadius
		}
		set {
			self.layer.cornerRadius = newValue
			
			if !shadow {
				self.layer.masksToBounds = true
			}
		}
	}
	
	func blur(style: UIBlurEffectStyle) {
		
		let effect = UIBlurEffect(style: style)
		let effectView = UIVisualEffectView(effect: effect)
		
		effectView.frame = self.bounds
		
		effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		
		self.insertSubview(effectView, at: 0)
		
	}
	
	func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
	               shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
	               shadowOpacity: Float = 0.4,
	               shadowRadius: CGFloat = 3.0) {
		layer.shadowColor = shadowColor
		layer.shadowOffset = shadowOffset
		layer.shadowOpacity = shadowOpacity
		layer.shadowRadius = shadowRadius
	}

}
