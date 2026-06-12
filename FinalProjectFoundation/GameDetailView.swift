//
//  GameDetailView.swift
//  FinalProjectFoundation
//
//  Created by Found on 09/06/26.
//


import SwiftUI
import SwiftData
import SwiftDataSQLite

struct GameDetailView: View{
    
    var game: Jogo
    
    var body: some View{
        
        NavigationStack {
            
            VStack{
                    
                }
            }
            .listStyle(.plain)
            .background(LinearGradient(
                colors: [.roxao, .preto],
                startPoint: .top,
                endPoint: .bottom))
            .navigationTitle("Escolha seu subgênero")
            .navigationSubtitle("Todos os álbuns da sua biblioteca")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }


//#Preview {
//    GameDetailView()
//        .modelContainer( // ✅
//            for: [Game.self, SubGenre.self],
//            inMemory: true,
//            sqliteDatabasePath: Bundle.main.path(forResource: "db", ofType: "sqlite")!
//        )
//}
