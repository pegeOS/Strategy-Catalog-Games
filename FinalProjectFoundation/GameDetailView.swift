//
//  GameDetailView.swift
//  FinalProjectFoundation
//
//  Created by Found on 09/06/26.
//

import SwiftUI

// Estruturas auxiliares para exibir o resultado do JOIN
private struct CommentJoinItem: Identifiable {
    let id: String
    let nEstrelas: Int
    let textoCritica: String
    let nomeAvaliador: String
}

private struct GameJoinGroup {
    let jogoID: Int
    let nome: String
    let descricao: String
    let nEstrelasJogo: Int
    let nAvaliacoes: Int
    let criadores: String
    let dataLancamento: String
    let capa: Data?
    let subgen: String?
    let comentarios: [CommentJoinItem]
}

struct GameDetailView: View {
    // Agora recebemos apenas o ID do jogo, e a tela usa JOIN para buscar tudo
    let gameID: Int

    @State private var group: GameJoinGroup?
    @State private var loadError: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if let group {
                        VStack(alignment: .leading, spacing: 1) {
                            Text(group.nome)
                                .font(.system(size: 35, weight: .black))
                                .foregroundColor(.white)
                                .padding(.bottom)

                            HStack(alignment: .top, spacing: 20) {
                                GameCoverView(cover: group.capa)
                                    .frame(width: 120, height: 120, alignment: .leading)

                                VStack(alignment: .leading, spacing: 3) {
                                    if group.criadores.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                        Text("Nenhum criador registrado")
                                            .font(.system(.body, design: .rounded))
                                            .foregroundColor(.gray)
                                            .bold()
                                    } else {
                                        Text("Criadores: \(group.criadores).")
                                            .font(.system(size: 16, design: .rounded))
                                            .foregroundColor(.white)
                                            .bold()
                                    }

                                    Text("Lançamento: \(group.dataLancamento)")
                                        .font(.system(size: 16, design: .rounded))
                                        .foregroundColor(.white)
                                        .bold()

                                    Text("Gênero: \(group.subgen ?? "")")
                                        .font(.system(size: 16, design: .rounded))
                                        .foregroundColor(.white)
                                        .bold()
                                        .padding(.bottom, 7)

                                    HStack(spacing: 0.25) {
                                        ForEach(0..<group.nEstrelasJogo, id: \.self) { _ in
                                            ZStack {
                                                Image(systemName: "star.fill")
                                                    .foregroundStyle(.yellow)
                                                    .imageScale(.large)
                                                Image(systemName: "star")
                                                    .foregroundStyle(.black)
                                                    .imageScale(.large)
                                            }
                                        }
                                        ForEach(group.nEstrelasJogo..<5, id: \.self) { _ in
                                            Image(systemName: "star")
                                                .foregroundStyle(.black)
                                        }
                                    }
                                }
                                Spacer()
                            }

                            Text("Informações gerais")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .padding(.top, 20)

                            Text(group.descricao)
                                .padding(.top, 10)
                                .font(.system(size: 16))

                            Spacer()
                                .padding(.bottom, 20)

                            Text("Comentários")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("Críticas coletadas do site MetaCritic e OpenCritic")
                                .font(.system(size: 10))
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 0.25)

                            ForEach(group.comentarios) { comentario in
                                ZStack(alignment: .topLeading) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.comentario)

                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Image(systemName: "person.circle.fill")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundStyle(.roxao)
                                                .frame(width: 24, height: 24)

                                            Text(comentario.nomeAvaliador)
                                                .font(.headline)
                                        }
                                        Text(comentario.textoCritica)
                                    }
                                    .foregroundColor(.black)
                                    .padding(.top, 10)
                                    .padding(.leading, 10)
                                    .padding(.bottom, 15)
                                    .padding(.trailing, 15)
                                }
                                .padding(.top, 10)
                            }
                        }
                        .padding()
                    } else if let loadError {
                        Text("Erro ao carregar: \(loadError)")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        ProgressView("Carregando…")
                            .padding()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(
                colors: [.roxao, .preto],
                startPoint: .top,
                endPoint: .bottom))
            .toolbarColorScheme(.dark, for: .navigationBar)
            .onAppear {
                loadData()
            }
        }
    }

    private func loadData() {
        do {
            // Garante que o DB está configurado (se já tiver sido configurado no App, isso pode ser omitido)
            if DatabaseMonitor.shared.databaseURL == nil {
                try DatabaseMonitor.shared.configureDatabase()
            }

            let rows = try DatabaseMonitor.shared.fetchGameWithComments(gameID: gameID)

            // Se não vier nenhuma linha, pode ser que o jogo exista sem comentários.
            // Se quiser suportar isso, troque para LEFT JOIN:
            // let rows = try DatabaseMonitor.shared.fetchAllGamesWithOptionalComments().filter { $0.jogoID == gameID }

            guard let first = rows.first else {
                // Sem comentários para o jogo (INNER JOIN não retorna nada). Você pode decidir como tratar.
                self.group = GameJoinGroup(
                    jogoID: gameID,
                    nome: "Jogo não encontrado ou sem comentários",
                    descricao: "",
                    nEstrelasJogo: 0,
                    nAvaliacoes: 0,
                    criadores: "",
                    dataLancamento: "",
                    capa: nil,
                    subgen: nil,
                    comentarios: []
                )
                return
            }

            // Monta a estrutura agregada a partir das linhas do JOIN
            let comentarios: [CommentJoinItem] = rows.compactMap { row in
                guard
                    let cid = row.comentarioID,
                    let nEst = row.nEstrelasComentario,
                    let texto = row.textoCritica,
                    let nome = row.nomeAvaliador
                else {
                    return nil
                }
                return CommentJoinItem(id: cid, nEstrelas: nEst, textoCritica: texto, nomeAvaliador: nome)
            }

            self.group = GameJoinGroup(
                jogoID: first.jogoID,
                nome: first.nome,
                descricao: first.descricao,
                nEstrelasJogo: first.nEstrelasJogo,
                nAvaliacoes: first.nAvaliacoes,
                criadores: first.criadores,
                dataLancamento: first.dataLancamento,
                capa: first.capa,
                subgen: first.subgen,
                comentarios: comentarios
            )
        } catch {
            self.loadError = error.localizedDescription
        }
    }
}

#Preview {
    // Para o preview funcionar, passe um ID válido que exista no seu db.sqlite.
    // Se não houver DB acessível no preview, você verá o ProgressView/erro.
    GameDetailView(gameID: 1)
}
