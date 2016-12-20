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

class NotesViewController: UIViewController {
	
	@IBOutlet var notesTableView: UITableView!
	@IBOutlet var addButton: UIButton!
	
	var detailView: UIView!
	var notes = [NSManagedObject]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupViews()
	}
	
	private func setupViews() {
		
		notesTableView.dataSource = self
		notesTableView.delegate = self
		notesTableView.layer.cornerRadius = 5
	}
	
	override func viewDidAppear(_ animated: Bool) {
		do {
			self.notes = try Notes.getAll()
			
			notesTableView.reloadData()
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}
	}
	
	@IBAction func buttonClosePressed(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func addButtonPressed(_ sender: UIButton) {
	}
	
	
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "noteDetailSegue" {
			
			// get the detail view
			let detailView = segue.destination as! NoteDetailViewController
			
			// set the note property
			let index = notesTableView.indexPathForSelectedRow?.row
			
			detailView.note = notes[index!] as? Note
			
			print(detailView.note!)
			
		}
	}
}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
	
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
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		
		let edit = UITableViewRowAction(style: .normal, title: "       ") { (action, indexPath) in
		
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let addEditController = storyboard.instantiateViewController(withIdentifier: "AddNoteViewController") as! AddNoteViewController
			let note = self.notes[indexPath.row] as! Note
			
			addEditController.note = note
			addEditController.editMode = true
			addEditController.modalPresentationStyle = .overCurrentContext
			
			self.present(addEditController, animated: true, completion: nil)
			
		}
		
		let delete = UITableViewRowAction(style: .normal, title: "       ") { (action, indexPath) in
		
			let note = self.notes[indexPath.row]
			
			do {
				try Notes.delete(note: note)
				self.notes.remove(at: indexPath.row)
				tableView.deleteRows(at: [indexPath], with: .automatic)
			} catch let error as NSError {
				print("unable to delete: \(error)")
			}
			
		}
		
		delete.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "delete-action"))
		edit.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "edit-action"))
			
		return[delete, edit]
		
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
}
