//
//  MusicStruct.swift
//  Music Inspiration
//
//  Created by Karan Nibber on 4/27/21.
//

import SwiftUI

import Foundation
 
struct MusicAlbum: Decodable, Identifiable{
    var id: String
    var artistName: String
    var albumName: String
    var songName: String
    var genre: String
    var rating: String
    var releaseDate: String
    var coverPhotoFilename: String
    var musicVideID: String
}
