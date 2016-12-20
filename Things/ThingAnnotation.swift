//
//  ThingAnnotation.swift
//  Things
//
//  Created by Derek on 12/7/16.
//  Copyright © 2016 Bonnected. All rights reserved.
//

import Foundation
import MapKit
import Contacts

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
	
	var subtitle: String? {
		return descriptor
	}
	
	func mapItem() -> MKMapItem {
		let addressDictionary = [String(CNPostalAddressStreetKey): description]
		let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
		
		let mapItem = MKMapItem(placemark: placemark)
		mapItem.name = title
		
		return mapItem
	}
}
