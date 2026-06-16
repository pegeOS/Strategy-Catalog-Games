//
//  GameRowView.swift
//  FinalProjectFoundation
//
//  Created by Found on 02/06/26.
//

import SwiftUI

struct GameRowView: View {
    
    var game : Jogo
    var contador : Int = 0
    
    var body: some View {
        
        //capa
        HStack(alignment: .center){
            GameCoverView(cover: game.capa)
                .frame(width: 100, height: 100)
            //nome
            VStack(alignment: .leading, spacing: 0){
                
                Text(game.nome)
                    .font(.title2)
                    .bold() // Texto do nome em negrito
//                Spacer()
                
                
                // - - - - ESTRELAS - - - -
                
                HStack{
                    
                    ForEach(0..<game.n_estrelas){ star in
                        ZStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow) // Estrela preenchida amarela
                            Image(systemName: "star")
                                .foregroundStyle(.black) // Borda da estrela preenchida branca
                        }
                    }
                    ForEach(0..<5){ index in
                        if(index >= game.n_estrelas){
                            Image(systemName: "star")
                                .foregroundStyle(.black) // Estrela vazia branca
                        }
                    }
                }
                // - - - - - - - - - - -
                
                //nº de avaliacoes e subgenero
                VStack{
                    Text("( " + String(game.n_estrelas) + " Avaliações )").frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    let subgeneros = (game.subgen ?? "").components(separatedBy: ",")
                    HStack {
                        ForEach(subgeneros, id: \.self) { subgenero in
                            Button(action:{print("Botao clicado")}){
                                Text(subgenero)
                                    .font(.callout)
                                    .padding(5)
                                    .fixedSize()
                            }
                            .background {
                                Capsule()
                                    .stroke(
                                        .purple,
                                        style: StrokeStyle(
                                            lineWidth: 2,
                                            dash: [4, 3]
                                        )
                                    )
                            }
                            .foregroundColor(.white)
                            .frame(maxHeight: .infinity, alignment: .center)
                        }
                        Spacer()
                    }
                }
            }
            .foregroundColor(.white) // Aplica a cor branca a todos os textos dentro deste VStack
            .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .aspectRatio(1/0.25, contentMode: .fit)
        .padding(.horizontal)
    }
}

#Preview{
    GameRowView(
        game: Jogo(
            nome: "Balatro",
            descricao: "",
            n_estrelas: 2,
            n_avaliacoes: 10,
            criadores: ["Pedro Gabriel", "Pedro Hélios"],
            data_lancamento: "10/01/2024",
            capa: UIImage(resource: .sla).pngData()!
        )
    )
}
