//
//  CoreExtensions.swift
//  Things
//
//  Created by Derek on 12/16/16.
//  Copyright © 2016 Bonnected. All rights reserved.
//

import Foundation
import UIKit

public extension NSDate {
	
	// MARK: To String
	
	/**
	A string representation using short date and time style.
	*/
	func toString() -> String {
		return self.toString(formatter: "MM/dd/yyyy")
	}
	
	/**
	A string representation using short date and time style.
	*/
	func toString(formatter:String) -> String {
		let date = self
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = formatter
		
		return dateFormatter.string(from: date as Date)
	}
	
}
