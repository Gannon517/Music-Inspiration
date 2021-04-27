//
//  SearchResultDetails.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 4/27/21.
//

import SwiftUI
 
struct SearchResultDetails: View {
   
    // ❎ Input parameter: CoreData Song Entity instance reference
    let song: Song
   
    var body: some View {
        Form {
            /*
            ?? is called nil coalescing operator.
            IF song.albumName is not nil THEN
                unwrap it and return its value
            ELSE return ""
            */
            Section(header: Text("Album Name")) {
                Text(song.albumName ?? "")
            }
            Section(header: Text("Album Cover Photo")) {
                // This public function is given in UtilityFunctions.swift
                getImageFromBinaryData(binaryData: song.photo!.albumCoverPhoto!, defaultFilename: "AlbumCoverDefaultImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 300, maxWidth: 500, alignment: .center)
            }
            Section(header: Text("Artist Name")) {
                Text(song.artistName ?? "")
            }
            Section(header: Text("Song Name")) {
                Text(song.songName ?? "")
            }
            Section(header: Text("Genre")) {
                Text(song.genre ?? "")
            }
            Section(header: Text("Release Date")) {
                Text(song.releaseDate ?? "")
            }
            Section(header: Text("My Rating")) {
                Text(song.rating ?? "")
            }
 
        }   // End of Form
        .navigationBarTitle(Text("Found Song Details"), displayMode: .inline)
        .font(.system(size: 14))
       
    }   // End of body
}

