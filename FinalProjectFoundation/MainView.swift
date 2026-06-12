//
//  ContentView.swift
//  FinalProjectFoundation
//
//  Created by Beatriz Leonel on 28/05/26.
//

import SwiftUI
import SwiftData // Adicione esta linha

struct MainView: View {
    var body: some View {
        TabView {
            // Aba Explorar
            NavigationStack{
                GameListView()
            }
            .tabItem {
                Label("Explorar", systemImage: "star.fill")
            }
            
            // MARK: - Aba Subgêneros

            NavigationStack {
                //SubGenreView()
            }
            .tabItem {
                Label("Subgêneros", systemImage: "gamecontroller.fill")
            }
            
            // MARK: - Aba Pesquisa

            NavigationStack {
                //SearchView()
            }
            .tabItem {
                Label("Pesquisa", systemImage: "magnifyingglass")
            }
        }
        .tint(.purple) // Define a cor do ícone e texto da aba selecionada
    }
}

#Preview {
    MainView()
        // Para o Preview da MainView funcionar com as novas abas, ela também precisa
        // de um ModelContainer e alguns dados de teste para a SubGenreView.
//        .modelContainer(for: [Game.self, SubGenre.self], inMemory: true)
//        .onAppear {
//            let context = try! ModelContainer(for: [Game.self, SubGenre.self]).mainContext
//            if context.fetch(FetchDescriptor<SubGenre>()).isEmpty {
//                context.insert(SubGenre(name: "Roguelike"))
//                context.insert(SubGenre(name: "RPG"))
//                context.insert(SubGenre(name: "Ação"))
//                
//                // Exemplo de como adicionar um jogo e vinculá-lo a um subgênero
//                let roguelike = context.registeredObject(for: SubGenre(name: "Roguelike"))!
//                context.insert(Game(name: "Hades", star: 5, cover: nil, numberRatings: 10000, subgenre: roguelike))
//            }
//        }
}

