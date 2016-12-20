//
//  SettingsTableViewController.swift
//  Things
//
//  Created by Derek on 12/13/16.
//  Copyright © 2016 Bonnected. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
	
	@IBOutlet var leftHandModeSwitch: UISwitch!
	@IBOutlet var linkToGoogleMapsSwitch: UISwitch!
	@IBOutlet var privateDefaultSwitch: UISwitch!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		setupViews()
    }
	
	private func setupViews() {
		
		tableView.dataSource = self
		tableView.delegate = self
		
		leftHandModeSwitch.isOn = Settings.getValue(forKey: Settings.leftHandModeKey)
		linkToGoogleMapsSwitch.isOn = Settings.getValue(forKey: Settings.linkToGoogleMapsKey)
		privateDefaultSwitch.isOn = Settings.getValue(forKey: Settings.privateDefaultKey)
		
	}
	
	@IBAction func leftHandModeChanged(_ sender: Any) {
		
		let value = (sender as! UISwitch).isOn
		
		Settings.update(value: value, forKey: Settings.leftHandModeKey)
	}
	
	@IBAction func linkToGoogleMapsChanged(_ sender: Any) {
		let value = (sender as! UISwitch).isOn
		
		Settings.update(value: value, forKey: Settings.linkToGoogleMapsKey)
	}
	
	@IBAction func privateDefaultChanged(_ sender: Any) {
		let value = (sender as! UISwitch).isOn
		
		Settings.update(value: value, forKey: Settings.privateDefaultKey)
	}

}
