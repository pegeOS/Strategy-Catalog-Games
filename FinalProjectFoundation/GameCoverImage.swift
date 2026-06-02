//
//  GameCoverImage.swift
//  FinalProjectFoundation
//
//  Created by Found on 02/06/26.
//


import SwiftUI

struct GameCoverView: View {
    
    //variavel pra imagem
    let cover: Data?
    
    //crie uma View que recebe o Data e de uma Imagem
                
    var body: some View {
        //junta em um grupo
        ZStack {
            Color.gray
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            
            // verifica se a variavel cover nao é nula, transforma a variavel cover em um a imagem nativa ( UIImage)
            if let cover = cover, let uiImage = UIImage(data: cover){
                //inicializa uma view de image do swiftUI usando a imagem criada
                Image(uiImage: uiImage)
                //mudar o tamanho pra caber no espaco
                    .resizable()
                    .scaledToFit()
            }

        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview{
    GameCoverView(cover: UIImage(resource: .sla).pngData())
}
