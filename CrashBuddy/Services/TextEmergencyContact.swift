//
//  TextEmergencyContactView.swift
//  CrashBuddy
//
//  Created by Matthew Chan on 11/22/22.
//


import Alamofire
import CoreLocation


struct TextEmergencyContact {
    
    static let requestURL = "http://127.0.0.1"
    static let requestPort = 5005
    static let requestEndpoint = "\(requestURL):\(requestPort)"
    
    static func sendText(emergencyContact: EmergencyContact, location: CLLocationCoordinate2D) {
        let headers : HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
            
        let parameters: Parameters = [
            "To": "+\(emergencyContact.phoneNumber)",
            "Body": "CRASH BUDDY EMERGENCY \n Crash Detected at (\(location.latitude), \(location.longitude))"
        ]
        
        AF.request("\(requestEndpoint)/sms", method: .post, parameters: parameters, headers: headers).response { response in
                print(response)
            
        }
    }

}
