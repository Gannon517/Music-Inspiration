//
//  SearchResultsList.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 4/27/21.
//

import SwiftUI
 
struct SearchResultsList: View {
   
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
   
    // ❎ CoreData FetchRequest returning filtered Song entities from the database
    @FetchRequest(fetchRequest: Song.filteredSongsFetchRequest(searchCategory: searchCategory, searchQuery: searchQuery)) var filteredSongs: FetchedResults<Song>
   
    var body: some View {
        if self.filteredSongs.isEmpty {
            SearchResultsEmpty()
        } else {
            List {
                /*
                 Each NSManagedObject has internally assigned unique ObjectIdentifier
                 used by ForEach to display the Songs in a dynamic scrollable list.
                 */
                ForEach(self.filteredSongs) { aSong in
                    NavigationLink(destination: SearchResultDetails(song: aSong)) {
                        SearchResultItem(song: aSong)
                    }
                }
               
            }   // End of List
            .navigationBarTitle(Text("Songs Found"), displayMode: .inline)
        }   // End of if
    }
}
 
struct SearchResultsList_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsList()
    }
}
