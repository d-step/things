//
//  Notes.swift
//  Things
//
//  Created by Derek on 12/14/16.
//  Copyright © 2016 Bonnected. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Notes {
	
	static func getAll() throws -> [NSManagedObject] {
		
		//1
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		
		let managedContext = appDelegate.managedObjectContext
		
		//2
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
		
		//3
		do {
			return try managedContext.fetch(fetchRequest) as! [NSManagedObject]
		} catch let error as NSError {
			print("Could not fetch \(error), \(error.userInfo)")
		}

		return []
	}
	
	static func delete(note: NSManagedObject) throws {
		
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		
		let managedContext = appDelegate.managedObjectContext
		
		managedContext.delete(note)
		
		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Error saving context: \(error)")
		}
		
	}
	
}
