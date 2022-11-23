//
//  TextEmergencyContactView.swift
//  CrashBuddy
//
//  Created by Matthew Chan on 11/22/22.
//


import Alamofire


struct TextEmergencyContact {
    
    static let requestURL = "http://127.0.0.1:5005"
    static let requestPort = 5005
    static let requestEndpoint = "\(requestURL):\(requestPort)"
    
    static func sendText(_ emergencyContact: EmergencyContact) {
        let headers : HTTPHeaders = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
            
        let parameters: Parameters = [
            "To": "+\(emergencyContact.phoneNumber)",
            "Body": "CRASH BUDDY EMERGENCY"
        ]
        
        AF.request("\(requestEndpoint)/sms", method: .post, parameters: parameters, headers: headers).response { response in
                print(response)
            
        }
    }

}
