import Foundation



struct Person: Codable {
    let name: String
    let films: [URL]
}

struct Film: Codable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

class SwapiService: Codable {
    
    static private let baseURL = URL(string: "https://swapi.co/api/")
    static private let personEndpoint = "people/"
        
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
      // 1 - Prepare URL
        guard let baseURL = baseURL else {return completion(nil)}
        let finalURL = baseURL.appendingPathComponent(personEndpoint)
        let finalFinalURL = finalURL.appendingPathComponent("\(id)")
        print(finalFinalURL)
      // 2 - Contact server
        URLSession.shared.dataTask(with: finalFinalURL) { (data, _, error) in
            // 3 - Handle errors
            if let error = error {
                print(error, error.localizedDescription)
                return completion(nil)
            }
             // 4 - Check for data
            guard let data = data else {return completion(nil)}
             // 5 - Decode Person from JSON
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                return completion(person)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
      // 1 - Contact server
        URLSession.shared.dataTask(with:url) { (data, _, error) in
      // 2 - Handle errors
            if let error = error {
                print(error, error.localizedDescription)
                return completion(nil)
            }
      // 3 - Check for data
            guard let data = data else {return completion(nil) }
            do {
            let topLevelObject = try JSONDecoder().decode(Film.self, from: data)
                let films = topLevelObject.self
            return completion(films)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
      // 4 - Decode Film from JSON
        }.resume()
    }
}

func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { film in
        if let film = film {
            print(film.title)
        }
    }
}
    
SwapiService.fetchPerson(id: 11) { person in
  if let person = person {
      print(person)
    for film in person.films {
        fetchFilm(url: film)
    }
  }
}

