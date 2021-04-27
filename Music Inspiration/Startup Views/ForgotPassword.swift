//
//  ForgotPassword.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 4/27/21.
//

import SwiftUI

struct ForgotPassword: View {
    
    @State private var showValues = false
    @State private var securityQuestion = ""
    @State private var confirmedSecurityQuestion = ""
    
    let question = UserDefaults.standard.string(forKey: "SecurityQuestion")!
    let answer = UserDefaults.standard.string(forKey: "SecurityAnswer")
    
    var body: some View {
        Form {
            Section(header: Text("Show / Hide entered values")) {
                Toggle(isOn: $showValues) {
                    Text("Show Entered Values")
                }
            }
            
            Section(header: Text("Security Question")) {
                Text(question)
            }
            
            Section(header: Text("Enter answer to selected security question")) {
                HStack {
                    if self.showValues {
                        TextField("Enter Answer", text: $securityQuestion,
                                  onCommit: {
                                        self.confirmedSecurityQuestion = self.securityQuestion
                                  })
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 250, height: 36)
                            .padding()
                    }
                    else {
                        SecureField("Enter Answer", text: $securityQuestion,
                                    onCommit: {
                                        self.confirmedSecurityQuestion = self.securityQuestion
                                    })
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 250, height: 36)
                    }
                    Button(action : {
                        self.securityQuestion = ""
                    }) {
                        Image(systemName: "clear")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                    }
                }
            }
            
            if confirmedSecurityQuestion == answer {
                Section(header: Text("Go to settings to reset password")) {
                    NavigationLink(destination: Settings()) {
                        HStack {
                            Image(systemName: "gear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                                .foregroundColor(.blue)
                            Text("Show Settings")
                                .font(.system(size: 16))
                        }
                    }
                }
            }
            else {
                Section(header: Text("Incorrect answer")) {
                    Text("Answer to the Security Question is Incorrect!")
                        .font(.system(size: 16))
                }
            }
        }//End form
        .navigationBarTitle(Text("Password Reset"), displayMode: .inline)
    }
}

struct ForgotPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPassword()
    }
}
