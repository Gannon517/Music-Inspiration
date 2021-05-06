//
//  FirstLogin.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 5/3/21.
//
//  Copyright © 2021 Michael Gannon and Gurkaran Nibber. All rights reserved.
//

import SwiftUI

struct FirstLogin: View {
    
    @EnvironmentObject var userData: UserData
    
    @State private var securityQuestion = ""
    @State private var passwordEntered = ""
    @State private var passwordVerified = ""
    @State private var showValues = false
    @State private var showUnmatchedPasswordAlert = false
    @State private var showPasswordSetAlert = false
    @State private var needToEnterPassword = false
    
    let securityQuestionList = ["What is your mothers maiden name?"]
    @State private var selectedIndex = 0
    
    var body: some View {
        //NavigationView {
            ZStack {
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
                Form {
                    Section {
                        //Spacer()
                        Image("Welcome")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                            //.padding(.top, 30)
                        //Spacer()
                        Text("It looks like it is your first time logging into Music Inspiration, lets set your password & recovery security question for future use")
                    }
                    
                    Section(header: Text("Show / Hide entered values")) {
                        Toggle(isOn: $showValues) {
                            Text("Show Entered Values")
                        }
                    }
                    
                    Section(header: Text("Selected security question"), footer: Text("This is set for now but can be changed in your settings")) {
                        Picker("Selected:", selection: $selectedIndex) {
                            ForEach(0..<securityQuestionList.count, id: \.self) {
                                Text(self.securityQuestionList[$0])
                            }
                        }
                    }
                    
                    Section(header: Text("Enter answer to selected security question")) {
                        HStack {
                            if self.showValues {
                                TextField("Enter Answer", text: $securityQuestion)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 250, height: 36)
                            }
                            else {
                                SecureField("Enter Answer", text: $securityQuestion)
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
                    
                    Section(header: Text("Enter Password")) {
                        HStack {
                            if self.showValues {
                                TextField("Enter Password", text: $passwordEntered)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 250, height: 36)
                            } else {
                                SecureField("Enter Password", text: $passwordEntered)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 250, height: 36)
                            }
                            Button(action: {
                                self.passwordEntered = ""
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }
                    }
                    
                    Section(header: Text("Verify password")) {
                        HStack {
                            if self.showValues {
                                TextField("Verify Password", text: $passwordVerified)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 250, height: 36)
                            } else {
                                SecureField("Verify Password", text: $passwordVerified)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 250, height: 36)
                            }
                            Button(action: {
                                self.passwordVerified = ""
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }
                    }
                    
                    Section(header: Text("Set password and login")) {
                        Button(action: {
                            if !passwordEntered.isEmpty {
                                if passwordEntered == passwordVerified {
                                    userData.userAuthenticated = true
                                    UserDefaults.standard.set(self.passwordEntered, forKey: "Password")
                                    if !self.securityQuestion.isEmpty {
                                        UserDefaults.standard.set(self.securityQuestionList[selectedIndex], forKey: "SecurityQuestion")
                                        UserDefaults.standard.set(self.securityQuestion, forKey: "SecurityAnswer")
                                    }
                                    self.securityQuestion = ""
                                    self.passwordEntered = ""
                                    self.passwordVerified = ""
                                    self.showPasswordSetAlert = true
                                }
                                else {
                                    self.showUnmatchedPasswordAlert = true
                                }
                            } else {
                                self.needToEnterPassword = true
                            }
                        }) {
                            Text("Set Password and Login")
                                .frame(width: 300, height: 36, alignment: .center)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color.black, lineWidth: 1)
                                )
                                .alert(isPresented: $showUnmatchedPasswordAlert, content: { self.unmatchedPasswordAlert })
                        }
                    }
                }//End Form
                .alert(isPresented: $showPasswordSetAlert, content: { self.passwordSetAlert })
            }//End ZStack
            .alert(isPresented: $needToEnterPassword, content: {self.enterPasswordAlert})
        //}//End Nav View
    }
    /*
     --------------------------
     MARK: - Password Set Alert
     --------------------------
     */
    var passwordSetAlert: Alert {
        Alert(title: Text("Password Set!"),
              message: Text("Password you entered is set to unlock the app!"),
              dismissButton: .default(Text("OK")) )
    }
    
    var enterPasswordAlert: Alert {
        Alert(title: Text("No Password Entered"),
              message: Text("You have not entered a password!"),
              dismissButton: .default(Text("OK")))
    }
    
    /*
     --------------------------------
     MARK: - Unmatched Password Alert
     --------------------------------
     */
    var unmatchedPasswordAlert: Alert {
        Alert(title: Text("Unmatched Password!"),
              message: Text("Two entries of the password must match!"),
              dismissButton: .default(Text("OK")) )
    }
}

struct FirstLogin_Previews: PreviewProvider {
    static var previews: some View {
        FirstLogin()
    }
}
