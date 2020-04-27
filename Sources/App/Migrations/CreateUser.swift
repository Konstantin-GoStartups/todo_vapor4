import Vapor
import Foundation
import Fluent
import FluentPostgresDriver



struct CreateUser: Migration {
    var name: String { "CreateUser2" }
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users")
            .field("id", .uuid).unique(on: "id")
            .field("username" ,.string,.required)
            .field("passwordHash", .string , .required)
            .unique(on: "username")
            .unique(on: "id")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("users").delete()
    }
}
