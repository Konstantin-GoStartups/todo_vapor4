import Vapor
import Foundation

struct UserRequest: Content {
    let username: String
    let password: String
    let confirmPassword: String
}

extension UserRequest: Validatable{
    static func validations(_ validations: inout Validations) {
        validations.add("username", as: String.self, is: .alphanumeric)
        validations.add("password", as: String.self, is: .count(6...))
    }
}
