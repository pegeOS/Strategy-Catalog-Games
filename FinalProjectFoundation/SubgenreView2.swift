//
//  SubgenreView2.swift
//  FinalProjectFoundation
//
//  Created by Found on 17/06/26.
//


import SwiftUI
import SwiftData
import SwiftDataSQLite

struct SubgenreView2: View{
    
    @Query(sort: \Jogo.id) var games: [Jogo]
    
    var body: some View{
        
        NavigationStack {
            
            VStack(){
                ZStack(alignment: .center){
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.subgenero)
                        .frame(maxWidth: .infinity, maxHeight: 140)
                    Text("Subgênero")
                        .padding(.top, 50)
                        .font(.system(size: 35))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                Spacer()
                
                List{
                    ForEach(games){ jogo in
                        NavigationLink{GameDetailView(game: jogo) } label: {
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
            }
            .ignoresSafeArea(edges: .top)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .listStyle(.plain)
            .background(LinearGradient(
                colors: [.roxao, .preto],
                startPoint: .top,
                endPoint: .bottom))
            //.navigationTitle("Subgênero")
            .navigationViewStyle(.columns)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

#Preview {
    SubgenreView2()
        .modelContainer( // ✅
            for: [Jogo.self, Comentarios.self],
            inMemory: true,
            sqliteDatabasePath: Bundle.main.path(forResource: "db", ofType: "sqlite")!
        )
}
