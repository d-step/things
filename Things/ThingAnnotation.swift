//
//  ThingAnnotation.swift
//  Things
//
//  Created by Derek on 12/7/16.
//  Copyright © 2016 Bonnected. All rights reserved.
//

import Foundation
import MapKit

class ThingAnnotation: NSObject, MKAnnotation {
	let title: String?
	let descriptor: String?
	let coordinate: CLLocationCoordinate2D
 
	init(title: String, description: String, coordinate: CLLocationCoordinate2D) {
		self.title = title
		self.descriptor = description
		self.coordinate = coordinate
		
		super.init()
	}
}
