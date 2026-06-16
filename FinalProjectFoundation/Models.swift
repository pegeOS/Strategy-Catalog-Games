//  Models.swift
//  FinalProjectFoundation
//  Created by Found on 02/06/26.

import Foundation
import SwiftData
import SwiftDataSQLite

@SQLiteTable("Jogo")
@Model
class Jogo {
    @SQLiteColumn("ID")
    var id: Int
    var nome: String
    var descricao: String
    var n_estrelas: Int
    var n_avaliacoes: Int
    var criadores: [String]
    var data_lancamento: String
    var capa: Data
    var subgen: String?
    
    // Relacionamento um-para-muitos com Comentarios
    @Relationship var comentarios: [Comentarios] = []
    
    init(id: Int = Int.random(in: 1...100000), nome: String, descricao: String, n_estrelas: Int, n_avaliacoes: Int, criadores: [String], data_lancamento: String, capa: Data, subgen: String? = nil) {
        self.id = id
        self.nome = nome
        self.descricao = descricao
        self.n_estrelas = n_estrelas
        self.n_avaliacoes = n_avaliacoes
        self.criadores = criadores
        self.data_lancamento = data_lancamento
        self.capa = capa
        self.subgen = subgen
    }
}

@SQLiteTable("Comentarios")
@Model
class Comentarios {
    @SQLiteColumn("id_comentarios")
    var id: String
    var n_estrelas: Int
    var texto_critica: String
    var nome_avaliador: String
    
    // Relacionamento inverso com Jogo (id_jogo)
    @Relationship(inverse: \Jogo.comentarios)
    var jogo: Jogo
    
    init(id: String = UUID().uuidString, n_estrelas: Int, texto_critica: String, nome_avaliador: String, jogo: Jogo) {
        self.id = id
        self.n_estrelas = n_estrelas
        self.texto_critica = texto_critica
        self.nome_avaliador = nome_avaliador
        self.jogo = jogo
    }
}
