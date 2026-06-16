//
//  SubgenreView.swift
//  FinalProjectFoundation
//
//  Created by Found on 12/06/26.
//


import SwiftUI
import SwiftData
import SwiftDataSQLite

struct SubgenreView: View{
    
   // var game: Jogo
    
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
            .navigationTitle("Subgênero")
            .navigationViewStyle(.columns)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }


#Preview {
    SubgenreView()
        .modelContainer( // ✅
            for: [Jogo.self, Comentarios.self],
            inMemory: true,
            sqliteDatabasePath: Bundle.main.path(forResource: "db", ofType: "sqlite")!
        )
}
