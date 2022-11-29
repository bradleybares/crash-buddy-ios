//
//  TextEmergencyContactView.swift
//  CrashBuddy
//
//  Created by Matthew Chan on 11/22/22.
//


import Alamofire
import CoreLocation
import os


struct TextEmergencyContact {
    
    static let logger = os.Logger(subsystem: "com.crash-buddy.alamofire", category: "Alomofire")
    
    static let requestURL = "http://127.0.0.1"
    static let requestPort = 5005
    static let requestEndpoint = "\(requestURL):\(requestPort)"
    
    static func sendText(emergencyContact: EmergencyContact, activity: ActivityProfile, location: CLLocationCoordinate2D) {
        let headers : HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
            
        let parameters: Parameters = [
            "To": "+\(emergencyContact.phoneNumber)",
            "Body": "EMERGENCY\n\nA Crash Buddy user was unresponsive following a detected impact\n\nActivity: \(activity.name)\n\nLocation: (\(location.latitude), \(location.longitude))"
        ]
        
        logger.info("Sending Request: \(requestEndpoint)")
        
        AF.request("\(requestEndpoint)/sms", method: .post, parameters: parameters, headers: headers).response { response in
            switch (response.result) {
                case .success:
                logger.info("\(response.description)")
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                        logger.error("Request timeout!")
                    }
                }
        }
    }

}
