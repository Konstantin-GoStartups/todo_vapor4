import Vapor
import Foundation

struct TodoResponse: Content {
    var title: String
    var text: String
}
