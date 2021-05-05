//
//  APISearch.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 5/4/21.
//

import Foundation

let myApiKey = "523532"
 
fileprivate var previousAName = ""
var topChartSongs = [MusicAlbum]()
var topChartIds = [String]()

public func getApiDataByArtistName(artistName: String) {
   
    /*
     Search query q=a will get all of the 460 national parks data with limit=500.
     If the park name = parkName given as input parameter, then we obtain its data.
     */
    let apiSearchQuery = "https://www.theaudiodb.com/api/v1/json/\(myApiKey)/search.php?s=\(artistName)"

    /*
    *********************************************
    *   Obtaining API Search Query URL Struct   *
    *********************************************
    */
   
    var apiQueryUrlStruct: URL?
   
     if let urlStruct = URL(string: apiSearchQuery) {
         apiQueryUrlStruct = urlStruct
     } else {
         // nationalParkFound will have the initial values set as above
         return
     }
   
    /*
    *******************************
    *   HTTP GET Request Set Up   *
    *******************************
    */
 
    let headers = [
        "x-api-key": myApiKey,
        "accept": "application/json",
        "cache-control": "no-cache",
        "connection": "keep-alive",
        "host": "www.theaudiodb.com"
    ]
   
    let request = NSMutableURLRequest(url: apiQueryUrlStruct!,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 60.0)
   
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
   
    /*
    *********************************************************************
    *  Setting Up a URL Session to Fetch the JSON File from the API     *
    *  in an Asynchronous Manner and Processing the Received JSON File  *
    *********************************************************************
    */
   
    /*
     Create a semaphore to control getting and processing API data.
     signal() -> Int    Signals (increments) a semaphore.
     wait()             Waits for, or decrements, a semaphore.
     */
    let semaphore = DispatchSemaphore(value: 0)
   
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        /*
        URLSession is established and the JSON file from the API is set to be fetched
        in an asynchronous manner. After the file is fetched, data, response, error
        are returned as the input parameter values of this Completion Handler Closure.
        */
       
        // Process input parameter 'error'
        guard error == nil else {
            semaphore.signal()
            return
        }
       
        // Process input parameter 'response'. HTTP response status codes from 200 to 299 indicate success.
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            semaphore.signal()
            return
        }
       
        // Process input parameter 'data'. Unwrap Optional 'data' if it has a value.
        guard let jsonDataFromApi = data else {
            semaphore.signal()
            return
        }
 
        //------------------------------------------------
        // JSON data is obtained from the API. Process it.
        //------------------------------------------------
        do {
            /*
            Foundation framework’s JSONSerialization class is used to convert JSON data
            into Swift data types such as Dictionary, Array, String, Number, or Bool.
            */
            let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                              options: JSONSerialization.ReadingOptions.mutableContainers)
 
            /*
             JSON object with Attribute-Value pairs corresponds to Swift Dictionary type with
             Key-Value pairs. Therefore, we use a Dictionary to represent a JSON object
             where Dictionary Key type is String and Value type is Any (instance of any type)
             */
            var jsonDataDictionary = Dictionary<String, Any>()
            
            if let jsonObject = jsonResponse as? [String: Any] {
                jsonDataDictionary = jsonObject
            } else {
                semaphore.signal()
                return
            }
           
            //-----------------------
            // Obtain Data JSON Array
            //-----------------------
           
            var dataJsonArray = [Any]()
            if let jArray = jsonDataDictionary["artists"] as? [Any] {
                dataJsonArray = jArray
            } else {
                semaphore.signal()
                return
            }
            
            /*
             API returns the following for invalid national park name
             {"total":"0","data":[],"limit":"50","start":"1"}
             */
            if dataJsonArray.isEmpty {
                semaphore.signal()
                return
            }
            
            let artist = dataJsonArray[0] as! [String: Any]
            var artistID = ""
            if let id = artist["idArtist"] as? String {
                artistID = id
            }
            
            var artistName = ""
            if let name = artist["strArtist"] as? String {
                artistName = name
            }
            
            print(artistName + " " + artistID)
            
            
            // Iterate over all the national parks returned
               
        } catch {
            semaphore.signal()
            return
        }
       
        semaphore.signal()
    }).resume()
   
    /*
     The URLSession task above is set up. It begins in a suspended state.
     The resume() method starts processing the task in an execution thread.
    
     The semaphore.wait blocks the execution thread and starts waiting.
     Upon completion of the task, the Completion Handler code is executed.
     The waiting ends when .signal() fires or timeout period of 60 seconds expires.
    */
 
    _ = semaphore.wait(timeout: .now() + 60)
       
}


