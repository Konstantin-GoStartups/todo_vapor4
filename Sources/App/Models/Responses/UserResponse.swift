import Vapor
import Foundation

struct UserResponse: Content {
    var username: String
    var userID: UUID
}
