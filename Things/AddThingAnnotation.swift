//
//  AddThingAnnotation.swift
//  Things
//
//  Created by Derek on 12/21/16.
//  Copyright © 2016 Bonnected. All rights reserved.
//

import Foundation
import Contacts
import MapKit

class AddThingAnnotation: NSObject, MKAnnotation {
	
	let title: String?
	let coordinate: CLLocationCoordinate2D
 
	init(title: String, coordinate: CLLocationCoordinate2D) {
		self.title = title
		self.coordinate = coordinate
		
		super.init()
	}

}
