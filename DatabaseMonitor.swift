import Foundation
import SQLite3

// DTO para uma linha do JOIN Jogo x Comentarios
struct GameWithCommentRow: Identifiable {
    // Identificador único da linha (pode combinar jogoID + comentarioID)
    var id: String { "\(jogoID)-\(comentarioID ?? "no_comment")" }

    // Campos de Jogo
    let jogoID: Int
    let nome: String
    let descricao: String
    let nEstrelasJogo: Int
    let nAvaliacoes: Int
    let criadores: String
    let dataLancamento: String
    let capa: Data?
    let subgen: String?

    // Campos de Comentarios (podem ser nulos se você usar LEFT JOIN em algum método)
    let comentarioID: String?
    let nEstrelasComentario: Int?
    let textoCritica: String?
    let nomeAvaliador: String?
}

// Classe de monitoramento do banco (singleton)
final class DatabaseMonitor {
    static let shared = DatabaseMonitor()

    private var db: OpaquePointer?
    private(set) var databaseURL: URL?

    private init() {}

    deinit {
        close()
    }

    // Configura o caminho do banco. Se estiver no bundle, copia para Documents.
    // Chame este método no App startup, antes de executar consultas.
    func configureDatabase(fileName: String = "db.sqlite") throws {
        // 1) Tenta encontrar no Documents
        let fm = FileManager.default
        let docs = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let targetURL = docs.appendingPathComponent(fileName)

        if !fm.fileExists(atPath: targetURL.path) {
            // 2) Se não existe no Documents, tenta copiar do bundle
            if let bundlePath = Bundle.main.path(forResource: "db", ofType: "sqlite") {
                let bundleURL = URL(fileURLWithPath: bundlePath)
                do {
                    try fm.copyItem(at: bundleURL, to: targetURL)
                } catch {
                    // Se não conseguir copiar, ainda tentaremos abrir o bundle em modo leitura
                    // mas para operações de escrita isso falhará.
                    // Vamos apenas logar e seguir.
                    print("DatabaseMonitor: Falha ao copiar db do bundle para Documents: \(error)")
                }
            } else {
                // Se não tem no bundle, criaremos um arquivo vazio (ou lance erro)
                print("DatabaseMonitor: db.sqlite não encontrado no bundle. Um arquivo vazio será criado em Documents.")
                fm.createFile(atPath: targetURL.path, contents: nil, attributes: nil)
            }
        }

        // 3) Tenta abrir o banco no Documents primeiro
        if try open(at: targetURL) {
            self.databaseURL = targetURL
            return
        }

        // 4) Como fallback, tenta abrir diretamente do bundle (somente leitura)
        if let bundlePath = Bundle.main.path(forResource: "db", ofType: "sqlite") {
            let bundleURL = URL(fileURLWithPath: bundlePath)
            if try open(at: bundleURL) {
                self.databaseURL = bundleURL
                return
            }
        }

        throw NSError(domain: "DatabaseMonitor", code: -1, userInfo: [NSLocalizedDescriptionKey: "Não foi possível abrir o banco de dados."])
    }

    private func open(at url: URL) throws -> Bool {
        close()

        var handle: OpaquePointer?
        // SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE
        let flags = SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX
        let result = sqlite3_open_v2(url.path, &handle, flags, nil)
        if result == SQLITE_OK {
            self.db = handle
            return true
        } else {
            if let err = sqlite3_errmsg(handle).flatMap({ String(cString: $0) }) {
                print("DatabaseMonitor: Erro ao abrir DB em \(url.path): \(err)")
            }
            if handle != nil {
                sqlite3_close(handle)
            }
            return false
        }
    }

    func close() {
        if let handle = db {
            sqlite3_close(handle)
            db = nil
        }
    }

    // MARK: - JOINs

    // JOIN para um jogo específico (INNER JOIN)
    func fetchGameWithComments(gameID: Int) throws -> [GameWithCommentRow] {
        let sql = """
        SELECT
            Jogo.ID,
            Jogo.nome,
            Jogo.descricao,
            Jogo.n_estrelas,
            Jogo.n_avaliacoes,
            Jogo.criadores,
            Jogo.data_lancamento,
            Jogo.capa,
            Jogo.subgen,
            Comentarios.id_comentarios,
            Comentarios.n_estrelas,
            Comentarios.texto_critica,
            Comentarios.nome_avaliador
        FROM Jogo
        JOIN Comentarios ON Comentarios.id_jogo = Jogo.ID
        WHERE Jogo.ID = ?;
        """
        return try executeJoinQuery(sql: sql, bind: { stmt in
            sqlite3_bind_int(stmt, 1, Int32(gameID))
        })
    }

