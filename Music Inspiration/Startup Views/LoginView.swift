//
//  LoginView.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 4/27/21.
//

import SwiftUI
import LocalAuthentication

struct LoginView : View {
   
    // Subscribe to changes in UserData
    @EnvironmentObject var userData: UserData
   
    @State private var enteredPassword = ""
    @State private var showInvalidPasswordAlert = false
    
    let context = LAContext()
    @State private var error: NSError?
    @State private var unlock = false
   
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Image("Welcome")
                        .padding(.top, 30)
                   
                    Text("Audio Inspiration")
                        .font(.headline)
                        .padding()
                   
                    Image("Inspiration")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minWidth: 300, maxWidth: 600, maxHeight: 300)
                        .padding()
                   
                    SecureField("Password", text: $enteredPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 300, height: 36)
                        .padding()
                    HStack {
                        Button(action: {
                            let validPassword = UserDefaults.standard.string(forKey: "Password")
                           
                            if validPassword == nil || self.enteredPassword == validPassword {
                                userData.userAuthenticated = true
                                self.showInvalidPasswordAlert = false
                            } else {
                                self.showInvalidPasswordAlert = true
                            }
                           
                        }) {
                            Text("Login")
                                .frame(width: 100, height: 36, alignment: .center)
                                .padding(.leading, 25)
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color.black, lineWidth: 1)
                                        .padding(.leading, 30)
                                )
                            Spacer()
                        }
                        
                        Button(action: {
                            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Identify yourself!") { success, authenticationError in
                                    DispatchQueue.main.async {
                                        if success {
                                            userData.userAuthenticated = true
                                        }
                                        else {
                                            //error
                                            let ac = UIAlertController(title: "Authentication failed!", message: "You could not be verified, please try again", preferredStyle: .alert)
                                            ac.addAction(UIAlertAction(title: "OK", style: .default))
                                            //self.present(ac, animated: true)
                                        }
                                    }
                                }
                            }
                            else {
                                //cannot use FaceID
                            }
                        }) {
                            Image(systemName: "faceid")
                                .font(Font.title.weight(.regular))
                                .imageScale(.large)
                                .frame(width: 100, height: 36, alignment: .center)
                                .padding(.trailing, 10)
                        }
                        
                        let securityAnswer = UserDefaults.standard.string(forKey: "SecurityAnswer")
                        if securityAnswer != nil {
                            //Spacer()
                            NavigationLink(destination: ForgotPassword()) {
                                Spacer()
                                Text("Forgot Password")
                                    .frame(width: 140, height: 36, alignment: .center)
                                    .padding(.trailing, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(Color.black, lineWidth: 1)
                                            .padding(.trailing, 10)
                                    )
                                //Spacer()
                            }
                        }
                    }
                    .alert(isPresented: $showInvalidPasswordAlert, content: { self.invalidPasswordAlert })
                   
                }   // End of VStack
            }   // End of ScrollView
            }   // End of ZStack
        }//End Nav view
    }   // End of var
   
    /*
     ------------------------------
     MARK: - Invalid Password Alert
     ------------------------------
     */
    var invalidPasswordAlert: Alert {
        Alert(title: Text("Invalid Password!"),
              message: Text("Please enter a valid password to unlock the app!"),
              dismissButton: .default(Text("OK")) )
       
        // Tapping OK resets @State var showInvalidPasswordAlert to false.
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
