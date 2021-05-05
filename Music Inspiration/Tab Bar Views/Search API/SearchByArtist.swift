//
//  SearchByArtist.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 5/4/21.
//

import SwiftUI

struct SearchByArtist: View {
    
    @State private var searchFieldValueArtist = ""
    @State private var searchFieldValueSong = ""
    @State private var showMissingInputDataAlert = false
    @State private var searchCompleted = false
    @State private var showProgressView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            Form {
                Section(header: Text("Enter Artist Name")) {
                    HStack {
                        TextField("Enter artist name", text: $searchFieldValueArtist)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.default)
                            .disableAutocorrection(true)
                        
                        // Button to clear the text field
                        Button(action: {
                            self.searchFieldValueArtist = ""
                            self.showMissingInputDataAlert = false
                            self.searchCompleted = false
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }   // End of HStack
                        .frame(minWidth: 300, maxWidth: 500)
                        .alert(isPresented: $showMissingInputDataAlert, content: { self.missingInputDataAlert })
                    
                }   // End of Section
                
                Section(header: Text("Enter Song Name")) {
                    HStack {
                        TextField("Enter song name", text: $searchFieldValueSong)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.default)
                            .disableAutocorrection(true)
                        
                        // Button to clear the text field
                        Button(action: {
                            self.searchFieldValueSong = ""
                            self.showMissingInputDataAlert = false
                            self.searchCompleted = false
                        }) {
                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                        }
                    }   // End of HStack
                        .frame(minWidth: 300, maxWidth: 500)
                        .alert(isPresented: $showMissingInputDataAlert, content: { self.missingInputDataAlert })
                    
                }   // End of Section
                
                Section(header: Text("Search Song by Artist and Song Name")) {
                    HStack {
                        Button(action: {
                            if self.inputDataValidated() {
                                
                                self.showProgressView = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    /*
                                     Execute the following code after 0.1 second of delay
                                     so that they are not executed during the view update.
                                     */
                                    self.searchApi()
                                    self.showProgressView = false
                                    self.searchCompleted = true
                                }
                            } else {
                                self.showMissingInputDataAlert = true
                            }
                        }) {
                            Text(self.searchCompleted ? "Search Completed" : "Search")
                        }
                        .frame(width: 240, height: 36, alignment: .center)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(Color.black, lineWidth: 1)
                        )
                    }   // End of HStack
                }
                
                if showProgressView {
                    Section {
                        ProgressView()
                            // Style defined in ProgressViewStyle.swift
                            .progressViewStyle(DarkBlueShadowProgressViewStyle())
                    }
                }
                
                if searchCompleted {
                    Section(header: Text("Show Details of the Song Found")) {
                        NavigationLink(destination: showSearchResults) {
                            HStack {
                                Image(systemName: "list.bullet")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                    .foregroundColor(.blue)
                                Text("Show Song Details")
                                    .font(.system(size: 16))
                            }
                        }
                        .frame(minWidth: 300, maxWidth: 500)
                    }
                }
                
            }   // End of Form
                .navigationBarTitle(Text("Search Songs"), displayMode: .inline)
                .onAppear() {
                    self.searchCompleted = false
                }
                
            }   // End of ZStack
            
        }   // End of NavigationView
        // Use single column navigation view for iPhone and iPad
        .navigationViewStyle(StackNavigationViewStyle())
        
    }   // End of body
    
    /*
    ------------------
    MARK: - Search API
    ------------------
    */
    func searchApi() {
        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        let songTrimmed = self.searchFieldValueSong.trimmingCharacters(in: .whitespacesAndNewlines)
        let artistTrimmed = self.searchFieldValueArtist.trimmingCharacters(in: .whitespacesAndNewlines)
        
       getApiDataSongAndArtist(songN: songTrimmed, artistN: artistTrimmed)
    }
    
    /*
    ---------------------------
    MARK: - Show Search Results
    ---------------------------
    */
    var showSearchResults: some View {
        
        // Global variable nationalParkFound is given in SearchByNameApiData.swift
        if songFound.albumName.isEmpty {
            return AnyView(notFoundMessage)
        }
        
        return AnyView(SearchByArtistResults(ma: songFound))
    }
    
    /*
    ------------------------------
    MARK: - Park Not Found Message
    ------------------------------
    */
    var notFoundMessage: some View {
        
        ZStack {    // Color Background to Ivory color
            Color(red: 1.0, green: 1.0, blue: 240/255).edgesIgnoringSafeArea(.all)
            
            VStack {
                Image(systemName: "exclamationmark.triangle")
                    .imageScale(.large)
                    .font(Font.title.weight(.medium))
                    .foregroundColor(.red)
                    .padding()
                Text("No Song Found!\n\nThe API did not return a song under the entered song name \(self.searchFieldValueSong) and artist name \(self.searchFieldValueArtist). Please make sure that you enter a valid song and artist name as required by the API.")
                    .fixedSize(horizontal: false, vertical: true)   // Allow lines to wrap around
                    .multilineTextAlignment(.center)
                    .padding()
            } // End of VStack
        
        } // End of ZStack
    }
    
    /*
     --------------------------------
     MARK: - Missing Input Data Alert
     --------------------------------
     */
    var missingInputDataAlert: Alert {
        Alert(title: Text("The Search Field is Empty!"),
              message: Text("Please enter song and artist name to search for a song!"),
              dismissButton: .default(Text("OK")))
        /*
         Tapping OK resets @State var showMissingInputDataAlert to false.
         */
    }
    
    /*
     -----------------------------
     MARK: - Input Data Validation
     -----------------------------
     */
    func inputDataValidated() -> Bool {
        
        // Remove spaces, if any, at the beginning and at the end of the entered search query string
        let queryTrimmed1 = self.searchFieldValueArtist.trimmingCharacters(in: .whitespacesAndNewlines)
        let queryTrimmed2 = self.searchFieldValueSong.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if queryTrimmed1.isEmpty || queryTrimmed2.isEmpty {
            return false
        }
        return true
    }
    
}

struct SearchByName_Previews: PreviewProvider {
    static var previews: some View {
        SearchByArtist()
    }
}
