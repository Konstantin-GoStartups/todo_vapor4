import Foundation
import Vapor
import Fluent
import FluentPostgresDriver

struct CreateTodo: Migration {
    var name: String { "todo" }
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("todo").field("id",.uuid).unique(on: "id").field("title", .string, .required).field("text", .string).field("user_id", .uuid, .references("users", "id")).create()
    }
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("todo").delete()
    }
}

