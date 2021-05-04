//
//  ContentView.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 4/23/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        if userData.userAuthenticated {
            return AnyView(MainView())
        }
        else if UserDefaults.standard.string(forKey: "Password") == nil {
            return AnyView(FirstLogin())
        }
        else {
            return AnyView(LoginView())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
