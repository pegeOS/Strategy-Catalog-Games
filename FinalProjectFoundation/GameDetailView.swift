//
//  GameDetailView.swift
//  FinalProjectFoundation
//
//  Created by Found on 09/06/26.
//


import SwiftUI
import SwiftData
import SwiftDataSQLite

struct GameDetailView: View {
    
    var game: Jogo
    
    var body: some View {
        
        NavigationStack {
            
            VStack() {
                VStack {
                    HStack(alignment: .top, spacing: 20 ) {
                        
                        GameCoverView(cover: game.capa)
                            .frame(width: 120, height: 120, alignment: .leading)
                        
                        
                        VStack(alignment: .leading, spacing: 8) {
                            
                            if game.criadores.isEmpty {
                                Text("Nenhum criador registrado")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            } else {
                                Text("Meus criadores: \(game.criadores.formatted(.list(type: .and, width: .standard)))")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                }
                            }
                            Text(game.data_lancamento)
                                .font(.subheadline)
                                .foregroundColor(.white)
                            
                        }
                        Spacer()
                        
                    }
                    .padding()
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(
                colors: [.roxao, .preto],
                startPoint: .top,
                endPoint: .bottom))
            .navigationTitle(game.nome)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }


 #Preview {
 GameDetailView(game: Jogo(nome: "Balatro", descricao: "Jogo massa", n_estrelas: 5, n_avaliacoes: 1900, criadores: ["Pedro Gabriel", "Pedro Hélios"], data_lancamento: "23/11/2009", capa: UIImage(resource: .sla).pngData()!))
 }
/*
 //#Preview {
 //    GameDetailView(game: Jogo)
 //        .modelContainer( // ✅
 //            for: [Jogo.self, Comentarios.self, CriadoresJogos.self],
 //            inMemory: true,
 //            sqliteDatabasePath: Bundle.main.path(forResource: "db", ofType: "sqlite")!
 //        )
 //}
 */
