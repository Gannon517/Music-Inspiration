//
//  TrendingMusicItem.swift
//  Music Inspiration
//
//  Created by Karan Nibber on 5/5/21.
//

import SwiftUI
 
struct TrendingMusicItem: View {
   
    // Input Parameter
    let ma: MusicAlbum
   
    var body: some View {
        HStack {
            getImageFromUrl(url: ma.coverPhotoFilename, defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100.0)
            VStack(alignment: .leading) {
                Text(ma.artistName)
                Text(ma.songName)
                Text(ma.albumName)
            }
            // Set font and size for the whole VStack content
            .font(.system(size: 14))
           
        }   // End of HStack
    }
}
