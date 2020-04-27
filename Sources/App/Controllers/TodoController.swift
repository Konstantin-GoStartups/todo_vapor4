import Vapor
import Fluent
import JWT
import Foundation

struct TodoController {
    struct TokenProtected {}
}

extension TodoController.TokenProtected: RouteCollection {
    
    func createTodo(req: Request) throws -> EventLoopFuture<HTTPStatus>{
        try req.content.decode(Todo.self).save(on: req.db).transform(to: .ok)
    }
    
    func deleteTodo(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        try req.content.decode(Todo.self).delete(on: req.db).transform(to: .ok)
    }
    
    func fetchAllTodosForUser(req: Request) throws -> EventLoopFuture<Response> {
        let userID  =  req.parameters.get("userID", as: UUID.self)
      return User.find(userID, on: req.db)
        .unwrap(or: Abort(.notFound))
        .flatMap { user in
            return user.$todos.load(on: req.db).flatMap{  todos in
                return DataWrapper.encodeResponse(data: user, for: req)
                }
        }
    }
    func fetchAllTodos(req: Request) throws -> EventLoopFuture<Response> {
        return Todo.query(on: req.db).all().map{
            $0.map{
                $0.response
            }
        }.flatMap{
            DataWrapper.encodeResponse(data: $0, for: req)
        }
    }
    func boot(routes: RoutesBuilder) throws {
        routes.post(Endpoint.API.Todos.createTodo, use: createTodo)
        routes.post(Endpoint.API.Todos.deleteTodo, use: deleteTodo)
        routes.get(Endpoint.API.Todos.index + [Endpoint.API.Todos.Params.userID], use: fetchAllTodosForUser)
        routes.get(Endpoint.API.Todos.shoAll, use: fetchAllTodos)
    }
}
