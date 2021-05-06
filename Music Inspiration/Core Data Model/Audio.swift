//
//  Audio.swift
//  Music Inspiration
//
//  Created by Karan Nibber on 5/5/21.
//

import Foundation
import CoreData

/*
 🔴 Set Current Product Module:
    In xcdatamodeld editor, select Audio, show Data Model Inspector, and
    select Current Product Module from Module menu.
 🔴 Turn off Auto Code Generation:
    In xcdatamodeld editor, select Audio, show Data Model Inspector, and
    select Manual/None from Codegen menu.
*/

// ❎ CoreData Audio entity public class
public class Audio: NSManagedObject, Identifiable {

    @NSManaged public var voiceRecording: Data?     // Binary data of recorded voice
    @NSManaged public var song: Song?
}
