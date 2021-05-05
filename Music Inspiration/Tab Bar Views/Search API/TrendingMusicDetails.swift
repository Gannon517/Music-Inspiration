//
//  TrendingMusicDetails.swift
//  Music Inspiration
//
//  Created by Karan Nibber on 5/5/21.
//

import SwiftUI
import MapKit
 
struct TrendingMusicDetails: View {
   
    // Input Parameter
    let ma: MusicAlbum
    var body: some View {
        Form {
            Section(header: Text("Album Name")) {
                Text(ma.albumName)
            }
            Section(header: Text("Place Photo")) {
                getImageFromUrl(url: ma.coverPhotoFilename, defaultFilename: "ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 300, maxWidth: 500, alignment: .center)
            }
            Section(header: Text("Artist Name")) {
                Text(ma.artistName)
            }
            Section(header: Text("Song Name")) {
                Text(ma.songName)
            }
            Section(header: Text("Genre")) {
                Text(ma.genre)
            }
            Section(header: Text("PLAY Song on Youtube")) {
                NavigationLink(destination:
                                WebView(url: ma.musicVideID)
                                .navigationBarTitle(Text("Play Song"), displayMode: .inline)
                ){
                    HStack {
                        Image(systemName: "play.rectangle.fill")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.red)
                        Text("Play YouTube Trailer")
                            .font(.system(size: 16))
                            .foregroundColor(.blue)
                    }
                    .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
                }
            }
            
        }   // End of Form
        .navigationBarTitle(Text("Song Details"), displayMode: .inline)
        .font(.system(size: 14))    // Set font and size for all Text views in the Form
       
    }   // End of body
        
   
    
}
