import Vapor
import Foundation


struct Endpoint {
    enum API{}
}

extension Endpoint.API {
    static private let api: [PathComponent] = ["backend"]
    
    enum Users {
        static private let users: [PathComponent] = api + ["users"]
        static let register: [PathComponent] = users + ["register"]
        static let login: [PathComponent] = users + ["login"]
        static let checkMe: [PathComponent] = users + ["me"]
        static let showAllUsers: [PathComponent] = users + ["showAll"]
        
    }
    
    enum Todos {
        static private let todos: [PathComponent] = api + ["todos"]
        static let index:[PathComponent] = todos
        static let createTodo: [PathComponent] = todos + ["create"]
        static let deleteTodo: [PathComponent] = todos + ["delete"]
        static let showTodo: [PathComponent] = todos + ["show"]
        static let showTodosForUser: [PathComponent] = todos + ["showAll"]
        static let shoAll: [PathComponent] = todos + ["all"]
        enum Params {
            static let userID: PathComponent = .parameter("userID")
        }
    }
}
