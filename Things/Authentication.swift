//
//  Authentication.swift
//  Things
//
//  Created by Derek on 12/24/16.
//  Copyright © 2016 Bonnected. All rights reserved.
//

import Foundation
import LocalAuthentication

class Authentication {
	
	static let sharedContext = LAContext()
	
	static func retrievePassCode() -> String {
		
		return "1234"
		
	}
	
	static func authenticate(tryCode: String) -> Bool {
		
		let passCode = retrievePassCode()
		
		return tryCode == passCode
		
	}
	
	static func setCode(code: String) -> Bool {
		
		let success = false
		
		
		
		return success
	}
	
	static func isTouchIdSetup() -> Bool {
		
		// if we can user touch ID, the user has opted to enabled touch ID in app, and touch ID is setup
		return canAuthenticateWithTouchId() &&
			Settings.getValue(forKey: Settings.enableTouchIdKey) &&
			Settings.getValue(forKey: Settings.touchIdSetupKey)
		
	}
	
	static func canAuthenticateWithTouchId() -> Bool {
		
		return sharedContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
		
	}
	
}
