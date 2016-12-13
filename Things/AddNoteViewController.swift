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

class AddNoteViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
	@IBOutlet var noteText: UITextView!
	@IBOutlet var switchPrivate: UISwitch!
	@IBOutlet var titleText: UITextField!
	
	var location: CLLocation? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupViews()

		print(location ?? "no location provided")
        // Do any additional setup after loading the view.
    }
	
	private func setupViews() {
		
		noteText.delegate = self
		noteText.layer.cornerRadius = 5
		
		let padding = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: titleText.frame.height))
		
		titleText.borderStyle = .roundedRect
		titleText.layer.cornerRadius = 5
		titleText.leftView = padding
		titleText.leftViewMode = .always
		titleText.delegate = self
		
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if text == "\n"  // Recognizes enter key in keyboard
		{
			textView.resignFirstResponder()
			return false
		}
		return true
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

	@IBAction func buttonSavePressed(_ sender: UIButton) {
		if saveNote() {
			// close note; show added message
			self.dismiss(animated: true, completion: nil)
		}
		else {
			// show alert view
			
		}
	}
	
	func saveNote() -> Bool {
		
		//1
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		
		let managedContext = appDelegate.managedObjectContext
		
		//2
		let entity =  NSEntityDescription.entity(forEntityName: "Note",
		                                         in:managedContext)
		
		let note = NSManagedObject(entity: entity!,
		                             insertInto: managedContext)
		
		//3
		let title = titleText.text
		let text = noteText.text
		let isPrivate = switchPrivate.isOn
		
		note.setValue(title, forKey: "title")
		note.setValue(text, forKey: "text")
		note.setValue(isPrivate, forKey: "isPrivate")
		note.setValue(Date.init(), forKey: "dateAdded")
		note.setValue(Date.init(), forKey: "lastUpdated")
		note.setValue(location?.coordinate.latitude, forKey: "latitude")
		note.setValue(location?.coordinate.longitude, forKey: "longitude")
		
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
	
	@IBAction func buttonClosePressed(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
}
