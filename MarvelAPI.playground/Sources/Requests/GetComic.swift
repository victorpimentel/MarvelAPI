import Foundation

public struct GetComic: APIRequest {
	public typealias Response = [Comic]

	// Notice how we create a composed resourceName
	public var resourceName: String {
		return "comics/\(comicId)"
	}

	// Parameters
	private let comicId: Int

	public init(comicId: Int) {
		self.comicId = comicId
	}
}
