//
//  AddNoteViewController.swift
//  Things
//
//  Created by Derek on 11/18/16.
//  Copyright © 2016 Bonnected. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class AddNoteViewController: UIViewController, ThingDisplaying {
	@IBOutlet var noteText: UITextView!
	@IBOutlet var switchPrivate: UISwitch!
	@IBOutlet var titleView: UITextView!
	@IBOutlet var selectedMapView: MKMapView!
	@IBOutlet var saveButton: UIButton!
	@IBOutlet var contentScrollView: UIScrollView!
	
	var errorView = UIView()
	var delegate: EditingDetailDelegate?
	
	var location: CLLocation? = nil
	var note: Note?
	var editMode: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupViews()

		print(location ?? "no location provided")
        // Do any additional setup after loading the view.
    }
	
	private func setupViews() {
		
		noteText.delegate = self
		titleView.delegate = self
		
		titleView.sizeToFit()
		noteText.sizeToFit()
		
		noteText.layer.cornerRadius = 5
		saveButton.layer.cornerRadius = 5
		contentScrollView.layer.cornerRadius = 5
		
		if self.note != nil, editMode {
			
			setupForEdit()
			
		} else if self.location != nil {
			
			switchPrivate.isOn = Settings.getValue(forKey: Settings.privateDefaultKey)
			
			setupMap(withCoordinate: location!.coordinate)
		
		}
		
	}
	
	func setupForEdit() {
		
		titleView.text = note?.title
		noteText.text = note?.text
		switchPrivate.isOn = (note?.isPrivate)!
		saveButton.titleLabel?.text = "UPDATE"
		
		noteText.textColor = #colorLiteral(red: 0.3501774084, green: 0.3536445114, blue: 0.3536445114, alpha: 1)
		titleView.textColor = #colorLiteral(red: 0.3501774084, green: 0.3536445114, blue: 0.3536445114, alpha: 1)
		
		let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(note!.latitude!), CLLocationDegrees((note!.longitude!)))
		
		setupMap(withCoordinate: coordinate)
		
	}
	
	func setupMap(withCoordinate coordinate: CLLocationCoordinate2D) {
		
		let regionRadius:CLLocationDistance = 500
		
		let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0, regionRadius * 2.0)
			
		selectedMapView.setRegion(coordinateRegion, animated: true)
		selectedMapView.isScrollEnabled = false
		selectedMapView.delegate = self
		
		let annotation = ThingAnnotation(title: "", description: "", coordinate: coordinate)
		
		selectedMapView.addAnnotation(annotation)
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

	@IBAction func buttonSavePressed(_ sender: UIButton) {
		
		self.view.endEditing(true)
		
		if !validate() {
			
			addErrorViews()
			return
			
		}
		
		if saveNote() {
			// close note; show added message
			if self.delegate != nil {
				
				self.delegate?.updateItem(data: note!)
				
			}
			
			self.dismiss(animated: true, completion: nil)
		}
		else {
			// show alert view
			
		}
	}
	
	func validate() -> Bool {
		
		var isValid: Bool!
		
		isValid = titleView.text != "" && titleView.text != getPlaceholder(forTextView: titleView)
		
		return isValid
		
	}
	
	func addErrorViews() {
		
		let x = titleView.frame.origin.x
		let y = titleView.frame.origin.y + titleView.frame.height
		let width = titleView.frame.width
		let height: CGFloat = 2
		
		errorView = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
		
		errorView.backgroundColor = UIColor.red
		
		self.contentScrollView.addSubview(errorView)
	}
	
	func saveNote() -> Bool {
		
		//1
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		
		let managedContext = appDelegate.managedObjectContext
		
		if editMode {
			saveEdit(withContext: managedContext)
		} else {
			saveNew(withContext: managedContext)
		}
		
		//4
		do {
			
			if managedContext.hasChanges {
				try managedContext.save()
				
				return true
			}
			
			return true
		} catch let error as NSError  {
			print("Could not save \(error), \(error.userInfo)")
			
			return false
		}
	}
	
	func saveNew(withContext managedContext: NSManagedObjectContext) {
		//2
		let entity =  NSEntityDescription.entity(forEntityName: "Note",
		                                         in:managedContext)
		
		let note = NSManagedObject(entity: entity!,
		                           insertInto: managedContext)
		
		//3
		let title = titleView.text
		let text = noteText.text
		let isPrivate = switchPrivate.isOn
		
		note.setValue(title, forKey: "title")
		note.setValue(text, forKey: "text")
		note.setValue(isPrivate, forKey: "isPrivate")
		note.setValue(Date.init(), forKey: "lastUpdated")
		note.setValue(Date.init(), forKey: "dateAdded")
		note.setValue(location?.coordinate.latitude, forKey: "latitude")
		note.setValue(location?.coordinate.longitude, forKey: "longitude")
	}
	
	func saveEdit(withContext managedContext: NSManagedObjectContext) {
		
		do {
			let existingNote = try managedContext.existingObject(with: (note?.objectID)!)
			
			let title = titleView.text
			let text = noteText.text
			let isPrivate = switchPrivate.isOn
			
			existingNote.setValue(title, forKey: "title")
			existingNote.setValue(text, forKey: "text")
			existingNote.setValue(isPrivate, forKey: "isPrivate")
			existingNote.setValue(Date.init(), forKey: "lastUpdated")
			
		} catch let error as NSError {
			print(error)
		}
		
	}
	
	@IBAction func buttonClosePressed(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
}

extension AddNoteViewController: UITextViewDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		
		if !editMode, isPlaceholderText(forTextView: textView) {
			textView.text = ""
		}
		
		textView.textColor = #colorLiteral(red: 0.3501774084, green: 0.3536445114, blue: 0.3536445114, alpha: 1)
		
		textView.becomeFirstResponder()
		
		// remove error view on editing
		errorView.removeFromSuperview()
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		
		let placeholderText = getPlaceholder(forTextView: textView)
		
		if textView.text == "" {
			
			textView.text = placeholderText
			textView.textColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
			
		}
		
	}
	
	func isPlaceholderText(forTextView textView:UITextView) -> Bool {
		
		return textView.text == getPlaceholder(forTextView: textView)
		
	}
	
	func getPlaceholder(forTextView textView: UITextView) -> String {
		if textView.restorationIdentifier == "noteView" {
			
			return "enter a message (optional)"
			
		}
		
		if textView.restorationIdentifier == "titleView" {
			
			return "enter a title"
			
		}
		
		return ""
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
	
		if text == "\n"  // Recognizes enter key in keyboard
		{
			textView.resignFirstResponder()
			return false
		}
		
		return true
	}
}

extension AddNoteViewController: MKMapViewDelegate {
	
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
	
}