public func getItunesTopSongs(artistName: String) {
   
    var topChartFound = MusicAlbum(id: "" , artistName: "", albumName: "", songName: "", genre: "", rating: "", releaseDate: "", coverPhotoFilename: "", musicVideID: "")
    /*
     Search query q=a will get all of the 460 national parks data with limit=500.
     If the park name = parkName given as input parameter, then we obtain its data.
     */
    let apiSearchQuery = "https://www.theaudiodb.com/api/v1/json/523532/trending.php?country=us&type=itunes&format=singles"

    /*
    *********************************************
    *   Obtaining API Search Query URL Struct   *
    *********************************************
    */
   
    var apiQueryUrlStruct: URL?
   
     if let urlStruct = URL(string: apiSearchQuery) {
         apiQueryUrlStruct = urlStruct
     } else {
         // nationalParkFound will have the initial values set as above
         return
     }
   
    /*
    *******************************
    *   HTTP GET Request Set Up   *
    *******************************
    */
 
    let headers = [
        "x-api-key": myApiKey,
        "accept": "application/json",
        "cache-control": "no-cache",
        "connection": "keep-alive",
        "host": "www.theaudiodb.com"
    ]
   
    let request = NSMutableURLRequest(url: apiQueryUrlStruct!,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 60.0)
   
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
   
    /*
    *********************************************************************
    *  Setting Up a URL Session to Fetch the JSON File from the API     *
    *  in an Asynchronous Manner and Processing the Received JSON File  *
    *********************************************************************
    */
   
    /*
     Create a semaphore to control getting and processing API data.
     signal() -> Int    Signals (increments) a semaphore.
     wait()             Waits for, or decrements, a semaphore.
     */
    let semaphore = DispatchSemaphore(value: 0)
   
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        /*
        URLSession is established and the JSON file from the API is set to be fetched
        in an asynchronous manner. After the file is fetched, data, response, error
        are returned as the input parameter values of this Completion Handler Closure.
        */
       
        // Process input parameter 'error'
        guard error == nil else {
            semaphore.signal()
            return
        }
       
        // Process input parameter 'response'. HTTP response status codes from 200 to 299 indicate success.
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            semaphore.signal()
            return
        }
       
        // Process input parameter 'data'. Unwrap Optional 'data' if it has a value.
        guard let jsonDataFromApi = data else {
            semaphore.signal()
            return
        }
 
        //------------------------------------------------
        // JSON data is obtained from the API. Process it.
        //------------------------------------------------
        do {
            /*
            Foundation framework’s JSONSerialization class is used to convert JSON data
            into Swift data types such as Dictionary, Array, String, Number, or Bool.
            */
            let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                              options: JSONSerialization.ReadingOptions.mutableContainers)
 
            /*
             JSON object with Attribute-Value pairs corresponds to Swift Dictionary type with
             Key-Value pairs. Therefore, we use a Dictionary to represent a JSON object
             where Dictionary Key type is String and Value type is Any (instance of any type)
             */
            var jsonDataDictionary = Dictionary<String, Any>()
            
            if let jsonObject = jsonResponse as? [String: Any] {
                jsonDataDictionary = jsonObject
            } else {
                semaphore.signal()
                return
            }
           
            //-----------------------
            // Obtain Data JSON Array
            //-----------------------
           
            var dataJsonArray = [Any]()
            if let jArray = jsonDataDictionary["trending"] as? [Any] {
                dataJsonArray = jArray
            } else {
                semaphore.signal()
                return
            }
            
            /*
             API returns the following for invalid national park name
             {"total":"0","data":[],"limit":"50","start":"1"}
             */
            if dataJsonArray.isEmpty {
                semaphore.signal()
                return
            }
            print(dataJsonArray)
            
            
            for song in dataJsonArray{
                let s = song as! [String: Any]
                
                topChartFound.id = UUID().uuidString
                
                if let name = s["strTrack"] as? String {
                    topChartFound.songName = name
                }
                
                if let name = s["strArtist"] as? String {
                    topChartFound.artistName = name
                }
                
                if let name = s["strAlbum"] as? String {
                    topChartFound.albumName = name
                }
                
                if let name = s["strTrackThumb"] as? String {
                    let n = name.replacingOccurrences(of: "\\", with: "")
                    topChartFound.coverPhotoFilename = n
                    print(n + "\n")
                }
                
                if let name = s["idTrack"] as? String {
                    topChartIds.append(name)
                }
                
                
                topChartSongs.append(topChartFound)
                print(s["strTrack"] as! String + "\n")
            }
            
            
            // Iterate over all the national parks returned
               
        } catch {
            semaphore.signal()
            return
        }
       
        semaphore.signal()
    }).resume()
   
    /*
     The URLSession task above is set up. It begins in a suspended state.
     The resume() method starts processing the task in an execution thread.
    
     The semaphore.wait blocks the execution thread and starts waiting.
     Upon completion of the task, the Completion Handler code is executed.
     The waiting ends when .signal() fires or timeout period of 60 seconds expires.
    */
 
    _ = semaphore.wait(timeout: .now() + 60)
       
}


