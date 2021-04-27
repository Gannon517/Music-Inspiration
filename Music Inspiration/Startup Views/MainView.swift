//
//  MainView.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 4/27/21.
//

import SwiftUI

struct MainView: View {
    
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            SongsList()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
            SearchDatabase()
                .tabItem {
                    Image(systemName: "magnifyingglass.circle.fill")
                    Text("Search Database")
                }
            SearchAPI()
                .tabItem {
                    Image(systemName: "magnifyingglass.circle.fill")
                    Text("Search API")
                }
            Settings()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .font(.headline)
        .imageScale(.medium)
        .font(Font.title.weight(.regular))
    }
    
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
