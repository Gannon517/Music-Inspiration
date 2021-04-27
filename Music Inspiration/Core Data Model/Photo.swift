//
//  Photo.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 4/26/21.
//

import Foundation
import CoreData

public class Photo: NSManagedObject, Identifiable {
 
    @NSManaged public var albumCoverPhoto: Data?
    @NSManaged public var song: Song?
}
