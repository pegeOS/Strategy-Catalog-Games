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
            GameCoverView(cover: UIImage(resource: .sla).pngData())
            //nome
            VStack(alignment: .leading, spacing: 0){
                
                Text(game.nome)
                    .font(.system(size:32))
                    .bold() // Texto do nome em negrito
                    .padding(.bottom)
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
                HStack{
                    Text("( " + String(game.n_estrelas) + " Avaliações )")
                    
                    Button(action:{print("Botao clicado")}){
                        Text(game.subgen ?? "")
                            .padding(6)
                    }
                    .background {
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(
                                    .purple,
                                    style: StrokeStyle(
                                        lineWidth: 2,
                                        dash: [4, 3]
                                    )
                                )
    
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    
                    .foregroundColor(.white) // Garante que o texto do botão é branco
//                    .cornerRadius(25)
                    .frame(maxHeight: .infinity, alignment: .center)
                }
            }
            .foregroundColor(.white) // Aplica a cor branca a todos os textos dentro deste VStack
            .fixedSize(horizontal: false, vertical: true)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .aspectRatio(1/0.25, contentMode: .fit)
        .padding(7)
        .background {
            ZStack {
                
                RoundedRectangle(cornerRadius: 25)
                    .stroke(
                        .roxinho
                    )
                
            }
        }
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
            data_lancamento: "10/01/2024",
            capa: UIImage(resource: .sla).pngData()!
        )
    )
}
