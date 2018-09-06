import Foundation

public struct ComicCharacter: Decodable {
	public let id: Int
	public let name: String?
	public let description: String?
	public let thumbnail: Image?
}
