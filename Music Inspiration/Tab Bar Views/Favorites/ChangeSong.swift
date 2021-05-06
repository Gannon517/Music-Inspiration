//
//  ChangeSong.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 4/27/21.
//
//  Copyright © 2021 Michael Gannon and Gurkaran Nibber. All rights reserved.
//

import SwiftUI
import CoreData
 
struct ChangeSong: View {
   
    // ❎ Input parameter: Core Data Song Entity instance reference
    let song: Song
   
    // Enable this View to be dismissed to go back when the Save button is tapped
    @Environment(\.presentationMode) var presentationMode
   
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
   
    @State private var showChangesSavedAlert = false
   
    // Song Entity
    @State private var artistName = ""
    @State private var albumName = ""
    @State private var songName = ""
    @State private var genre = ""
    @State private var link = ""
    @State private var releaseDate = Date()
    @State private var ratingIndex = -1
   
    // Song Entity Changes
    @State private var changeArtistName = false
    @State private var changeAlbumName = false
    @State private var changeSongName = false
    @State private var changeGenre = false
    @State private var changeReleaseDate = false
    @State private var changeRating = false
    @State private var changeCoverPhoto = false
    @State private var changeLink = false
   
    // Album Cover Photo
    @State private var showImagePicker = false
    @State private var photoImageData: Data? = nil
    @State private var photoTakeOrPickIndex = 0     // Take using camera
   
    let ratingChoices = ["Excellent", "Good", "Average", "Fair", "Poor"]
    var photoTakeOrPickChoices = ["Camera", "Photo Library"]
   
    var dateClosedRange: ClosedRange<Date> {
        // Set minimum date to 20 years earlier than the current year
        let minDate = Calendar.current.date(byAdding: .year, value: -20, to: Date())!
       
        // Set maximum date to 2 years later than the current year
        let maxDate = Calendar.current.date(byAdding: .year, value: 2, to: Date())!
        return minDate...maxDate
    }
   
