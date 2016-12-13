//
//  ViewController.swift
//  Things
//
//  Created by Derek on 11/18/16.
//  Copyright © 2016 Bonnected. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITextFieldDelegate {
	
	@IBOutlet var mapView: MKMapView!
	@IBOutlet var buttonAdd: UIButton!
	@IBOutlet var buttonSave: UIButton!
	@IBOutlet var buttonCurrentLocation: UIButton!
	@IBOutlet var buttonView: UIView!
	@IBOutlet var searchField: UITextField!
	
	var locationManager = CLLocationManager()
	var currentLocation: CLLocation?
	var selectedLocation: CLLocation?
	let regionRadius: CLLocationDistance = 300

	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
		setupLocation()
		
	}
	
	private func setupViews() {
		
		// override weird auto-layout in view
		mapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
		
		buttonView.blur(style: .regular)
		
		let padding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: searchField.frame.height))
			
		searchField.borderStyle = .roundedRect
		searchField.leftView = padding
		searchField.leftViewMode = .always
		searchField.delegate = self
		
	}
	
	private func setupLocation() {
		if CLLocationManager.authorizationStatus() != .authorizedAlways {
			locationManager.requestAlwaysAuthorization()
			
		}
		
		if CLLocationManager.locationServicesEnabled() {
			mapView.showsUserLocation = true
			currentLocation = locationManager.location
			selectedLocation = currentLocation
		}
		
		if let location = selectedLocation {
			centerMapOnLocation(location: location)
		}
	}
	
	func centerMapOnLocation(location: CLLocation) {
  
		let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
  
		mapView.setRegion(coordinateRegion, animated: true)
	}
	
	@IBAction func buttonCurrentLocationPressed(_ sender: UIButton) {
		if CLLocationManager.locationServicesEnabled() {
			currentLocation = locationManager.location
			centerMapOnLocation(location: currentLocation!)
		}
	}
	
	@IBAction func buttonAddPress(_ sender: Any) {
		self.definesPresentationContext = true
	}
	
	@IBAction func buttonViewListPressed(_ sender: Any) {
		
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "addItemSegue" {
			
			let destination = segue.destination as! AddNoteViewController
			
			destination.location = selectedLocation
		}
		
	}
}

