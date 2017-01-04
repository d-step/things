//
//  ViewController.swift
//  Things
//
//  Created by Derek on 11/18/16.
//  Copyright © 2016 Bonnected. All rights reserved.
//

import UIKit
import MapKit
import AddressBookUI

class ViewController: UIViewController {
	
	@IBOutlet var mapView: MKMapView!
	@IBOutlet var buttonAdd: UIButton!
	@IBOutlet var buttonSettings: UIButton!
	@IBOutlet var buttonCurrentLocation: UIButton!
	@IBOutlet var buttonView: UIView!
	@IBOutlet var searchField: UITextField!
	
	var cancelSearchButton: UIButton?
	var searchBackground: UIView?
	var resultsTableView: UITableView?
	var isSearching: Bool = false
	
	var mapAnnotation: MKAnnotation?
	var droppedPin: AddThingAnnotation?
	
	var matchingItems: [MKMapItem] = []
	
	var trackCurrentLocation: Bool = true
	
	var searchWidth: CGFloat?
	var updatedSearchWidth: CGFloat?
	
	var locationManager = CLLocationManager()
	var currentLocation: CLLocation?
	var selectedLocation: CLLocation?
	var regionRadius: CLLocationDistance = 500
	var selectedFromSearch: Bool = false

	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
		setupLocation()
		setupMap()
		
	}
	
	override func viewDidLayoutSubviews() {
		setupActionBar()
	}
	
	func setupActionBar() {
		
		let frame = buttonView.frame
		
		let y = frame.origin.y
		let width = frame.width
		let height = frame.height
		var x = self.view.frame.width - width
		
		if Settings.getValue(forKey: Settings.leftHandModeKey) {
			x = 0
		}
		
		buttonView.frame = CGRect(x: x, y: y, width: width, height: height)

	}
	
	private func setupViews() {
		
		buttonView.blur(style: .regular)
		
		let padding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: searchField.frame.height))
			
		searchField.borderStyle = .roundedRect
		searchField.leftView = padding
		searchField.leftViewMode = .always
		searchField.delegate = self
		
		searchWidth = searchField.frame.width
		
		buttonSettings.imageView?.contentMode = .center
	}
	
	private func setupLocation() {
		
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestAlwaysAuthorization()
		locationManager.requestLocation()
		locationManager.startUpdatingLocation()
		
		if CLLocationManager.locationServicesEnabled() {
			mapView.showsUserLocation = true
			
			buttonCurrentLocation.setImage(#imageLiteral(resourceName: "location-filled"), for: .normal)
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
	
	func didTapEmptySearchBackground(_ sender: UITapGestureRecognizer) {
		
		if sender.state == .ended {
			
			selectedFromSearch = false
			
			removeSearchViews()
			
		}
		
	}
	
	@IBAction func buttonCurrentLocationPressed(_ sender: UIButton) {
		if CLLocationManager.locationServicesEnabled() {
			buttonCurrentLocation.setImage(#imageLiteral(resourceName: "location-filled"), for: .normal)
			
			currentLocation = locationManager.location
			
			locationManager.startUpdatingLocation()
			
			// reset the bool when requesting current location
			// this will begin tracking the current location again
			trackCurrentLocation = true
			
			centerMapOnLocation(location: currentLocation!)
		}
	}
	
	@IBAction func buttonAddPress(_ sender: Any) {
		self.definesPresentationContext = true
	}
	
	@IBAction func buttonViewListPressed(_ sender: Any) {
		
	}
	
	@IBAction func searchFieldTouch(_ sender: UITextField) {
		
		if !isSearching {
			isSearching = true
			selectedFromSearch = false
			
			// create search view
			createBackgroundView()
			createSearchView()
			createCancelButton()
		}
	}

	
	private func createCancelButton() {
		
		let frame = searchField.frame
		
		let x = frame.width - 60.0
		let y = frame.origin.y
		let height = frame.height
		let width: CGFloat = 65.0
		
		cancelSearchButton = UIButton(type: .system)
		cancelSearchButton?.frame = CGRect(x: x, y: y, width: width, height: height)
		cancelSearchButton?.setTitle("Cancel", for: .normal)
		cancelSearchButton?.titleLabel?.textAlignment = .right
		cancelSearchButton?.setTitleColor(UIColor.white, for: .normal)
		cancelSearchButton?.addTarget(self, action: #selector(self.cancelSearch(_:)), for: .touchUpInside)
		
		self.view.addSubview(cancelSearchButton!)
	}
	
	func cancelSearch(_ sender: UIButton) {
		removeSearchViews()
	}
	
	private func createBackgroundView() {
		
		self.searchBackground = UIView(frame: self.view.frame)
		
		self.searchBackground!.backgroundColor = #colorLiteral(red: 0.222715736, green: 0.222715736, blue: 0.222715736, alpha: 0.5906731592)
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapEmptySearchBackground(_:)))
		
		self.searchBackground?.addGestureRecognizer(tapGesture)
		
		self.view.addSubview(searchBackground!)
		self.view.bringSubview(toFront: searchField)
	}
	
	private func createSearchView() {
		
		let frame = CGRect(x: searchField.frame.origin.x, y: searchField.frame.origin.y + searchField.frame.height + 10, width: searchField.frame.width, height: 0)
		
		self.resultsTableView = UITableView(frame: frame)
		
		resultsTableView!.delegate = self
		resultsTableView!.dataSource = self
		resultsTableView!.layer.cornerRadius = 5
		resultsTableView!.layer.borderColor = #colorLiteral(red: 0.8850093353, green: 0.8937718039, blue: 0.8937718039, alpha: 1).cgColor
		resultsTableView!.layer.borderWidth = 0.85
		
		self.view.backgroundColor = .black
		self.view.addSubview(self.resultsTableView!)
		
	}
	
	func removeSearchViews() {
		
		isSearching = false
		
		self.searchBackground?.removeFromSuperview()
		self.resultsTableView?.removeFromSuperview()
		self.cancelSearchButton?.removeFromSuperview()
		
		self.searchBackground = nil
		self.resultsTableView = nil
		self.cancelSearchButton = nil
		
		// remove the text from the search field if an item was not selected
		// conversely, if an item was selected, keep the text in the field
		if !selectedFromSearch {
			self.searchField.text = ""
		}
		
		self.resignFirstResponder()
		self.view.endEditing(true)
		
	}
	
	@IBAction func textFieldChanged(_ sender: Any) {
		
		if let text = searchField.text, !text.isEmpty {
			// perform search
			searchNearby(searchTerm: text)
		}
		
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "addNoteSegue" {
			
			let destination = segue.destination as! AddNoteViewController
			
			destination.location = selectedLocation
		}
		
		if segue.identifier == "settingsSegue" {
			
			let destination = segue.destination as! SettingsViewController
			
			destination.delegate = self
			
		}
		
	}
}

extension ViewController: ActionBarDelegate {
	
	func updateActionBarFrame() {
		
		setupActionBar()
		
	}
	
}

extension ViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		
		searchField.frame = CGRect(x: searchField.frame.origin.x, y: searchField.frame.origin.y, width: searchWidth!, height: searchField.frame.height)
		
		return false
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		
		UIView.animate(withDuration: 0.3, animations: {
			self.searchField.frame = CGRect(x: self.searchField.frame.origin.x, y: self.searchField.frame.origin.y, width: self.searchField.frame.width - 70.0, height: self.searchField.frame.height)
		})
		
	}
	
}

