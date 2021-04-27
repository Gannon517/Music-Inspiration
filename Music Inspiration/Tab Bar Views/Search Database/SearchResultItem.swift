//
//  SearchResultItem.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 4/27/21.
//

import SwiftUI
 
struct SearchResultItem: View {
   
    // ❎ Input parameter: CoreData Song Entity instance reference
    let song: Song
   
    var body: some View {
        HStack {
            // This public function is given in UtilityFunctions.swift
            getImageFromBinaryData(binaryData: song.photo!.albumCoverPhoto!, defaultFilename: "AlbumCoverDefaultImage")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0)
           
            VStack(alignment: .leading) {
                /*
                ?? is called nil coalescing operator.
                IF song.artistName is not nil THEN
                    unwrap it and return its value
                ELSE return ""
                */
                Text(song.artistName ?? "")
                Text(song.songName ?? "")
                Text(song.rating ?? "")
            }
            .font(.system(size: 14))
        }
    }
}
