//
//  SearchDatabase.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 4/27/21.
//

import SwiftUI
import CoreData
 
// Global Variables
var searchCategory = ""
var searchQuery = ""
 
struct SearchDatabase: View {
   
    let searchCategoriesList = ["Compound", "Album Name", "Artist Name", "Song Name", "Genre", "Rating"]
   
    @State private var selectedSearchCategoryIndex = 2
    @State private var searchFieldValue = ""
    @State private var genreSearchQuery = ""
    @State private var ratingSearchQuery = ""
   
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select a Search Category")) {
                  
                    Picker("", selection: $selectedSearchCategoryIndex) {
                        ForEach(0 ..< searchCategoriesList.count, id: \.self) {
                            Text(self.searchCategoriesList[$0])
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
                  
                }
                if self.selectedSearchCategoryIndex == 0 {
                    Section(header: Text("Search Genre AND Rating")) {
                        VStack {
                            HStack {
                                TextField("Enter Genre Search Query", text: $genreSearchQuery)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .frame(minWidth: 260, maxWidth: 500, alignment: .leading)
                              
                                // Button to clear the text field
                                Button(action: {
                                    self.genreSearchQuery = ""
                                }) {
                                    Image(systemName: "clear")
                                        .imageScale(.medium)
                                        .font(Font.title.weight(.regular))
                                }
                            }   // End of HStack
                           
                            Text("AND")
                           
                            HStack {
                                TextField("Enter Rating Search Query", text: $ratingSearchQuery)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .frame(minWidth: 260, maxWidth: 500, alignment: .leading)
                              
                                // Button to clear the text field
                                Button(action: {
                                    self.ratingSearchQuery = ""
                                }) {
                                    Image(systemName: "clear")
                                        .imageScale(.medium)
                                        .font(Font.title.weight(.regular))
                                }
                            }   // End of HStack
                           
                        }   // End of VStack
                    }
                }
                if self.selectedSearchCategoryIndex != 0 {
                    Section(header: Text("Search Query under Selected Category")) {
                        HStack {
                            TextField("Enter Search Query", text: $searchFieldValue)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .frame(minWidth: 260, maxWidth: 500, alignment: .leading)
                          
                            // Button to clear the text field
                            Button(action: {
                                self.searchFieldValue = ""
                            }) {
                                Image(systemName: "clear")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                            }
                        }   // End of HStack
                    }
                }
                    
                Section(header: Text("Show Search Results")) {
                    NavigationLink(destination: showSearchResults()) {
                        HStack {
                            Image(systemName: "list.bullet")
                            Text("Show Search Results")
                                .font(.headline)
                        }
                    }
                }
           
            }   // End of Form
            .navigationBarTitle(Text("Search Core Data Database"), displayMode: .inline)
           
        }   // End of NavigationView
        // Use single column navigation view for iPhone and iPad
        .navigationViewStyle(StackNavigationViewStyle())
    }
   
    func showSearchResults() -> some View {
 
        if selectedSearchCategoryIndex == 0 {
            // Compound Search category
            if (genreSearchQuery.isEmpty) || (ratingSearchQuery.isEmpty) {
                return AnyView(missingSearchQueryMessage)
            }
            searchCategory = "Compound"
            searchQuery = genreSearchQuery + "AND" + ratingSearchQuery
        } else {
            let queryTrimmed = self.searchFieldValue.trimmingCharacters(in: .whitespacesAndNewlines)
            if (queryTrimmed.isEmpty) {
                return AnyView(missingSearchQueryMessage)
            }
            searchCategory = self.searchCategoriesList[self.selectedSearchCategoryIndex]
            searchQuery = self.searchFieldValue
        }
       
        return AnyView(SearchResultsList())
    }
   
    var missingSearchQueryMessage: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.red)
                .padding()
            Text("Search Query Missing!\nPlease enter a search query to be able to search the database!")
                .fixedSize(horizontal: false, vertical: true)   // Allow lines to wrap around
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color(red: 1.0, green: 1.0, blue: 240/255))     // Ivory color
    }
 
}
 
struct SearchDatabase_Previews: PreviewProvider {
    static var previews: some View {
        SearchDatabase()
    }
}
