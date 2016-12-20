//
//  ThingDetailView.swift
//  Things
//
//  Created by Derek on 12/16/16.
//  Copyright © 2016 Bonnected. All rights reserved.
//

import UIKit

class ThingDetailView: UIView {
	
	var contentView: UIView!

	required init(coder aDecoder: NSCoder) {
		
		super.init(coder: aDecoder)!
		
		xibSetup()
		
	}
	
	init() {
		super.init(frame: CGRect())
		
		xibSetup()
	}
	
	func xibSetup() {
		
		contentView = loadViewFromNib()
		
		contentView.frame = bounds
		contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		
		addSubview(contentView)
		
	}
	
	func loadViewFromNib() -> UIView {
		
		let bundle = Bundle(for: type(of: self))
		let nib = UINib(nibName: "ThingDetailView", bundle: bundle)
		let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
		
		return view
	}
	
}