    // JOIN de todos os jogos com seus comentários (INNER JOIN)
    func fetchAllGamesWithComments() throws -> [GameWithCommentRow] {
        let sql = """
        SELECT
            Jogo.ID,
            Jogo.nome,
            Jogo.descricao,
            Jogo.n_estrelas,
            Jogo.n_avaliacoes,
            Jogo.criadores,
            Jogo.data_lancamento,
            Jogo.capa,
            Jogo.subgen,
            Comentarios.id_comentarios,
            Comentarios.n_estrelas,
            Comentarios.texto_critica,
            Comentarios.nome_avaliador
        FROM Jogo
        JOIN Comentarios ON Comentarios.id_jogo = Jogo.ID;
        """
        return try executeJoinQuery(sql: sql, bind: nil)
    }

    // LEFT JOIN (retorna jogos mesmo sem comentários)
    func fetchAllGamesWithOptionalComments() throws -> [GameWithCommentRow] {
        let sql = """
        SELECT
            Jogo.ID,
            Jogo.nome,
            Jogo.descricao,
            Jogo.n_estrelas,
            Jogo.n_avaliacoes,
            Jogo.criadores,
            Jogo.data_lancamento,
            Jogo.capa,
            Jogo.subgen,
            Comentarios.id_comentarios,
            Comentarios.n_estrelas,
            Comentarios.texto_critica,
            Comentarios.nome_avaliador
        FROM Jogo
        LEFT JOIN Comentarios ON Comentarios.id_jogo = Jogo.ID;
        """
        return try executeJoinQuery(sql: sql, bind: nil)
    }

    // Helper para executar a query e mapear o resultado
    private func executeJoinQuery(sql: String, bind: ((OpaquePointer?) -> Void)?) throws -> [GameWithCommentRow] {
        guard let db = db else {
            throw NSError(domain: "DatabaseMonitor", code: -2, userInfo: [NSLocalizedDescriptionKey: "DB não configurado. Chame configureDatabase() primeiro."])
        }

        var stmt: OpaquePointer?
        defer {
            if stmt != nil { sqlite3_finalize(stmt) }
        }

        if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) != SQLITE_OK {
            let err = String(cString: sqlite3_errmsg(db))
            throw NSError(domain: "DatabaseMonitor", code: -3, userInfo: [NSLocalizedDescriptionKey: "Falha ao preparar SQL: \(err)"])
        }

        // Bind de parâmetros (se houver)
        bind?(stmt)

        var rows: [GameWithCommentRow] = []
        while true {
            let step = sqlite3_step(stmt)
            if step == SQLITE_ROW {
                // Colunas na ordem do SELECT
                let jogoID = Int(sqlite3_column_int(stmt, 0))
                let nome = stringFromColumn(stmt, 1) ?? ""
                let descricao = stringFromColumn(stmt, 2) ?? ""
                let nEstrelasJogo = Int(sqlite3_column_int(stmt, 3))
                let nAvaliacoes = Int(sqlite3_column_int(stmt, 4))
                let criadores = stringFromColumn(stmt, 5) ?? ""
                let dataLancamento = stringFromColumn(stmt, 6) ?? ""
                let capa = dataFromColumn(stmt, 7)
                let subgen = stringFromColumn(stmt, 8)

                let comentarioID = stringFromColumn(stmt, 9)
                let nEstrelasComentario = columnIsNull(stmt, 10) ? nil : Int(sqlite3_column_int(stmt, 10))
                let textoCritica = stringFromColumn(stmt, 11)
                let nomeAvaliador = stringFromColumn(stmt, 12)

                let row = GameWithCommentRow(
                    jogoID: jogoID,
                    nome: nome,
                    descricao: descricao,
                    nEstrelasJogo: nEstrelasJogo,
                    nAvaliacoes: nAvaliacoes,
                    criadores: criadores,
                    dataLancamento: dataLancamento,
                    capa: capa,
                    subgen: subgen,
                    comentarioID: comentarioID,
                    nEstrelasComentario: nEstrelasComentario,
                    textoCritica: textoCritica,
                    nomeAvaliador: nomeAvaliador
                )
                rows.append(row)
            } else if step == SQLITE_DONE {
                break
            } else {
                let err = String(cString: sqlite3_errmsg(db))
                throw NSError(domain: "DatabaseMonitor", code: -4, userInfo: [NSLocalizedDescriptionKey: "Erro ao executar SQL: \(err)"])
            }
        }
        return rows
    }

    // MARK: - Helpers de coluna

    private func stringFromColumn(_ stmt: OpaquePointer?, _ index: Int32) -> String? {
        guard let cString = sqlite3_column_text(stmt, index) else { return nil }
        return String(cString: cString)
    }

    private func dataFromColumn(_ stmt: OpaquePointer?, _ index: Int32) -> Data? {
        if columnIsNull(stmt, index) { return nil }
        let bytes = sqlite3_column_blob(stmt, index)
        let length = Int(sqlite3_column_bytes(stmt, index))
        guard let base = bytes, length > 0 else { return nil }
        return Data(bytes: base, count: length)
    }

    private func columnIsNull(_ stmt: OpaquePointer?, _ index: Int32) -> Bool {
        return sqlite3_column_type(stmt, index) == SQLITE_NULL
    }
}
