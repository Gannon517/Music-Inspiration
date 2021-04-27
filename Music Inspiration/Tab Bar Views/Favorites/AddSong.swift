//
//  AddSong.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 4/27/21.
//

import SwiftUI
import CoreData
 
struct AddSong: View {
   
    // Enable this View to be dismissed to go back when the Save button is tapped
    @Environment(\.presentationMode) var presentationMode
   
    // ❎ CoreData managedObjectContext reference
    @Environment(\.managedObjectContext) var managedObjectContext
   
    @State private var showSongAddedAlert = false
    @State private var showInputDataMissingAlert = false
   
    // Song Entity
    @State private var artistName = ""
    @State private var albumName = ""
    @State private var songName = ""
    @State private var genre = ""
    @State private var releaseDate = Date()
    @State private var ratingIndex = 2  // Default: "Average"
   
    // Album Cover Photo
    @State private var showImagePicker = false
    @State private var photoImageData: Data? = nil
    @State private var photoTakeOrPickIndex = 1     // Pick from Photo Library
   
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
                    TextField("Enter artist name", text: $artistName)
                }
                Section(header: Text("Album Name")) {
                    TextField("Enter album name", text: $albumName)
                }
                Section(header: Text("Song Name")) {
                    TextField("Enter song name", text: $songName)
                }
                Section(header: Text("Genre(s)")) {
                    TextField("Enter Genre(s)", text: $genre)
                }
                Section(header: Text("Release Date")) {
                    DatePicker(
                        selection: $releaseDate,
                        in: dateClosedRange,
                        displayedComponents: .date) {
                            Text("Release Date")
                        }
                }
            }   // End of Group
            .alert(isPresented: $showSongAddedAlert, content: { self.songAddedAlert })
            Group {
                Section(header: Text("My Rating")) {
                    Picker("", selection: $ratingIndex) {
                        ForEach(0 ..< ratingChoices.count, id: \.self) {
                            Text(self.ratingChoices[$0])
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(minWidth: 300, maxWidth: 500, alignment: .leading)
                }
                Section(header: Text("Add Album Cover Photo")) {
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
                    }   // End of VStack
                }
                Section(header: Text("Album Cover Photo")) {
                    photoImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100.0, height: 100.0)
                    Spacer()
                }
            }   // End of Group
 
        }   // End of Form
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .autocapitalization(.words)
        .disableAutocorrection(true)
        .font(.system(size: 14))
        .alert(isPresented: $showInputDataMissingAlert, content: { self.inputDataMissingAlert })
        .navigationBarTitle(Text("Add Song"), displayMode: .inline)
        .navigationBarItems(trailing:
            Button(action: {
                if self.inputDataValidated() {
                    self.saveNewSong()
                    self.showSongAddedAlert = true
                } else {
                    self.showInputDataMissingAlert = true
                }
            }) {
                Text("Save")
            })
       
        .sheet(isPresented: self.$showImagePicker) {
            /*
             🔴 We pass $showImagePicker and $photoImageData with $ sign into PhotoCaptureView
             so that PhotoCaptureView can change them. The @Binding keywork in PhotoCaptureView
             indicates that the input parameter is passed by reference and is changeable (mutable).
             */
            PhotoCaptureView(showImagePicker: self.$showImagePicker,
                             photoImageData: self.$photoImageData,
                             cameraOrLibrary: self.photoTakeOrPickChoices[self.photoTakeOrPickIndex])
        }
       
    }   // End of body
   
    var photoImage: Image {
       
        if let imageData = self.photoImageData {
            // The public function is given in UtilityFunctions.swift
            let imageView = getImageFromBinaryData(binaryData: imageData, defaultFilename: "AlbumCoverDefaultImage")
            return imageView
        } else {
            return Image("AlbumCoverDefaultImage")
        }
    }
   
    /*
     ------------------------
     MARK: - Song Added Alert
     ------------------------
     */
    var songAddedAlert: Alert {
        Alert(title: Text("Song Added!"),
              message: Text("New song is added to your favorites list."),
              dismissButton: .default(Text("OK")) {
                  // Dismiss this View and go back
                  self.presentationMode.wrappedValue.dismiss()
            })
    }
   
    /*
     --------------------------------
     MARK: - Input Data Missing Alert
     --------------------------------
     */
    var inputDataMissingAlert: Alert {
        Alert(title: Text("Missing Input Data!"),
              message: Text("Required Data: artist name, album name, song name, and genre."),
              dismissButton: .default(Text("OK")) )
    }
   
    func inputDataValidated() -> Bool {
        /**
        @State private var artistName = ""
        @State private var albumName = ""
        @State private var songName = ""
        @State private var genre = "" */
        if artistName.isEmpty || albumName.isEmpty || songName.isEmpty || genre.isEmpty {
            return false
        }
        return true
    }
    
   
    /*
     ---------------------
     MARK: - Save New Song
     ---------------------
     */
    func saveNewSong() {
       
        // Instantiate a DateFormatter object
        let dateFormatter = DateFormatter()
       
        // Set the date format to yyyy-MM-dd
        dateFormatter.dateFormat = "yyyy-MM-dd"
       
        // Obtain DatePicker's selected date, format it as yyyy-MM-dd, and convert it to String
        let releaseDateString = dateFormatter.string(from: self.releaseDate)
       
        /*
         =====================================================
         Create an instance of the Song Entity and dress it up
         =====================================================
        */
       
        // ❎ Create a new Song entity in CoreData managedObjectContext
        let newSong = Song(context: self.managedObjectContext)
       
        // ❎ Dress up the new Song entity
        newSong.artistName = self.artistName
        newSong.albumName = self.albumName
        newSong.songName = self.songName
        newSong.genre = self.genre
        newSong.releaseDate = releaseDateString
        newSong.rating = self.ratingChoices[ratingIndex]
       
        /*
         ======================================================
         Create an instance of the Photo Entity and dress it up
         ======================================================
        */
       
        // ❎ Create a new Photo entity in CoreData managedObjectContext
        let newPhoto = Photo(context: self.managedObjectContext)
       
        // ❎ Dress up the new Photo entity
        if let imageData = self.photoImageData {
            newPhoto.albumCoverPhoto = imageData
        } else {
            // Obtain the album cover default image from Assets.xcassets as UIImage
            let photoUIImage = UIImage(named: "AlbumCoverDefaultImage")
           
            // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
            let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
           
            // Assign photoData to Core Data entity attribute of type Data (Binary Data)
            newPhoto.albumCoverPhoto = photoData!
        }
       
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
       
    }   // End of function
 
}
