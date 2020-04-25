import Vapor
import Fluent
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    //Add mysql db
    //app.http.server.configuration.hostname = "localhost"
    app.databases.use(.postgres(hostname: "127.0.0.1", port: 5432, username: "lilkosi", password: "", database: "todo_vapor4", tlsConfiguration: .none), as: .psql)
    // use migraions
    app.migrations.add(CreateUser())
    app.migrations.add(CreateTodo())
    
    
    
    // register routes
    try routes(app)
}

//    app.databases.use(.postgres(
//        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
//        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
//        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
//        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
//    ), as: .psql)
