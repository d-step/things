//
//  NotesViewController.swift
//  Things
//
//  Created by Derek on 11/20/16.
//  Copyright © 2016 Bonnected. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
	
	@IBOutlet var notesTableView: UITableView!
	@IBOutlet var addButton: UIButton!
	
	var detailView: UIView!
	var notes = [NSManagedObject]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		notesTableView.dataSource = self
		notesTableView.delegate = self
	}
	
	override func viewDidAppear(_ animated: Bool) {
		//1
		let appDelegate =
			UIApplication.shared.delegate as! AppDelegate
		
		let managedContext = appDelegate.managedObjectContext
		
		//2
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
		
		//3
		do {
			let results =
				try managedContext.fetch(fetchRequest)
			notes = results as! [NSManagedObject]
			
			notesTableView.reloadData()
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	@IBAction func buttonClosePressed(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func addButtonPressed(_ sender: UIButton) {
	}
	
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as UITableViewCell
		
		let note = notes[indexPath.row] as! Note
		
		cell.textLabel?.text = note.title
		cell.detailTextLabel?.text = note.text
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return notes.count
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		let note = notes[indexPath.row] as! Note
		
		createNoteDetailView(note: note)
		
	}
	
	func createNoteDetailView(note: Note)
	{
		let padding = 10
		
		detailView = UIView(frame: notesTableView.frame)
		
		let subViewWidth = Int(detailView.frame.width) - (padding * 2)
		
		detailView.backgroundColor = UIColor.white
		
		let backButton = UIButton(type: .system)
		
		backButton.frame = CGRect(x: padding, y: padding, width: subViewWidth, height: 44)
		backButton.setTitle("< Back", for: .normal)
		backButton.contentHorizontalAlignment = .left
		
		backButton.addTarget(self, action: #selector(backToNotes), for: .touchUpInside)
		
		let titleLabel = UILabel(frame: CGRect(x: padding, y: Int(backButton.frame.height) + padding, width: subViewWidth, height: 44))
		titleLabel.text = note.title
		titleLabel.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightLight)
		
		let textLabel = UILabel(frame: CGRect(x: padding, y: Int(titleLabel.frame.height) + padding, width: subViewWidth, height: 200))
		textLabel.text = note.text
		textLabel.numberOfLines = 0
		textLabel.lineBreakMode = .byWordWrapping
		textLabel.font = UIFont.systemFont(ofSize: 15.0, weight: UIFontWeightThin)
		
		let mapView = MKMapView(frame: CGRect(x: padding, y: Int(textLabel.frame.height), width: subViewWidth, height: 200))
		
		let latitude = CLLocationDegrees(note.latitude!)
		let longitude = CLLocationDegrees(note.longitude!)
		let location = CLLocation(latitude: latitude, longitude: longitude)
		let regionRadius:CLLocationDistance = 500
		
		let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
  
		mapView.setRegion(coordinateRegion, animated: true)
		mapView.isScrollEnabled = false
		mapView.delegate = self
		
		let annotation = ThingAnnotation(title: note.title!, description: note.text!, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
		
		mapView.addAnnotation(annotation)
		
		detailView.addSubview(backButton)
		detailView.addSubview(titleLabel)
		detailView.addSubview(textLabel)
		detailView.addSubview(mapView)
		
		self.view.addSubview(detailView)
	}
	
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
				//view.rightCalloutAccessoryView = UIButton.withType(.DetailDisclosure) as UIView
			}
			return view
		}
		return nil
	}
	
	func backToNotes() {
		detailView?.removeFromSuperview()
	}
}
