//
//  Settings.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 4/27/21.
//

import SwiftUI

struct Settings: View {
    
    @EnvironmentObject var userData: UserData
    
    @State private var securityQuestion = ""
    @State private var passwordEntered = ""
    @State private var passwordVerified = ""
    @State private var showValues = false
    @State private var showUnmatchedPasswordAlert = false
    @State private var showPasswordSetAlert = false
    
    
    let securityQuestionList = ["In what city or town did your mother and father meet?", "In what city or town were you born?", "What did you want to be when you grew up?", "What do you remember most from your childhood?", "What is the name of the first boy or girl that you first kissed?", "What is the name of the first school you attended?", "What is the name of your favorite childhood friend?", "What is the name of your first pet?", "What is your mothers maiden name?", "What was your favorite place to visit as a child?"]
    @State private var selectedIndex = 2
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
                Form {
                    Section(header: Text("Show / Hide entered values")) {
                        Toggle(isOn: $showValues) {
                            Text("Show Entered Values")
                        }
                    }
                    
                    Section(header: Text("Select a security question")) {
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
                    
                    Section(header: Text("Set password")) {
                        Button(action: {
                            if !passwordEntered.isEmpty {
                                if passwordEntered == passwordVerified {
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
                            }
                        }) {
                            Text("Set Password to Unlock App")
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
            .navigationBarTitle(Text("Settings"), displayMode: .inline)
        }//End Nav View
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

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}

