# NetworkDispatcher

In todays world, most apps will connect to an external API to send and receive data. So instead of having multiple URLSessions throughout our
application. We can build a networkDispatcher to handle all of our networking, allowing us to efficiently make url requests and use less code
in the long run.

The network dispatcher gets initialized with an Environment object which gets defined in `AppDelegate.swift` in the following code
```swift
private func makeNetworkDispatcher() -> NetworkDispatcher {
        let environment = Environment("prod", host: "http://localhost.com" )
        return NetworkDispatcher(environment: environment)
    }
```
This is nice because we only need to change the url endpoint of our entire app in one location.

Taking a look in the Network folder in our project, we have 6 files that make up NetworkDispatcher work.

### `Dispatcher.swift`
Contains our Dispatcher protocol which requires and init and execute function.
```swift
public protocol Dispatcher {
    init(environment: Environment)
    func execute( _ request: Request, completion: @escaping (Response) -> Void) throws
}
```

### `Environment.swift`
Contains the Environment struct, which is used to create the structure of our url
```swift
public struct Environment {
    public var name: String
    public var host: String
    public var headers: [String : Any] = ["Content-Type" : "application/json"]
    public var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData

    public init(_ name: String, host: String) {
        self.name = name
        self.host = host
    }
}
```

### `Response.swift`
Contains our Response enum to handle the responses we receive from the server. More responses codes can be added
to the switch statement to handle more use cases if needed.
```swift
public enum Response {
    case data(_ : Data)
    case error(_:Int?, _: Error)

    init(_ response: (r: HTTPURLResponse?, data: Data?, error: Error?), for request: Request) {
        guard response.r?.statusCode == 200, response.error == nil else {
            var message: String?
            if let msgData = response.data {
                message = String(data: msgData, encoding: .utf8)
            }
            var error: Error
            let code = response.r?.statusCode ?? 0
            let data: Data = response.data ?? Data()
            switch code {
            case 400:
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] {
                    var messages = ""
                    json?.forEach { item in
                        if let msg = item["message"] as? String {
                            messages += "\(msg)\n"
                        }
                    }
                    if messages.count == 0 {
                        messages = "An error has occurred while executing your request."
                    }
                    error = NetworkErrors.badRequest(messages)
                }
                else {
                    error = NetworkErrors.badRequest(message ?? "An error has occurred while executing your request.")
                }
            case 401:
                error = NetworkErrors.unauthorized(message ?? "Invalid or no authentication provided.")
            case 403:
                error = NetworkErrors.forbidden(message ?? "The authenticated user does not have access to the requested resource.")
            case 404:
                error = NetworkErrors.notFound(message ?? "The requested resource could not be found.")
            case 429:
                error = NetworkErrors.manyRequests(message ?? "The limit of API calls allowed has been exceeded.")
            case 500:
                error = NetworkErrors.internalServerError(message ?? "An error has occurred while executing your request.")
            default:
                if response.error != nil {
                    error = NetworkErrors.unknown(response.error!.localizedDescription)
                }
                else {
                    error = NetworkErrors.noData
                }
            }

            self = .error(response.r?.statusCode, error)
            return
        }

        guard let data = response.data else {
            self = .error(response.r?.statusCode, NetworkErrors.noData)
            return
        }

        self = .data(data)
    }
}
```

### `Request.swift`
Contains our HttpMethod and RequestParameters enum which as their name implies, defines the type of requests being made and the body or url parameters
for the request. The file also contains the Request protocol and extension.
```swift
public enum HttpMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
    case patch  = "PATCH"
}

public enum RequestParams {
    case body(_ : Any?)
    case url(_ : [String : Any]?)
}

public protocol Request {
    var path: String { get }
    var method: HttpMethod { get }
    var parameters: RequestParams { get }
    var headers: [String : Any]? { get }
}

extension Request {
    public var method: HttpMethod { return .get }
    public var headers: [String : Any]? {  return nil }
}
```

### `Operation.swift`
Contains the enum for our Result response, defining if we get back good data or an error occurred. This file also contains
our Opertaion protocol which provides the Request object variable and a function to execute the request and return its output
```swift
public enum Result<T> {
    case data(_ : T)
    case error(_ : Error)
}

protocol Operation {
    associatedtype Output

    var request: Request { get }

    func execute(in dispatcher: Dispatcher, completion: @escaping (Result<Output>) -> Void)
}
```
### `NetworkDispatcher.swift`
The NetworkDispatcher file first contains the NetworkErrors enum that is used within our Response enum. After that we get to the meat
and potatoes of the all this networking, the NetworkDispatcher.

The `execute()` function starts by running the `prepareURLRequest()` function, which configures the the body, url, and headers as needed.
After getting the request object back from `prepareURLRequest()` the request is then made. Once the request is complete function will then
return the response in the completion handler, since this in an asynchronous function.
```swift
public class NetworkDispatcher: Dispatcher {
    private var environment: Environment
    private var session: URLSession
    private var requestCount = 0

    public required init(environment: Environment) {
        self.environment = environment
        self.session = URLSession(configuration: .default)
    }

    public func execute(_ request: Request, completion: @escaping (Response) -> Void) throws {
        let urlRequest = try prepareURLRequest(for: request)

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        requestCount += 1
        session.dataTask(with: urlRequest, completionHandler: { (data, urlResponse, error) in
            self.requestCount -= 1
            if self.requestCount == 0 {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
            completion(Response((urlResponse as? HTTPURLResponse, data, error), for: request))
        }).resume()
    }

    // MARK: - Private
    private func prepareURLRequest(for request: Request) throws -> URLRequest {
        let urlString = "\(environment.host)/\(request.path)"
        var urlRequest = URLRequest(url: URL(string: urlString)!)

        switch request.parameters {
        case .body(let params):
            switch params {
            case let dict as [String:Any]:
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: dict, options: .init(rawValue: 0))
            case let array as [[String:Any]]:
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: array, options: .init(rawValue: 0))
            default:
//                throw NetworkErrors.badInput
                break
            }

        case .url(let params):
            if let params = params as? [String : String] {
                let queryParams = params.map({ (element) -> URLQueryItem in
                    return URLQueryItem(name: element.key, value: element.value)
                })

                guard var components = URLComponents(string: urlString) else {
                    throw NetworkErrors.badInput
                }

                components.queryItems = queryParams
                urlRequest.url = components.url
            }
            else {
                throw NetworkErrors.badInput
            }
        }

        environment.headers.forEach { urlRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
        request.headers?.forEach { urlRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key) }

        urlRequest.httpMethod = request.method.rawValue

        return urlRequest
    }
}
```
