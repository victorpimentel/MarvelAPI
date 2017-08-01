import Cocoa
import PlaygroundSupport

// Put your own keys!
// You can freely get a key here: https://developer.marvel.com/docs
let apiClient = MarvelAPIClient(publicKey: "650e801e1408159969078d2a1361c71c",
                                privateKey: "20112b45612fd05f0d21d80d70bc8c971695c7f1")

// A simple request with no parameters
apiClient.send(GetCharacters()) { response in
	print("\nGetCharacters finished:")

	switch response {
	case .success(let dataContainer):
		for character in dataContainer.results {
			print("  Title: \(character.name ?? "Unnamed character")")
			print("  Thumbnail: \(character.thumbnail?.url.absoluteString ?? "None")")
		}
	case .failure(let error):
		print(error)
	}
}

// Another request filling interesting optional parameters, a string and an enum
apiClient.send(GetComics(titleStartsWith: "Avengers", format: .digital)) { response in
	print("\nGetComics finished:")

	switch response {
	case .success(let dataContainer):
		for comic in dataContainer.results {
			print("  Title: \(comic.title ?? "Unnamed comic")")
			print("  Thumbnail: \(comic.thumbnail?.url.absoluteString ?? "None")")
		}
	case .failure(let error):
		print(error)
	}
}

// Yet another request with a mandatory parameter
apiClient.send(GetComic(comicId: 61537)) { response in
	print("\nGetComic finished:")

	switch response {
	case .success(let dataContainer):
		let comic = dataContainer.results.first

		print("  Title: \(comic?.title ?? "Unnamed comic")")
		print("  Thumbnail: \(comic?.thumbnail?.url.absoluteString ?? "None")")
	case .failure(let error):
		print(error)
	}
}

PlaygroundPage.current.needsIndefiniteExecution = true
