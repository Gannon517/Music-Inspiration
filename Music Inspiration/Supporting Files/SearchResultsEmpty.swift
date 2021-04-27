//
//  SearchResultsEmpty.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 4/27/21.
//

import SwiftUI
 
struct SearchResultsEmpty: View {
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .imageScale(.large)
                .font(Font.title.weight(.medium))
                .foregroundColor(.red)
                .padding()
            Text("Database Search Produced No Results!\n\nDatabase search did not return any value for the given query!")
                .fixedSize(horizontal: false, vertical: true)   // Allow lines to wrap around
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .background(Color(red: 1.0, green: 1.0, blue: 240/255))     // Ivory color
    }
}
 
struct SearchResultsEmpty_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsEmpty()
    }
}
