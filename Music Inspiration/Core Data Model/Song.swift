//
//  Song.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 4/26/21.
//

import Foundation
import CoreData

public class Song: NSManagedObject, Identifiable {
 
    @NSManaged public var albumName: String?
    @NSManaged public var artistName: String?
    @NSManaged public var genre: String?
    @NSManaged public var rating: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var songName: String?
    @NSManaged public var photo: Photo?
}

extension Song {
    
    static func allSongsFetchRequest() -> NSFetchRequest<Song> {
       
        let request: NSFetchRequest<Song> = Song.fetchRequest() as! NSFetchRequest<Song>
        /*
         List the songs in alphabetical order with respect to artistName;
         If artistName is the same, then sort with respect to songName.
         */
        request.sortDescriptors = [
            // Primary sort key: artistName
            NSSortDescriptor(key: "artistName", ascending: true),
            // Secondary sort key: songName
            NSSortDescriptor(key: "songName", ascending: true)
        ]
       
        return request
    }
    
    static func filteredSongsFetchRequest(searchCategory: String, searchQuery: String) -> NSFetchRequest<Song> {
       
        let fetchRequest = NSFetchRequest<Song>(entityName: "Song")
       
        /*
         List the found songs in alphabetical order with respect to artistName;
         If artistName is the same, then sort with respect to songName.
         */
        fetchRequest.sortDescriptors = [
            // Primary sort key: artistName
            NSSortDescriptor(key: "artistName", ascending: true),
            // Secondary sort key: songName
            NSSortDescriptor(key: "songName", ascending: true)
        ]
       
        // Case insensitive search [c] for searchQuery under each category
        switch searchCategory {
        case "Album Name":
            fetchRequest.predicate = NSPredicate(format: "albumName CONTAINS[c] %@", searchQuery)
        case "Artist Name":
            fetchRequest.predicate = NSPredicate(format: "artistName CONTAINS[c] %@", searchQuery)
        case "Song Name":
            fetchRequest.predicate = NSPredicate(format: "songName CONTAINS[c] %@", searchQuery)
        case "Genre":
            fetchRequest.predicate = NSPredicate(format: "genre CONTAINS[c] %@", searchQuery)
        case "Rating":
            fetchRequest.predicate = NSPredicate(format: "rating CONTAINS[c] %@", searchQuery)
        case "Compound":
            let components = searchQuery.components(separatedBy: "AND")
            let genreQuery = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let ratingQuery = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
 
            fetchRequest.predicate = NSPredicate(format: "genre CONTAINS[c] %@ AND rating CONTAINS[c] %@", genreQuery, ratingQuery)
        default:
            print("Search category is out of range")
        }
       
        return fetchRequest
    }
}
