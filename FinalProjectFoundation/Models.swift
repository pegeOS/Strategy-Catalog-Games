//  Models.swift
//  FinalProjectFoundation
//  Created by Found on 02/06/26.

import Foundation
import SwiftData
import SwiftDataSQLite

@SQLiteTable("jogo")
@Model
class Jogo {
    @Attribute(.unique) var id: Int
    var nome: String
    var descricao: String
    var n_estrelas: Int
    var n_avaliacoes: Int
    var data_lancamento: String
    var capa: Data
    var subgen: String?
    
    // Relacionamento um-para-muitos com Comentarios
    @Relationship(deleteRule: .cascade, inverse: \Comentarios.jogo) 
    var comentarios: [Comentarios] = []
    
    // Relacionamento um-para-muitos com CriadoresJogos (Atributo multivalorado)
    @Relationship(deleteRule: .cascade, inverse: \CriadoresJogos.jogo) 
    var criadores: [CriadoresJogos] = []
    
    init(id: Int = Int.random(in: 1...100000), nome: String, descricao: String, n_estrelas: Int, n_avaliacoes: Int, data_lancamento: String, capa: Data, subgen: String? = nil) {
        self.id = id
        self.nome = nome
        self.descricao = descricao
        self.n_estrelas = n_estrelas
        self.n_avaliacoes = n_avaliacoes
        self.data_lancamento = data_lancamento
        self.capa = capa
        self.subgen = subgen
    }
}

@SQLiteTable("comentarios")
@Model
class Comentarios {
    @Attribute(.unique) var id_comentarios: String
    var n_estrelas: Int
    var texto_critica: String
    var nome_avaliador: String
    
    // Relacionamento inverso com Jogo (id_jogo)
    var jogo: Jogo?
    
    init(id_comentarios: String = UUID().uuidString, n_estrelas: Int, texto_critica: String, nome_avaliador: String, jogo: Jogo? = nil) {
        self.id_comentarios = id_comentarios
        self.n_estrelas = n_estrelas
        self.texto_critica = texto_critica
        self.nome_avaliador = nome_avaliador
        self.jogo = jogo
    }
}

@SQLiteTable("criadoresJogos")
@Model
class CriadoresJogos {
    var criadores: String
    
    // Relacionamento inverso com Jogo (ind_jogo)
    var jogo: Jogo?
    
    init(criadores: String, jogo: Jogo? = nil) {
        self.criadores = criadores
        self.jogo = jogo
    }
}
