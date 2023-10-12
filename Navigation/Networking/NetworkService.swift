import Foundation

enum AppConfiguration {
    case peopleURL(URL)
    case starshipsURL(URL)
    case planetsURL(URL)
    
    init?(_ urlString: String) {
        if let url = URL(string: urlString) {
            switch urlString {
                
            case "https://swapi.dev/api/people/8":
                self = .peopleURL(url)
                
            case "https://swapi.dev/api/starships/3":
                self = .starshipsURL(url)
                
            case "https://swapi.dev/api/planets/5":
                self = .planetsURL(url)
            default:
                return nil
            }
        } else {
            return nil
        }
    }
}

struct NetworkService {

    static func request(for configuration: AppConfiguration) {
        let url: URL
        
        switch configuration {
        case .peopleURL(let peopleURL), .starshipsURL(let peopleURL), .planetsURL(let peopleURL):
            url = peopleURL
        }
        
        let request = URLRequest(url: url)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Ошибка при выполнении запроса: \(error.localizedDescription)")
                return
            }

            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("JSON Data: \(json)")
                    } else if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                        print("JSON Array Data: \(jsonArray)")
                    } else {
                        if let dataString = String(data: data, encoding: .utf8) {
                            print("Data: \(dataString)")
                        }
                    }
                } catch {
                    print("Ошибка при разборе JSON: \(error.localizedDescription)")
                }
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                print("Response Headers: \(httpResponse.allHeaderFields)")
            }
        }
        task.resume()
    }
}





