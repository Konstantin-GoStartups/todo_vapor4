import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }
    
    // MARK: Unprotected API
    let unprotectedApi = app.routes

    try unprotectedApi.register(collection: UserController.Unprotected())

    // MARK: Password Protected  API
    let passwordProtected = unprotectedApi.grouped(User.authenticator())

    try passwordProtected.register(collection: UserController.PasswordProtected())

        // MARK: Token Protected API
    try app.jwt.signers.use(.es512(key: .generate()))
    let tokenProtected = unprotectedApi.grouped(UserAuthenticator())

    try tokenProtected.register(collection: UserController.TokenProtected())
    try tokenProtected.register(collection: TodoController.TokenProtected())
}
