//
//  SongList.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 4/27/21.
//

import SwiftUI
import CoreData
 
struct SongsList: View {
   
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
   
    // ❎ CoreData FetchRequest returning all Song entities in the database
    @FetchRequest(fetchRequest: Song.allSongsFetchRequest()) var allSongs: FetchedResults<Song>
   
    // ❎ Refresh this view upon notification that the managedObjectContext completed a save.
    // Upon refresh, @FetchRequest is re-executed fetching all Song entities with all the changes.
    @EnvironmentObject var userData: UserData
   
    var body: some View {
        NavigationView {
            List {
                /*
                 Each NSManagedObject has internally assigned unique ObjectIdentifier
                 used by ForEach to display the Songs in a dynamic scrollable list.
                 */
                ForEach(self.allSongs) { aSong in
                    NavigationLink(destination: SongDetails(song: aSong)) {
                        SongItem(song: aSong)
                    }
                }
                .onDelete(perform: delete)
               
            }   // End of List
            .navigationBarTitle(Text("Favorites"), displayMode: .inline)
           
            // Place the Edit button on left and Add (+) button on right of the navigation bar
            .navigationBarItems(leading: EditButton(), trailing:
                NavigationLink(destination: AddSong()) {
                    Image(systemName: "plus")
                })
           
        }   // End of NavigationView
            // Use single column navigation view for iPhone and iPad
            .navigationViewStyle(StackNavigationViewStyle())
    }
   
    /*
     ----------------------------
     MARK: - Delete Selected Song
     ----------------------------
     */
    func delete(at offsets: IndexSet) {
       
        let songToDelete = self.allSongs[offsets.first!]
       
        // ❎ CoreData Delete operation
        self.managedObjectContext.delete(songToDelete)
 
        // ❎ CoreData Save operation
        do {
          try self.managedObjectContext.save()
        } catch {
          print("Unable to delete selected song!")
        }
    }
 
}
 
struct SongsList_Previews: PreviewProvider {
    static var previews: some View {
        SongsList()
    }
}
