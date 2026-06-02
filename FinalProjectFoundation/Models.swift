//  Models.swift
//  FinalProjectFoundation
//  Created by Found on 02/06/26.






import Foundation
import SwiftData
import SwiftDataSQLite

@SQLiteTable("games")
//fazendo o @Model para transformar uma classe comum do swift em um modelo de dados gerenciado pelo SwiftData
@Model
class Game{//criando classe de Jogo

    
    //id, nome, numero de estrelas e subgenero, que sera vinculado a variavel "games" da classe SubGenre
    var id: Int
    var name: String
    var star: Int
    var cover: Data?
    var numberRatings: Int
    @Relationship(inverse: \SubGenre.games) var subgenre: SubGenre
    
    //inicializando as variaveis
    init(id: Int = Int.random(in: 0...100), name: String, star: Int, subgenre: SubGenre, cover: Data?, numberRatings: Int){
        
        self.id = id
        self.name = name
        self.star = star
        self.numberRatings = numberRatings
        self.cover = cover
        self.subgenre = subgenre
    }
}

@SQLiteTable("subgenres")
@Model
class SubGenre{ // criando classe de subgenero de jogo
    
    //id, nome e array de jogos que nao precisa ser inicializado pois está vinculado a variavel "subgenre" da classe Game
    var id: Int
    var name: String
    @Relationship var games: [Game] = []
    
    //inicializando as variaveis
    init(id: Int = Int.random(in: 0...100), name: String){
        
        self.id = id
        self.name = name
    }
}