public func getChartsInfo(index: Int) {
    
    
    /*
     Search query q=a will get all of the 460 national parks data with limit=500.
     If the park name = parkName given as input parameter, then we obtain its data.
     */
    let apiSearchQuery = "https://theaudiodb.com/api/v1/json/523532/track.php?h=\(topChartIds[index])"
    
    print(index)

    /*
    *********************************************
    *   Obtaining API Search Query URL Struct   *
    *********************************************
    */
   
    var apiQueryUrlStruct: URL?
   
     if let urlStruct = URL(string: apiSearchQuery) {
         apiQueryUrlStruct = urlStruct
     } else {
         // nationalParkFound will have the initial values set as above
         return
     }
   
    /*
    *******************************
    *   HTTP GET Request Set Up   *
    *******************************
    */
 
    let headers = [
        "x-api-key": myApiKey,
        "accept": "application/json",
        "cache-control": "no-cache",
        "connection": "keep-alive",
        "host": "www.theaudiodb.com"
    ]
   
    let request = NSMutableURLRequest(url: apiQueryUrlStruct!,
                                      cachePolicy: .useProtocolCachePolicy,
                                      timeoutInterval: 60.0)
   
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers
   
    /*
    *********************************************************************
    *  Setting Up a URL Session to Fetch the JSON File from the API     *
    *  in an Asynchronous Manner and Processing the Received JSON File  *
    *********************************************************************
    */
   
    /*
     Create a semaphore to control getting and processing API data.
     signal() -> Int    Signals (increments) a semaphore.
     wait()             Waits for, or decrements, a semaphore.
     */
    let semaphore = DispatchSemaphore(value: 0)
   
    URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        /*
        URLSession is established and the JSON file from the API is set to be fetched
        in an asynchronous manner. After the file is fetched, data, response, error
        are returned as the input parameter values of this Completion Handler Closure.
        */
       
        // Process input parameter 'error'
        guard error == nil else {
            semaphore.signal()
            return
        }
       
        // Process input parameter 'response'. HTTP response status codes from 200 to 299 indicate success.
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            semaphore.signal()
            return
        }
       
        // Process input parameter 'data'. Unwrap Optional 'data' if it has a value.
        guard let jsonDataFromApi = data else {
            semaphore.signal()
            return
        }
 
        //------------------------------------------------
        // JSON data is obtained from the API. Process it.
        //------------------------------------------------
        do {
            /*
            Foundation framework’s JSONSerialization class is used to convert JSON data
            into Swift data types such as Dictionary, Array, String, Number, or Bool.
            */
            let jsonResponse = try JSONSerialization.jsonObject(with: jsonDataFromApi,
                              options: JSONSerialization.ReadingOptions.mutableContainers)
 
            /*
             JSON object with Attribute-Value pairs corresponds to Swift Dictionary type with
             Key-Value pairs. Therefore, we use a Dictionary to represent a JSON object
             where Dictionary Key type is String and Value type is Any (instance of any type)
             */
            var jsonDataDictionary = Dictionary<String, Any>()
            
            if let jsonObject = jsonResponse as? [String: Any] {
                jsonDataDictionary = jsonObject
            } else {
                semaphore.signal()
                return
            }
           
            //-----------------------
            // Obtain Data JSON Array
            //-----------------------
           
            var dataJsonArray = [Any]()
            if let jArray = jsonDataDictionary["track"] as? [Any] {
                dataJsonArray = jArray
            } else {
                semaphore.signal()
                return
            }
            
            /*
             API returns the following for invalid national park name
             {"total":"0","data":[],"limit":"50","start":"1"}
             */
            if dataJsonArray.isEmpty {
                semaphore.signal()
                return
            }
            
            let s = dataJsonArray[0] as! [String: Any]
            print(s)
            if let name = s["strGenre"] as? String {
                topChartSongs[index].genre = name
            }
            
            if let name = s["strMusicVid"] as? String {
                topChartSongs[index].musicVideID = name
            }
            
            
            // Iterate over all the national parks returned
               
        } catch {
            semaphore.signal()
            return
        }
       
        semaphore.signal()
    }).resume()
   
    /*
     The URLSession task above is set up. It begins in a suspended state.
     The resume() method starts processing the task in an execution thread.
    
     The semaphore.wait blocks the execution thread and starts waiting.
     Upon completion of the task, the Completion Handler code is executed.
     The waiting ends when .signal() fires or timeout period of 60 seconds expires.
    */
 
    _ = semaphore.wait(timeout: .now() + 60)
       
}
