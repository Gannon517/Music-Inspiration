//
//  TrendingMusic.swift
//  Music Inspiration
//
//  Created by Michael Gannon on 5/4/21.
//

import SwiftUI
 
struct TrendingMusic: View {
    
   
    var body: some View {
            List {
                ForEach(topChartSongs) { aSong in
                    NavigationLink(destination: TrendingMusicDetails(ma: aSong)) {
                        TrendingMusicItem(ma: aSong)
                    }
                }
            }
            .navigationBarTitle(Text("Trending Music"), displayMode: .inline)
    }
}
