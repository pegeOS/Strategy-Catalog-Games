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
    
    var game : Jogo
    
    var body: some View {
        
        NavigationStack {
            
            VStack() {
                VStack(alignment: . leading, spacing: 1) {
                    Text(game.nome)
                        .font(.system(size: 35, weight: .black))
                        .foregroundColor(.white)
                        .padding(.bottom)
                    HStack(alignment: .top, spacing: 20 ) {
                        
                        GameCoverView(cover: game.capa)
                            .frame(width: 120, height: 120, alignment: .leading)
                        
                        
                        VStack(alignment: .leading, spacing: 3) {
                            
                            if game.criadores.isEmpty {
                                Text("Nenhum criador registrado")
                                    .font(.system(.body, design: .rounded))
                                    .foregroundColor(.gray)
                                    .bold()
                            } else {
                                Text("Criadores: \(game.criadores.joined(separator: ", ")).")
                                    .font(.system(size: 16, design: .rounded))
                                    .foregroundColor(.white)
                                    .bold()
                            }
                            Text("Lançamento: \(game.data_lancamento)")
                                .font(.system(size: 16, design: .rounded))
                                .foregroundColor(.white)
                                .bold()
                            
                            Text("Gênero: \(game.subgen)")
                                .font(.system(size: 16, design: .rounded))
                                .foregroundColor(.white)
                                .bold()
                            
                            .padding(.bottom, 7)
                            
                            HStack(spacing: 0.25){
                                ForEach(0..<game.n_estrelas){ star in
                                    ZStack {
                                        Image(systemName: "star.fill")
                                            .foregroundStyle(.yellow) // Estrela preenchida amarela
                                            .imageScale(.large)
                                        Image(systemName: "star")
                                            .foregroundStyle(.black) // Borda da estrela preenchida branca
                                            .imageScale(.large)
                                    }
                                }
                                ForEach(0..<5){ index in
                                    if(index >= game.n_estrelas){
                                        Image(systemName: "star")
                                            .foregroundStyle(.black) // Estrela vazia branca
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    Text("Informações gerais")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    Text(game.descricao)
                        .padding(.top, 10)
                        .font(.system(size: 16))
                    
                    Spacer()
                }
                    .padding()
                
                ForEach(game.comentarios) { comentario in
                    Text(comentario.texto_critica)
                }
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(LinearGradient(
                    colors: [.roxao, .preto],
                    startPoint: .top,
                    endPoint: .bottom))
                .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}


 #Preview {
     NavigationStack {
         GameDetailView(game: Jogo(nome: "Balatro", descricao: "ehfvwuhfdvwugfvuwvdfuwvfwvfuhvwdufvuwvfudvwufvuwdvfuvwudfvuwdvfuvwdufvdwuvfudwvfuvwdyfvwduyvfuywdvfyvwdyfvdwyfvuywdvfyvwduyfvuwydvfyvdwyfvdwfvwvfvwfvwfvwvfwvfyudwvfuyvdwuyvdfuydvwfyuvwuyfvwyuvfyuwvfyuwvuyfvwyufvehfvwuhfdvwugfvuwvdfuwvfwvfuhvwdufvuwvfudvwufvuwdvfuvwudfvuwdvfuvwdufvdwuvfudwvfuvwdyfvwduyvfuywdvfyvwdyfvdwyfvuywdvfyvwduyfvuwydvfyvdwyfvdwfvwvfvwfvwfvwvfwvfyudwvfuyvdwuyvdfuydvwfyuvwuyfvwyuvfyuwvfyuwvuyfvwyufvehfvwuhfdvwugfvuwvdfuwvfwvfuhvwdufvuwvfudvwufvuwdvfuvwudfvuwdvfuvwdufvdwuvfudwvfuvwdyfvwduyvfuywdvfyvwdyfvdwyfvuywdvfyvwduyfvuwydvfyvdwyfvdwfvwvfvwfvwfvwvfwvfyudwvfuyvdwuyvdfuydvwfyuvwuyfvwyuvfyuwvfyuwvuyfvw", n_estrelas: 5, n_avaliacoes: 1900, criadores: ["Pedro Gabriel", "Pedro Hélios"], data_lancamento: "27/01/2009", capa: UIImage(resource: .sla).pngData()!, subgen: "Rts"))
     }
 }

// #Preview {
//     GameDetailView()
//         .modelContainer( // ✅
//             for: [Jogo.self, Comentarios.self],
//             inMemory: true,
//             sqliteDatabasePath: Bundle.main.path(forResource: "db", ofType: "sqlite")!
//         )
// }
 
