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
    
    @Query var subgeneros: [Subgenero]
    
   // var game: Jogo
    
    var body: some View{
        
        NavigationStack {
            ScrollView(showsIndicators: true) {
                LazyVStack(alignment: .leading, spacing: 12) {
                    
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
                                Image(systemName: "chevron.right")
                                    .font(.footnote)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white.opacity(0.4))
                                Spacer()
                                Text(sub.nome)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .padding(16)
                            
                            }
                            .frame(maxWidth: .infinity, minHeight: 64)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .frame(maxWidth: .infinity)
            .background(LinearGradient(
                colors: [.roxao, .preto],
                startPoint: .top,
                endPoint: .bottom))
            .navigationTitle("Subgênero")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
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

