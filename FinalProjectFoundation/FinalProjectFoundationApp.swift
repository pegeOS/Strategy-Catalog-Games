//
//  FinalProjectFoundationApp.swift
//  FinalProjectFoundation
//
//  Created by Beatriz Leonel on 28/05/26.
//

import SwiftUI
import SwiftData // Importe SwiftData para usar o ModelContainer

@main
struct FinalProjectFoundationApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        // Este modificador configura o SwiftData para o seu aplicativo.
        // Ele informa ao sistema que você deseja gerenciar os modelos Game e SubGenre.
        // O try! indica que esperamos que a criação do contêiner sempre funcione,
        // mas em um aplicativo real, você trataria erros aqui.
        .modelContainer(for: [Jogo.self, Comentarios.self])
    }
}
