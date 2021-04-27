//
//  UtiliyFunctions.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 4/27/21.
//

import Foundation
import SwiftUI
 
// Global constant
let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
 
/*
*************************************************
MARK: - Decode JSON file into an Array of Structs
*************************************************
*/
public func decodeJsonFileIntoArrayOfStructs<T: Decodable>(fullFilename: String, fileLocation: String, as type: T.Type = T.self) -> T {
   
    var jsonFileData: Data?
    var jsonFileUrl: URL?
    var arrayOfStructs: T?
   
    if fileLocation == "Main Bundle" {
        // Obtain URL of the JSON file in main bundle
        let urlOfJsonFileInMainBundle: URL? = Bundle.main.url(forResource: fullFilename, withExtension: nil)
       
        if let mainBundleUrl = urlOfJsonFileInMainBundle {
            jsonFileUrl = mainBundleUrl
        } else {
            print("JSON file \(fullFilename) does not exist in main bundle!")
        }
    } else {
        // Obtain URL of the JSON file in document directory on user's device
        let urlOfJsonFileInDocumentDirectory: URL? = documentDirectory.appendingPathComponent(fullFilename)
       
        if let docDirectoryUrl = urlOfJsonFileInDocumentDirectory {
            jsonFileUrl = docDirectoryUrl
        } else {
            print("JSON file \(fullFilename) does not exist in document directory!")
        }
    }
    
    do {
        jsonFileData = try Data(contentsOf: jsonFileUrl!)
    } catch {
        print("Unable to obtain JSON file \(fullFilename) content!")
    }
   
    do {
        // Instantiate an object from the JSONDecoder class
        let decoder = JSONDecoder()
       
        // Use the decoder object to decode JSON objects into an array of structs of type T
        arrayOfStructs = try decoder.decode(T.self, from: jsonFileData!)
    } catch {
        print("Unable to decode JSON file \(fullFilename)!")
    }
   
    // Return the array of structs of type T
    return arrayOfStructs!
}
 
/*
**********************************
MARK: - Get Image from Binary Data
**********************************
*/
public func getImageFromBinaryData(binaryData: Data?, defaultFilename: String) -> Image {
  
    // Create a UIImage object from binaryData
    let uiImage = UIImage(data: binaryData!)
  
    // Unwrap uiImage to see if it has a value
    if let imageObtained = uiImage {
      
        // Image is successfully obtained
        return Image(uiImage: imageObtained)
      
    } else {
        /*
         Image file with name 'defaultFilename' is returned if the image cannot be obtained
         from the binaryData given. Image file 'defaultFilename' must be given in Assets.xcassets
         */
        return Image(defaultFilename)
    }
}
