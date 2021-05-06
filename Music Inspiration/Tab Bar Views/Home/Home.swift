//
//  Home.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 4/26/21.
//
//  Copyright © 2021 Michael Gannon and Gurkaran Nibber. All rights reserved.
//
import SwiftUI

struct Home: View {
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
        ScrollView {
            Image("Welcome")
                .padding(.top, 50)
            
            Image("albumCoverArtGrid")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 300, maxWidth: 500, alignment: .center)
                .padding()
            
            Text("Powered By:")
                .padding(.bottom, 20)
            
            Link(destination: URL(string: "https://www.theaudiodb.com")!) {
                HStack {
                    Image(systemName: "gearshape.2")
                    Text("Musci DB API")
                }
            }
            .padding()
            
            Text("Created By:")
                .padding(.bottom, 10)
            Text("Michael Gannon &")
            Text("Gurkaran Nibber")
            
        }//End Scroll View
        }//End ZStack
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
