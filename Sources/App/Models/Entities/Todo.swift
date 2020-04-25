import Vapor
import Foundation
import Fluent
import FluentMySQLDriver

final class Todo: Model, Content {
    static let schema: String = "todo"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "text")
    var text: String
    
    @Parent(key: "user_id")
    var user: User
    
    var response: TodoResponse {
        .init(title: title, text: text)
    }
    init() {}
    
    
    init(id: UUID? = nil, title: String,text: String, userID: String) {
        self.title = title
        self.text = text
        self.$user.id = UUID(uuidString: userID)!
    }
}
