//
//  TrendingMusicDetails.swift
//  Music Inspiration
//
//  Created by Karan Nibber on 5/5/21.
//

import SwiftUI
import MapKit
 
struct TrendingMusicDetails: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var showSongAddedAlert = false
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
            
            Section(header: Text("Add This Song to My Music")) {
                Button(action: {
                    let newSong = Song(context: self.managedObjectContext)
                   
                    // ❎ Dress up the new Song entity
                    newSong.artistName = ma.artistName
                    newSong.albumName = ma.albumName
                    newSong.songName = ma.songName
                    newSong.genre = ma.genre
                    newSong.releaseDate = "Unknown"
                    newSong.rating = "Fair"
                    newSong.musicVideoID = ma.musicVideID
                   
                    /*
                     ======================================================
                     Create an instance of the Photo Entity and dress it up
                     ======================================================
                    */
                   
                    // ❎ Create a new Photo entity in CoreData managedObjectContext
                    let newPhoto = Photo(context: self.managedObjectContext)
                   
                  
                    let photoUIImage = UIImage(named: "AlbumCoverDefaultImage")
                       
                        // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
                    let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
                       
                        // Assign photoData to Core Data entity attribute of type Data (Binary Data)
                    newPhoto.albumCoverPhoto = photoData!
                    newPhoto.photoUrl = ma.coverPhotoFilename
                    
                   
                    /*
                     ==============================
                     Establish Entity Relationships
                     ==============================
                    */
                   
                    // Establish One-to-One Relationship between Song and Photo
                    newSong.photo = newPhoto
                    newPhoto.song = newSong
                   
                    /*
                     =============================================
                     MARK: - ❎ Save Changes to Core Data Database
                     =============================================
                     */
                   
                    do {
                        try self.managedObjectContext.save()
                    } catch {
                        return
                    }
                    
                    
                   
                    self.showSongAddedAlert = true
                }) {
                    HStack {
                        Image(systemName: "plus")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.blue)
                        Text("Add Song to My Music")
                            .font(.system(size: 16))
                            .foregroundColor(.blue)
                    }
                }
            }
            
        }   // End of Form
        .navigationBarTitle(Text("Song Details"), displayMode: .inline)
        .alert(isPresented: $showSongAddedAlert, content: { self.songAddedAlert })
        .font(.system(size: 14))    // Set font and size for all Text views in the Form
       
    }   // End of body
        
    var songAddedAlert: Alert {
            Alert(title: Text("Song Added!"),
                  message: Text("This song is added to my music."),
                  dismissButton: .default(Text("OK")) )
    }
    
}
