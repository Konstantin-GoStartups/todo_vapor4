import Vapor

struct DataWrapper<T: Content>: Content {
    let data: T

    static func encodeResponse(data: T, for request: Request) -> EventLoopFuture<Response> {
        self.init(data: data).encodeResponse(for: request)
    }
}