    var body: some View {
        Form {
            Group {
                Section(header: Text("Artist Name")) {
                    artistNameSubview
                }
                Section(header: Text("Album Name")) {
                    albumNameSubview
                }
                Section(header: Text("Song Name")) {
                    songNameSubview
                }
                Section(header: Text("Genre(s)")) {
                    genreSubview
                }
                Section(header: Text("Apple Music Link")) {
                    musicLinkSubview
                }
            }
            Group {
                Section(header: Text("Release Date")) {
                    releaseDateSubview
                }
                if self.changeReleaseDate {
                    Section(header: Text("Change Release Date")) {
                        changeReleaseDateSubview
                    }
                }
               
                Section(header: Text("My Rating")) {
                    ratingSubview
                }
                if self.changeRating {
                    Section(header: Text("Change Rating")) {
                        changeRatingSubview
                    }
                }
               
                Section(header: Text("Album Cover Photo")) {
                    albumCoverPhotoImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100.0, height: 100.0)
                }
                Section(header: Text("Change Album Cover Photo")) {
                    albumCoverPhotoSubview
                }
            }
 
        }   // End of Form
        .font(.system(size: 14))
        .alert(isPresented: $showChangesSavedAlert, content: { self.changesSavedAlert })
        .disableAutocorrection(true)
        .autocapitalization(.words)
        .navigationBarTitle(Text("Change Song"), displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                if self.changesMade() {
                    self.saveChanges()
                }
                // Show changes saved or no changes saved alert
                self.showChangesSavedAlert = true
            }) {
                Text("Save")
            })
        .sheet(isPresented: self.$showImagePicker) {
            PhotoCaptureView(showImagePicker: self.$showImagePicker,
                             photoImageData: self.$photoImageData,
                             cameraOrLibrary: self.photoTakeOrPickChoices[self.photoTakeOrPickIndex])
        }
       
    }   // End of body
   
    var artistNameSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(song.artistName ?? "")
                    Button(action: {
                        self.changeArtistName.toggle()
                    }) {
                        Image(systemName: self.changeArtistName ? "xmark.circle":"pencil.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                }
                if self.changeArtistName {
                    TextField("Change artist name", text: $artistName)
                         .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        )
    }
   
    var albumNameSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(song.albumName ?? "")
                    Button(action: {
                        self.changeAlbumName.toggle()
                    }) {
                        Image(systemName: self.changeAlbumName ? "xmark.circle":"pencil.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                }
                if self.changeAlbumName {
                    TextField("Change album name", text: $albumName)
                         .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        )
    }
   
    var songNameSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(song.songName ?? "")
                    Button(action: {
                        self.changeSongName.toggle()
                    }) {
                        Image(systemName: self.changeSongName ? "xmark.circle":"pencil.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                }
                if self.changeSongName {
                    TextField("Change song name", text: $songName)
                         .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        )
    }
   
    var genreSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(song.genre ?? "")
                    Button(action: {
                        self.changeGenre.toggle()
                    }) {
                        Image(systemName: self.changeGenre ? "xmark.circle":"pencil.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                }
                if self.changeGenre {
                    TextField("Enter New Genre(s)", text: $genre)
                         .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        )
    }
    
    var musicLinkSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    Text(song.musicVideoID ?? "")
                    Button(action: {
                        self.changeLink.toggle()
                    }) {
                        Image(systemName: self.changeLink ? "xmark.circle":"pencil.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                    if self.changeGenre {
                        TextField("Enter New Youtube Link", text: $link)
                             .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
            }
        )
    }
   
    var releaseDateSubview: some View {
        return AnyView(
            HStack {
                Text(song.releaseDate ?? "")
                Button(action: {
                    self.changeReleaseDate.toggle()
                }) {
                    Image(systemName: self.changeReleaseDate ? "xmark.circle":"pencil.circle")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
            }
        )
    }
   
    var changeReleaseDateSubview: some View {
        return AnyView(
            DatePicker(
                selection: $releaseDate,
                in: dateClosedRange,
                displayedComponents: .date,
                label: { Text("New Release Date") }
            )
        )
    }
   
    var ratingSubview: some View {
        return AnyView(
            HStack {
                Text(song.rating ?? "")
                Button(action: {
                    self.changeRating.toggle()
                }) {
                    Image(systemName: self.changeRating ? "xmark.circle":"pencil.circle")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
            }
        )
    }
   
    var changeRatingSubview: some View {
        return AnyView(
            Picker("", selection: $ratingIndex) {
                ForEach(0 ..< ratingChoices.count, id: \.self) {
                    Text(self.ratingChoices[$0])
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
        )
    }
   
    var albumCoverPhotoSubview: some View {
        return AnyView(
            VStack {
                HStack {
                    // This public function is given in UtilityFunctions.swift
                    if (song.photo!.photoUrl == ""){
                        getImageFromBinaryData(binaryData: song.photo!.albumCoverPhoto!, defaultFilename: "AlbumCoverDefaultImage")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100.0, height: 100.0)
                    }
                    else{
                        getImageFromUrl(url: song.photo!.photoUrl ?? "", defaultFilename: "AlbumCoverDefaultImage")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100.0, height: 100.0)
                    }
                   
                    Button(action: {
                        self.changeCoverPhoto.toggle()
                    }) {
                        Image(systemName: self.changeCoverPhoto ? "xmark.circle":"pencil.circle")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                    }
                }   // End of HStack
               
                if self.changeCoverPhoto {
                    VStack {
                        Picker("Take or Pick Photo", selection: $photoTakeOrPickIndex) {
                            ForEach(0 ..< photoTakeOrPickChoices.count, id: \.self) {
                                Text(self.photoTakeOrPickChoices[$0])
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                       
                        Button(action: {
                            self.showImagePicker = true
                        }) {
                            Text("Get Photo")
                                .padding()
                        }
                        Spacer()
                    }   // End of VStack
                }   // End of If statement
            }   // End of VStack
        )
    }
   
    var albumCoverPhotoImage: Image {
       
        if let imageData = self.photoImageData {
            let imageView = // This public function is given in UtilityFunctions.swift
                getImageFromBinaryData(binaryData: imageData, defaultFilename: "AlbumCoverDefaultImage")
            return imageView
        } else {
            return Image("AlbumCoverDefaultImage")
        }
    }
   
    /*
     ---------------------
     MARK: - Alert Message
     ---------------------
     */
    var changesSavedAlert: Alert {
       
        if changesMade() {
            return Alert(title: Text("Changes Saved!"),
              message: Text("Your changes have been successfully saved to the database."),
              dismissButton: .default(Text("OK")) {
                  self.presentationMode.wrappedValue.dismiss()
                })
        }
 
        return Alert(title: Text("No Changes Saved!"),
          message: Text("You did not make any changes!"),
          dismissButton: .default(Text("OK")) {
              self.presentationMode.wrappedValue.dismiss()
            })
    }
   
    /*
     ---------------------------
     MARK: - Changes Made or Not
     ---------------------------
     */
    func changesMade() -> Bool {
       
        if self.artistName.isEmpty && self.albumName.isEmpty && self.songName.isEmpty && self.genre.isEmpty && self.ratingIndex == -1 && self.photoImageData == nil {
            return false
        }
        return true
    }
   
    /*
     -------------------------
     MARK: - Save Song Changes
     -------------------------
     */
    func saveChanges() {
        // Change Song attributes if updated
       
        if self.artistName != "" {
            song.artistName = self.artistName
        }
        if self.albumName != "" {
            song.albumName = self.albumName
        }
        if self.songName != "" {
            song.songName = self.songName
        }
        if self.genre != "" {
            song.genre = self.genre
        }
        if self.link != "" {
            song.musicVideoID = self.link
        }
        if self.releaseDate != Date() {
            // Instantiate a DateFormatter object
            let dateFormatter = DateFormatter()
           
            // Set the date format to yyyy-MM-dd
            dateFormatter.dateFormat = "yyyy-MM-dd"
           
            // Obtain DatePicker's selected date, format it as yyyy-MM-dd, and convert it to String
            let releaseDateString = dateFormatter.string(from: self.releaseDate)
           
            song.releaseDate = releaseDateString
        }
        if self.ratingIndex != -1 {
            song.rating = self.ratingChoices[ratingIndex]
        }
        if self.photoImageData != nil {
            if let imageData = self.photoImageData {
                song.photo!.albumCoverPhoto! = imageData
            } else {
                // Obtain the album cover default image from Assets.xcassets as UIImage
                let photoUIImage = UIImage(named: "AlbumCoverDefaultImage")
               
                // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
                let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
               
                // Assign photoData to Core Data entity attribute of type Data (Binary Data)
                song.photo!.albumCoverPhoto! = photoData!
            }
        }
       
        /*
         ==================================
         Save Changes to Core Data Database
         ==================================
        */
       
        // ❎ CoreData Save operation
        do {
            try self.managedObjectContext.save()
        } catch {
            return
        }
       
    }   // End of function
   
}
