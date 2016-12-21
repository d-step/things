//
//  NoteDetailViewController.swift
//  Things
//
//  Created by Derek on 12/16/16.
//  Copyright © 2016 Bonnected. All rights reserved.
//

import UIKit
import MapKit

class NoteDetailViewController: UIViewController {
	
	var note: Note?
	
	@IBOutlet var scrollView: UIScrollView!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var messageLabel: UILabel!
	@IBOutlet var mapView: MKMapView!
	@IBOutlet var dateAddedLabel: UILabel!
	@IBOutlet var lastUpdatedLabel: UILabel!
	@IBOutlet var privateNoteLabel: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
	
	func setupView() {
		
		self.scrollView.layer.cornerRadius = 5
		
		guard let note = self.note else {
			return
		}
		
		print(note.dateAdded!)
		print(note.lastUpdated!)
		
		titleLabel.text = note.title
		messageLabel.text = note.text
		dateAddedLabel.text = note.dateAdded!.toString()
		lastUpdatedLabel.text = note.lastUpdated!.toString()
		privateNoteLabel.text = note.isPrivate ? "Yes" : "No"
		
		setupMap(note: note)
	}
	
	func setupMap(note: Note) {
		let latitude = CLLocationDegrees(note.latitude!)
		let longitude = CLLocationDegrees(note.longitude!)
		let location = CLLocation(latitude: latitude, longitude: longitude)
		let regionRadius:CLLocationDistance = 500
		
		let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
		
		mapView.setRegion(coordinateRegion, animated: true)
		mapView.isScrollEnabled = false
		mapView.delegate = self
		
		let annotation = ThingAnnotation(title: note.title!, description: note.text!, coordinate: location.coordinate)
		
		mapView.addAnnotation(annotation)
	}

	@IBAction func closeButtonPressed(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "editNoteSegue" {
			
			let editVC = segue.destination as! AddNoteViewController
			
			editVC.editMode = true
			editVC.delegate = self
			editVC.note = note
			
		}
		
	}

}

extension NoteDetailViewController: EditingDetailDelegate {
	
	func updateItem(data: Note) {
		
		titleLabel.text = data.title
		messageLabel.text = data.text
		privateNoteLabel.text = data.isPrivate ? "Yes" : "No"
		lastUpdatedLabel.text = "a few seconds ago"
		
	}
	
}

extension NoteDetailViewController: MKMapViewDelegate {
	
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
		return nil
	}
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
	             calloutAccessoryControlTapped control: UIControl) {
		let location = view.annotation as! ThingAnnotation
		let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
		openMap(fromAnnotation: location, withOptions: launchOptions)
	}
	
	func openMap(fromAnnotation annotation: ThingAnnotation, withOptions options: [String: String] ) {
		
		if Settings.getValue(forKey: Settings.linkToGoogleMapsKey), UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL) {
			
			let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees((note?.latitude)!), CLLocationDegrees((note?.longitude)!))
			let url = NSURL(string:
				"comgooglemaps://?saddr=&daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=driving")! as URL
			
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
			
		} else {
			
			annotation.mapItem().openInMaps(launchOptions: options)
			print("Can't use comgooglemaps://");
		}
		
		
	}
	
}
