import Foundation

/// Implementation of a generic-based Marvel API client
public class MarvelAPIClient {
	private let baseEndpointUrl = URL(string: "https://gateway.marvel.com:443/v1/public/")!
	private let session = URLSession(configuration: .default)

	private let publicKey: String
	private let privateKey: String

	public init(publicKey: String, privateKey: String) {
		self.publicKey = publicKey
		self.privateKey = privateKey
	}

	/// Sends a request to Marvel servers, calling the completion method when finished
	public func send<T: APIRequest>(_ request: T, completion: @escaping ResultCallback<DataContainer<T.Response>>) {
		let endpoint = self.endpoint(for: request)

		let task = session.dataTask(with: URLRequest(url: endpoint)) { data, response, error in
			if let data = data {
				do {
					// Decode the top level response, and look up the decoded response to see
					// if it's a success or a failure
					let marvelResponse = try JSONDecoder().decode(MarvelResponse<T.Response>.self, from: data)

					if let dataContainer = marvelResponse.data {
						completion(.success(dataContainer))
					} else if let message = marvelResponse.message {
						completion(.failure(MarvelError.server(message: message)))
					} else {
						completion(.failure(MarvelError.decoding))
					}
				} catch {
					completion(.failure(error))
				}
			} else if let error = error {
				completion(.failure(error))
			}
		}
		task.resume()
	}

	/// Encodes a URL based on the given request
	/// Everything needed for a public request to Marvel servers is encoded directly in this URL
	private func endpoint<T: APIRequest>(for request: T) -> URL {
		guard let baseUrl = URL(string: request.resourceName, relativeTo: baseEndpointUrl) else {
			fatalError("Bad resourceName: \(request.resourceName)")
		}

		var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)!

		// Common query items needed for all Marvel requests
		let timestamp = "\(Date().timeIntervalSince1970)"
		let hash = "\(timestamp)\(privateKey)\(publicKey)".md5
		let commonQueryItems = [
			URLQueryItem(name: "ts", value: timestamp),
			URLQueryItem(name: "hash", value: hash),
			URLQueryItem(name: "apikey", value: publicKey)
		]

		// Custom query items needed for this specific request
		let customQueryItems: [URLQueryItem]

		do {
			customQueryItems = try URLQueryItemEncoder.encode(request)
		} catch {
			fatalError("Wrong parameters: \(error)")
		}

		components.queryItems = commonQueryItems + customQueryItems

		// Construct the final URL with all the previous data
		return components.url!
	}
}
