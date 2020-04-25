import Vapor
import Foundation
import JWT
import Fluent


final class User: Model, Content {
    static let schema: String = "users"
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
//    @Field(key: "password")
//    var password: String
    
    @Field(key: "passwordHash")
    var passwordHash: String
    
    @Children(for: \.$user)
    var todos: [Todo]
    
    var response: UserResponse {
        .init(username: username, userID: id!)
    }
    
    init() {}
    
    init(id: UUID? = nil, username: String, passwordHash: String){
        self.id = id
        self.username = username
        self.passwordHash = passwordHash
    }
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$username
    static let passwordHashKey =  \User.$passwordHash
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}

extension User: JWTPayload {
    func verify(using signer: JWTSigner) throws {
        //???
    }
}

