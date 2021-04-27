//
//  UserData.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 4/27/21.
//

import Combine
import SwiftUI
 
final class UserData: ObservableObject {
    // Publish if the user is authenticated or not
    @Published var userAuthenticated = false
}
