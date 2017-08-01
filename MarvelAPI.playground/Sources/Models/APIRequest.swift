import Foundation

/// All requests must conform to this protocol
/// - Discussion: You must conform to Encodable too, so that all stored public parameters
///   of types conforming this protocol will be encoded as parameters.
public protocol APIRequest: Encodable {
	/// Response (will be wrapped with a DataContainer)
	associatedtype Response: Decodable

	/// Endpoint for this request (the last part of the URL)
	var resourceName: String { get }
}
