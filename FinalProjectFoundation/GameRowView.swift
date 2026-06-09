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
        HStack(alignment: .top){
            GameCoverView(cover: UIImage(resource: .sla).pngData())
                .frame(width:130, height:130)
            
            VStack(alignment: .leading){
                Text(game.name).font(.system(size:32))
                Spacer()
                
                // - - - - ESTRELAS - - - -
                
                HStack{
                    
                    ForEach(0..<game.star){ star in
                        ZStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                            Image(systemName: "star")
                                .foregroundStyle(.black)
                        }
                    }
                    ForEach(0..<5){ index in
                        if(index >= game.star){
                            Image(systemName: "star")
                        }
                    }
                }
                // - - - - - - - - - - -
                
                Spacer()
                HStack{
                    Text("( " + String(game.numberRatings) + " Avaliações )")
                    
                    Button(action:{print("Botao clicado")}){
                        Text(game.subgenre.name)
                            .padding(4)
                    }
                    .background(Color.purple.opacity(0.6))
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    .frame(maxHeight: .infinity, alignment: .center)
                }
                Spacer()
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
//      .frame(maxWidth: .infinity, alignment: .leading)
//      .frame(height: 100)
}


//#Preview{
//    GameRowView(game: Game(id: 1, name: "Balatro", star:2, subgenre: 1902, cover:UIImage(resource: .sla).pngData(), numberRatings: SubGenre(id:1,name:"Roguelike")))
//}
