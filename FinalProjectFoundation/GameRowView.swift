//
//  GameRowView.swift
//  FinalProjectFoundation
//
//  Created by Found on 02/06/26.
//

import SwiftUI

struct GameRowView: View {
    
    var game : Game
    var contador : Int = 0
    
    var body: some View {
        
        //capa
        HStack(alignment: .center){
            GameCoverView(cover: UIImage(resource: .sla).pngData())
            //nome
            VStack(alignment: .leading, spacing: 0){
                
                Text(game.name)
                    .font(.system(size:32))
                    .bold() // Texto do nome em negrito
                    .padding(.bottom)
//                Spacer()
                
                
                // - - - - ESTRELAS - - - -
                
                HStack{
                    
                    ForEach(0..<game.star){ star in
                        ZStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow) // Estrela preenchida amarela
                            Image(systemName: "star")
                                .foregroundStyle(.black) // Borda da estrela preenchida branca
                        }
                    }
                    ForEach(0..<5){ index in
                        if(index >= game.star){
                            Image(systemName: "star")
                                .foregroundStyle(.black) // Estrela vazia branca
                        }
                    }
                }
                // - - - - - - - - - - -
                
                //nº de avaliacoes e subgenero
                HStack{
                    Text("( " + String(game.numberRatings) + " Avaliações )")
                    
                    Button(action:{print("Botao clicado")}){
                        Text(game.subgenre.name)
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
    GameRowView(game: Game(id: 1, name: "Balatro", star:2, cover:UIImage(resource: .sla).pngData(), numberRatings: 1902, subgenre: SubGenre(id:1,name:"Roguelike")))
}
