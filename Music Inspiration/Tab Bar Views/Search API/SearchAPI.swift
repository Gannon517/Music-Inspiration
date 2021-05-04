//
//  SearchAPI.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 4/27/21.
//

import SwiftUI

struct SearchAPI: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
                VStack {
                    Image("MusicNote")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding()
                    //Spacer()
                    NavigationLink(destination: TrendingMusic()) {
                        HStack {
                            Image(systemName: "star.circle")
                                .imageScale(.large)
                                .font(Font.title.weight(.regular))
                                .foregroundColor(.blue)
                            Text("Current Trending Music")
                                .font(.system(size: 22))
                        }
                        .frame(minWidth: 300, maxWidth: 500, alignment:.leading)
                        .padding()
                    }
                    
                    NavigationLink(destination: SearchByArtist()) {
                        HStack {
                            Image(systemName: "a.circle")
                                .imageScale(.large)
                                .font(Font.title.weight(.regular))
                                .foregroundColor(.blue)
                            Text("Search Music by Artist")
                                .font(.system(size: 22))
                        }
                        .frame(minWidth: 300, maxWidth: 500, alignment:.leading)
                        .padding()
                    }
                    
                }
            }
            .navigationBarTitle(Text("Search Music"), displayMode: .inline)
        }
    }
}

struct SearchAPI_Previews: PreviewProvider {
    static var previews: some View {
        SearchAPI()
    }
}
