//
//  SongItem.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 4/27/21.
//

import SwiftUI
 
struct SongItem: View {
   
    // ❎ Input parameter: CoreData Song Entity instance reference
    let song: Song
   
    // ❎ CoreData FetchRequest returning all Song entities in the database
    @FetchRequest(fetchRequest: Song.allSongsFetchRequest()) var allSongs: FetchedResults<Song>
   
    // ❎ Refresh this view upon notification that the managedObjectContext completed a save.
    // Upon refresh, @FetchRequest is re-executed fetching all Song entities with all the changes.
    @EnvironmentObject var userData: UserData
   
    var body: some View {
        HStack {
            if (song.photo!.photoUrl == ""){
                getImageFromBinaryData(binaryData: song.photo!.albumCoverPhoto!, defaultFilename: "AlbumCoverDefaultImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80.0)
            }
            else{
                getImageFromUrl(url: song.photo!.photoUrl ?? "", defaultFilename: "AlbumCoverDefaultImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80.0)
            }
            // This public function is given in UtilityFunctions.swift
            
           
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
