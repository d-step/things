//
//  SettingsViewController.swift
//  Things
//
//  Created by Derek on 12/20/16.
//  Copyright © 2016 Bonnected. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

	@IBOutlet var tableViewContainer: UIView!
	
	var delegate: ActionBarDelegate?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupViews()

        // Do any additional setup after loading the view.
    }
	
	func setupViews() {
		
		tableViewContainer.layer.cornerRadius = 5
		
	}
    
	@IBAction func buttonClosePressed(_ sender: Any) {
		delegate?.updateActionBarFrame()
		self.dismiss(animated: true, completion: nil)
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
