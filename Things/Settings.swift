//
//  Settings.swift
//  Things
//
//  Created by Derek on 12/20/16.
//  Copyright © 2016 Bonnected. All rights reserved.
//

import Foundation

class Settings {
	
	static let leftHandModeKey = "leftHandMode"
	static let linkToGoogleMapsKey = "linkToGoogleMaps"
	static let privateDefaultKey = "privateDefault"
	static let enableTouchIdKey = "enableTouchId"
	static let touchIdSetupKey = "touchIdSetup"
	
	static let defaults: UserDefaults = .standard
	
	class func update(value: Int, forKey key: String) {
		defaults.set(value, forKey: key)
	}
	
	class func update(value: String, forKey key: String) {
		defaults.set(value, forKey: key)
	}
	
	class func update(value: Bool, forKey key: String) {
		defaults.set(value, forKey: key)
	}
	
	class func getValue(forKey key: String) -> Bool {
		return defaults.bool(forKey: key)
	}
}
