//
//  AuthContainerViewController.swift
//  Things
//
//  Created by Derek on 12/23/16.
//  Copyright © 2016 Bonnected. All rights reserved.
//

import UIKit

class AuthContainerViewController: UIViewController, ThingDisplaying {

	var note: Note?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.view.blur(style: .light)
    }

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "embedSegue" {
			
			let authView = segue.destination as! AuthViewController
			
			authView.note = note
			
		}
		
	}
	
}
