//
//  MusicData.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 4/27/21.
//

import SwiftUI
import CoreData

// Array of MusicAlbum structs for use only in this file
fileprivate var musicAlbumStructList = [MusicAlbum]()
 
/*
 ***********************************
 MARK: - Create Music Album Database
 ***********************************
 */
public func createMusicAlbumDatabase() {
 
    musicAlbumStructList = decodeJsonFileIntoArrayOfStructs(fullFilename: "music.json", fileLocation: "Main Bundle")
   
    populateDatabase()
}
 
/*
*********************************************
MARK: - Populate Database If Not Already Done
*********************************************
*/
func populateDatabase() {
   
    // ❎ Get object reference of CoreData managedObjectContext from the persistent container
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    //----------------------------
    // ❎ Define the Fetch Request
    //----------------------------
    let fetchRequest = NSFetchRequest<Song>(entityName: "Song")
    fetchRequest.sortDescriptors = [
        // Primary sort key: artistName
        NSSortDescriptor(key: "artistName", ascending: true),
        // Secondary sort key: songNameA
        NSSortDescriptor(key: "songName", ascending: true)
    ]
   
    var listOfAllSongEntitiesInDatabase = [Song]()
   
    do {
        //-----------------------------
        // ❎ Execute the Fetch Request
        //-----------------------------
        listOfAllSongEntitiesInDatabase = try managedObjectContext.fetch(fetchRequest)
    } catch {
        print("Populate Database Failed!")
        return
    }
   
    if listOfAllSongEntitiesInDatabase.count > 0 {
        // Database has already been populated
        print("Database has already been populated!")
        return
    }
   
    
   
    for album in musicAlbumStructList {
        /*
         =====================================================
         Create an instance of the Song Entity and dress it up
         =====================================================
        */
       
        // ❎ Create an instance of the Song entity in CoreData managedObjectContext
        let songEntity = Song(context: managedObjectContext)
       
        // ❎ Dress it up by specifying its attributes
        songEntity.artistName = album.artistName
        songEntity.albumName = album.albumName
        songEntity.songName = album.songName
        songEntity.genre = album.genre
        songEntity.releaseDate = album.releaseDate
        songEntity.rating = album.rating
 
        /*
         ======================================================
         Create an instance of the Photo Entity and dress it up
         ======================================================
         */
       
        // ❎ Create an instance of the Photo Entity in CoreData managedObjectContext
        let photoEntity = Photo(context: managedObjectContext)
       
        // Obtain the album cover photo image from Assets.xcassets as UIImage
        let photoUIImage = UIImage(named: album.coverPhotoFilename)
       
        // Convert photoUIImage to data of type Data (Binary Data) in JPEG format with 100% quality
        let photoData = photoUIImage?.jpegData(compressionQuality: 1.0)
       
        // Assign photoData to Core Data entity attribute of type Data (Binary Data)
        photoEntity.albumCoverPhoto = photoData!
       
        /*
         ==============================
         Establish Entity Relationships
         ==============================
        */
       
        // ❎ Establish Relationship between entities Song and Photo
        songEntity.photo = photoEntity
        photoEntity.song = songEntity
       
        /*
         ==================================
         Save Changes to Core Data Database
         ==================================
        */
       
        // ❎ CoreData Save operation
        do {
            try managedObjectContext.save()
        } catch {
            return
        }
       
    }   // End of for loop
 
}
