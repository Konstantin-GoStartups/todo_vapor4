import Vapor
import Foundation

struct UserLoginResponse: Content {
    let user: UserResponse
    let accessToken: String
}
