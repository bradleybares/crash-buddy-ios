//
//  TextEmergencyContactView.swift
//  CrashBuddy
//
//  Created by Matthew Chan on 11/22/22.
//

import SwiftUI
import Alamofire

struct TextEmergencyContactView: View {
    var emergencyContact: EmergencyContact?
    var phoneNumberField: String
    var messageField: String
    var requestEndpoint: String
    
    init(emergencyContact: EmergencyContact?) {
        self.emergencyContact = emergencyContact ?? nil
        self.phoneNumberField = (emergencyContact==nil) ? "+\(emergencyContact?.phoneNumber)" : "+16507147079"
        self.messageField = "CRASH BUDDY EMERGENCY"
        self.requestEndpoint = "http://127.0.0.1:5000"
    }
    
    func sendData() {
        let headers : HTTPHeaders = [
                "Content-Type": "application/x-www-form-urlencoded"
            ]
            
            let parameters: Parameters = [
                "To": phoneNumberField,
                "Body": messageField
            ]
            
            AF.request("\(requestEndpoint)/sms", method: .post, parameters: parameters, headers: headers).response { response in
                    print(response)
                
            }
        }
    
    var body: some View {
        Button {
            sendData()
        } label: {
            HStack {
                Spacer()
                Text("Text Emergency Contact")
                Spacer()
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

}
//
//struct TextEmergencyContactView_Previews: PreviewProvider {
//    static var previews: some View {
//        TextEmergencyContactView()
//    }
//}
