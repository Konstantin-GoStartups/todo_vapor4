import Vapor
import Foundation
import JWT
import Fluent
import FluentPostgresDriver

struct UserController {
    struct Unprotected {}
    struct PasswordProtected {}
    struct TokenProtected {}
}

extension UserController.Unprotected: RouteCollection {
    func register(req: Request) throws -> EventLoopFuture<Response> {
        try UserRequest.validate(req)
        let create = try req.content.decode(UserRequest.self)
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords didn't match")
        }
        
        let user = try User(username: create.username, passwordHash: Bcrypt.hash(create.password, cost: 10))
        let token = try req.jwt.sign(user)
        return user.save(on: req.db).flatMap{
            let loginResponse = UserLoginResponse(user: user.response, accessToken: token)
            return DataWrapper.encodeResponse(data: loginResponse, for: req)
        }
    }
    
    func getAllUsers(req: Request) throws -> EventLoopFuture<Response> {
        return User.query(on: req.db).all().map{
            $0.map{
                $0.response
            }
        }.flatMap{
            DataWrapper.encodeResponse(data: $0, for: req)
        }
    }
    func boot(routes: RoutesBuilder) throws {
        routes.post(Endpoint.API.Users.register, use: register)
        routes.get(Endpoint.API.Users.showAllUsers, use: getAllUsers)
    }
}

extension UserController.PasswordProtected: RouteCollection {
    func login(req: Request) throws -> EventLoopFuture<Response> {
        let user = try req.auth.require(User.self)
        let token = try req.jwt.sign(user)
        let loginResponse = UserLoginResponse(
            user: user.response,
            accessToken: token)
        return DataWrapper.encodeResponse(data: loginResponse, for: req)
    }
    func boot(routes: RoutesBuilder) throws {
        routes.post(Endpoint.API.Users.login, use: login)
    }
}

extension UserController.TokenProtected: RouteCollection {
    func showMe(req: Request) throws -> EventLoopFuture<Response> {
        let user = try req.auth.require(User.self)
        return DataWrapper.encodeResponse(data: user, for: req)
    }
    
    func boot(routes: RoutesBuilder) throws {
        routes.get(Endpoint.API.Users.checkMe, use: showMe)
    }
    
}
