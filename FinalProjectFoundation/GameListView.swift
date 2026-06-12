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
    
    @Query var games: [Jogo]
    
    var body: some View {
        
        NavigationStack {
            
            VStack{
                
                List{
                    ForEach(games){ jogo in
                        NavigationLink{
                            GameDetailView(game: jogo)
                        } label: {
                            GameRowView(game: jogo)
                        }
                            
                        .padding(8)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.3))
                        }
                        .listRowSeparator(.hidden)
                    }
                    
                }
                .listStyle(.plain)
                .navigationTitle("Explorar")
                .navigationSubtitle("Todos os álbuns da sua biblioteca")
            }
            .background(LinearGradient(
                colors: [.roxao, .preto],
                startPoint: .top,
                endPoint: .bottom))
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}


#Preview {
    GameListView()
        .modelContainer( // ✅
            for: [Jogo.self, Comentarios.self, CriadoresJogos.self],
            inMemory: true,
            sqliteDatabasePath: Bundle.main.path(forResource: "db", ofType: "sqlite")!
        )
}
