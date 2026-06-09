//
//  ContentView.swift
//  FinalProjectFoundation
//
//  Created by Beatriz Leonel on 28/05/26.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack{
            VStack{
                GameRowView(game: Game(id: 1, name: "Balatro", star:2, cover:UIImage(resource: .sla).pngData(), numberRatings: 1902, subgenre: SubGenre(id:1,name:"Roguelike")))
                GameRowView(game: Game(id: 1, name: "Balatro", star:2, cover:UIImage(resource: .sla).pngData(), numberRatings: 1902, subgenre: SubGenre(id:1,name:"Roguelike")))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(
                colors: [.roxao, .preto],
                startPoint: .top,
                endPoint: .bottom))
            
            .navigationTitle("Explorar")
            .toolbarColorScheme(.dark, for: .navigationBar)
            
        }
    }
}

#Preview {
    MainView()
}