extension ViewController: UIGestureRecognizerDelegate {
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
}

extension ViewController: MKMapViewDelegate {
	
	func setupMap() {
		
		// add pan gesture to detect when the map moves
		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap(_:)))
		panGesture.delegate = self
		
		let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.didLongPressMap(_:)))
		holdGesture.delegate = self
		
		// set frame
		mapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
		mapView.delegate = self
		mapView.addGestureRecognizer(panGesture)
		mapView.addGestureRecognizer(holdGesture)
		
		do {
			let notes = try Notes.getAll() as! [Note]
			
			var annotations: [ThingAnnotation] = []
			
			for note in notes {
				
				let annotationCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(note.latitude!), CLLocationDegrees(note.longitude!))
				
				let annotation = ThingAnnotation(title: note.title!, description: note.text!, coordinate: annotationCoordinate)
				
				annotations.append(annotation)
			}
			
			mapView.addAnnotations(annotations)
			
		} catch let error as NSError {
			print(error)
		}
		
	}
	
	func didDragMap(_ sender: UIGestureRecognizer) {
		if sender.state == .ended {
			
			// change current location image
			buttonCurrentLocation.setImage(#imageLiteral(resourceName: "location"), for: .normal)
			
			trackCurrentLocation = false
			locationManager.stopUpdatingLocation()
		}
	}
	
	func didLongPressMap(_ sender: UILongPressGestureRecognizer) {
		
		if sender.state == .began {
			
			let pressPoint = sender.location(in: mapView)
			let coordinate = mapView.convert(pressPoint, toCoordinateFrom: self.view)
			
			// remove the current dropped pin
			if let pin = droppedPin {
				
				mapView.removeAnnotation(pin)
				
			}
			
			// add annotation allowing user to add a note at that location
			droppedPin = AddThingAnnotation(title: "Add New Note Here", coordinate: coordinate)
			
			mapView.addAnnotation(droppedPin!)
			
		}
		
	}
	
	func searchNearby(searchTerm: String) {
		
		let request = MKLocalSearchRequest()
		
		request.naturalLanguageQuery = searchTerm
		request.region = mapView.region
		
		let search = MKLocalSearch(request: request)
		
		search.start(completionHandler: { response, _ in
			
			guard response != nil else {
				return
			}
			
			self.matchingItems = response!.mapItems
			self.resultsTableView?.reloadData()
			
			self.resetTableViewFrameForResults()
		})
		
	}
	
	private func resetTableViewFrameForResults() {
		
		guard let resultsTableView = self.resultsTableView else {
			return
		}
		
		let currentFrame = resultsTableView.frame
		
		let x = currentFrame.origin.x
		let y = currentFrame.origin.y
		let width = currentFrame.width
		
		// get height of main view
		let heightOfMainView = self.view.frame.height
		let bottomPadding: CGFloat = 20
		let maxHeightOfResultsView = heightOfMainView - bottomPadding - x
		
		let height = resultsTableView.contentSize.height > maxHeightOfResultsView ? maxHeightOfResultsView : resultsTableView.contentSize.height
		
		self.resultsTableView?.frame = CGRect(x: x, y: y, width: width, height: height)
	}
	
	// 1
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if let annotation = annotation as? ThingAnnotation {
			let identifier = "pin"
			var view: MKPinAnnotationView
			
			if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
				as? MKPinAnnotationView { // 2
				dequeuedView.annotation = annotation
				view = dequeuedView
			} else {
				// 3
				view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
				view.canShowCallout = true
				view.calloutOffset = CGPoint(x: -5, y: 5)
				view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
			}
			
			return view
		}
		
		if let annotation = annotation as? AddThingAnnotation {
			
			let identifier = "addedPin"
			var view: MKPinAnnotationView
			
			if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView { // 2
				dequeuedView.annotation = annotation
				view = dequeuedView
			} else {
				// 3
				view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
				view.canShowCallout = true
				view.rightCalloutAccessoryView = UIButton(type: .contactAdd) as UIView
			}
			
			return view
			
		}
		
		return nil
	}
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
	             calloutAccessoryControlTapped control: UIControl) {
		
		if let annotation = view.annotation as? ThingAnnotation {
		
			let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
		
			openMap(fromAnnotation: annotation, withOptions: launchOptions)
		}
		
		if let annotation = view.annotation as? AddThingAnnotation {
			
			// open add view
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let addEditController = storyboard.instantiateViewController(withIdentifier: "AddNoteViewController") as! AddNoteViewController
			
			addEditController.modalPresentationStyle = .overCurrentContext
			addEditController.location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
			
			self.present(addEditController, animated: true, completion: nil)
			
		}
	}
	
	func openMap(fromAnnotation annotation: ThingAnnotation, withOptions options: [String: String] ) {
		
		if Settings.getValue(forKey: Settings.linkToGoogleMapsKey), UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL) {
			
			let coordinate = selectedLocation?.coordinate
			let url = NSURL(string:
				"comgooglemaps://?center=\(coordinate?.latitude),\(coordinate?.longitude)")! as URL
			
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
			
		} else {
			
			annotation.mapItem().openInMaps(launchOptions: options)
			print("Can't use comgooglemaps://");
		}
	
		
	}
	
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return matchingItems.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
		
		let locationItem = matchingItems[indexPath.row].placemark
		
		cell.textLabel?.text = locationItem.name
		cell.detailTextLabel?.text = getAddressString(fromPlacemark: locationItem)
		
		cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
		cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 11, weight: UIFontWeightThin)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let selectedItem = matchingItems[indexPath.row].placemark
		
		self.selectedFromSearch = true
		self.regionRadius = 100
		
		centerMapOnLocation(location: selectedItem.location!)
		
		locationManager.stopUpdatingLocation()
		
		selectedLocation = selectedItem.location!
		searchField.text = selectedItem.name
		buttonCurrentLocation.setImage(#imageLiteral(resourceName: "location"), for: .normal)
		
		addAnnotation(fromPlacemark: selectedItem)
		removeSearchViews()
	}
	
	func addAnnotation(fromPlacemark: MKPlacemark) {
		
		if mapAnnotation != nil {
			mapView.removeAnnotation(mapAnnotation!)
		}
		
		mapAnnotation = ThingAnnotation(title: fromPlacemark.name!, description: getAddressString(fromPlacemark: fromPlacemark)!, coordinate: fromPlacemark.coordinate)
		
		mapView.addAnnotation(mapAnnotation!)
	}
	
	func getAddressString(fromPlacemark: MKPlacemark) -> String? {
		var originAddress : String?
		
		if let addrList = fromPlacemark.addressDictionary?["FormattedAddressLines"] as? [String]
		{
			originAddress =  addrList.joined(separator: ", ")
		}
		
		return originAddress
	}
	
}

extension ViewController : CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedAlways {
			locationManager.requestLocation()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		
		if trackCurrentLocation {
			centerMapOnLocation(location: locations.last!)
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("error:: \(error)")
	}
}

