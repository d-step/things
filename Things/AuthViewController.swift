//
//  AuthViewController.swift
//  Things
//
//  Created by Derek on 12/22/16.
//  Copyright © 2016 Bonnected. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthViewController: UIViewController, ThingDisplaying {
	
	var note: Note? = nil
	let buttonWidth: CGFloat = 70.0
	let buttonHeight: CGFloat = 70.0

	@IBOutlet var labelWrongPasscode: UILabel!
	@IBOutlet var passCodeField: UITextField!
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	
	@IBAction func numberPressed(_ sender: RoundedButton) {
		
		if passCodeField.text!.characters.count <= 3 {
			
			passCodeField.text = passCodeField.text?.appending((sender.titleLabel?.text)!)
			
		}
		
		if passCodeField.text!.characters.count == 4 {
			
			Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.authenticate), userInfo: nil, repeats: false);
			
		}
		
	}
	
	func authenticate() {
		
		if Authentication.isTouchIdSetup() {
			
			let context = Authentication.sharedContext
			
			if Authentication.isTouchIdSetup() {
				let reasonString = "Touch ID needed to secure your things"
				
				context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) {
					[unowned self] success, authenticationError in
					
					DispatchQueue.main.async {
						if success {
							self.showDetail()
						} else {

							if let error = authenticationError as NSError? {
								
								var message : String
								var showAlert : Bool
								
								// 4.
								switch(error.code) {
									case LAError.authenticationFailed.rawValue:
										message = "There was a problem verifying your identity."
										showAlert = true
										break;
									case LAError.userCancel.rawValue:
										message = "You pressed cancel."
										showAlert = true
										break;
									case LAError.userFallback.rawValue:
										message = "You pressed password."
										showAlert = true
										break;
									default:
										showAlert = true
										message = "Touch ID may not be configured"
										break;
								}
								
								if showAlert {
									
									let ac = UIAlertController(title: "Authentication failed", message: message, preferredStyle: .alert)
									ac.addAction(UIAlertAction(title: "OK", style: .default))
									self.present(ac, animated: true)
									
								}
								
							}
						}
					}
				}
			} else {
				
				authenticateWithPasscode()
				
			}
			
		} else {
			
			// clear the field
			passCodeField.text = ""
			
			// show the incorrect label
			labelWrongPasscode.isHidden = false
			
		}
		
	}
	
	private func authenticateWithPasscode() {
		
		let code = passCodeField.text!
		
		if Authentication.authenticate(tryCode: code) {
			
			showDetail()
			
		}
		
	}
	
	private func showDetail() {
		
		// open add view
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! NoteDetailViewController
		
		detailVC.modalPresentationStyle = .overCurrentContext
		detailVC.note = note
		
		self.presentingViewController?.dismiss(animated: false, completion: nil)
		self.presentingViewController?.present(detailVC, animated: true, completion: nil)
		
	}

}
