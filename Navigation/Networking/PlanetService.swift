import Foundation

enum NetworkError: Error {
   case emptyUrl
   case emptyJson
   case parsingInvalid
}

struct Planet: Codable {
    let name, rotationPeriod, orbitalPeriod, diameter: String
    let climate, gravity, terrain, surfaceWater: String
    let population: String
    let residents: [URL]
    let films: [String]
    let created, edited: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case name
        case rotationPeriod = "rotation_period"
        case orbitalPeriod = "orbital_period"
        case diameter, climate, gravity, terrain
        case surfaceWater = "surface_water"
        case population, residents, films, created, edited, url
    }
}

class PlanetService {
    
    func makePlanetInfoRequest(completion: @escaping (Result<Planet, NetworkError>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "swapi.dev"
        urlComponents.path = "/api/planets/1"
        
        guard let url = urlComponents.url else {
            completion(.failure(.emptyUrl))
            return
        }
        let request = URLRequest(url: url)
        
        URLSession(configuration: .default).dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(.failure(.emptyJson))
                return
            }
            
            do {
                let planet = try JSONDecoder().decode(Planet.self, from: data)
                print(planet, planet.residents)
                DispatchQueue.main.async {
                    completion(.success(planet))
                }
            } catch {
                completion(.failure(.parsingInvalid))
            }
        }.resume()
    }
}
