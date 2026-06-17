//
//  GameListView.swift
//  FinalProjectFoundation
//
//  Created by Found on 09/06/26.
//
import SwiftUI
import SwiftData
import SwiftDataSQLite

struct GameListView: View{
    
    @Query(sort: \Jogo.id) var games: [Jogo]
    
    var body: some View {
        
        NavigationStack {
            
            VStack{
                
                List{
                    ForEach(games){ jogo in
                        NavigationLink {
                            // Agora passamos apenas o ID do jogo para a tela de detalhe baseada em JOIN
                            GameDetailView(gameID: jogo.id)
                        } label: {
                            GameRowView(game: jogo)
                        }
                        .listRowSeparator(.hidden)
                        .padding(8)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.3))
                        }
                    }
                    .listRowBackground(EmptyView())
                }
                .listRowSpacing(-10)
                .padding(1)
                .listStyle(.plain)
                .navigationTitle("Explorar")
            }
//            .background(LinearGradient(
//                colors: [.roxao, .preto],
//                startPoint: .top,
//                endPoint: .bottom)
//            )
        }
    }
}


#Preview{
    GameListView()
        .modelContainer( // ✅
            for: [Jogo.self, Comentarios.self],
            inMemory: true,
            sqliteDatabasePath: Bundle.main.path(forResource: "db", ofType: "sqlite")!
        )
}
