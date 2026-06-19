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
    
    @Environment(\.modelContext) private var context
    @Query var subgeneros: [Subgenero]
    
   // var game: Jogo
    
    var body: some View{
        
        NavigationStack {
            VStack {
                ScrollView(showsIndicators: true) {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        
                        ForEach(subgeneros, id: \.self) { sub in
                            NavigationLink {
                                SubgenreView2(subgen: sub)
                            } label: {
                                ZStack(alignment: .leading) {
                                    
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(Color.white.opacity(0.08))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                        )
                                        
                                    HStack {
                                        Text(sub.nome + (sub.nome_completo.map { " ( \($0) )" } ?? ""))
                                        //.font(.headline)
                                            .font(.system(size: 21))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white)
                                            .padding(20)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .font(.footnote)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white.opacity(0.4))
                                            .padding()
                                    }
                                
                                }
                                .frame(maxWidth: .infinity, minHeight: 64)
                            }
                        }
                    }
                    .padding(.top, 30)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .frame(maxWidth: .infinity)
                .background(LinearGradient(
                    colors: [.roxao, .preto],
                    startPoint: .top,
                    endPoint: .bottom))
                .navigationTitle("Subgêneros")
                .toolbarColorScheme(.dark, for: .navigationBar)
            }
//            .onAppear {
//                do {
//                    let count = try context.fetch(FetchDescriptor<Subgenero>()).count
//                    if count == 0 {
//                        context.insert(Subgenero(nome: "Roguelike"))
//                        context.insert(Subgenero(nome: "RPG"))
//                        context.insert(Subgenero(nome: "Ação"))
//                        try context.save()
//                    }
//                } catch {
//                    // Seeding falhou; opcionalmente logar
//                }
//            }
        }
    }
}


#Preview {
    SubgenreView()
        .modelContainer( // ✅
            for: [Jogo.self, Comentarios.self, Subgenero.self],
            inMemory: true,
            sqliteDatabasePath: Bundle.main.path(forResource: "db", ofType: "sqlite")!
        )
}

