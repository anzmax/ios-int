import Foundation

struct Resident: Codable {
    let name, height, mass, hairColor: String
    let skinColor, eyeColor, birthYear, gender: String
    let homeworld: String
    let films: [String]
    let vehicles, starships: [String]
    let created, edited: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case name, height, mass
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case gender, homeworld, films, vehicles, starships, created, edited, url
    }
}

class ResidentService {
    func makeResidentRequest(url: URL, completion: @escaping (Result<Resident, NetworkError>) -> Void) {
        let request = URLRequest(url: url)
        URLSession(configuration: .default).dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.emptyJson))
                return
            }
            
            do {
                let resident = try JSONDecoder().decode(Resident.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(resident))
                }
            } catch {
                completion(.failure(.parsingInvalid))
            }
        }.resume()
    }
}
