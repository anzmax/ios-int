import Foundation

struct Person: Decodable {
    var userId: Int
    var id: Int
    var title: String
}


class PersonService {
    
    func makePersonInfoRequest(completion: @escaping (String?) -> Void) {
        if let url = URL(string: "https://jsonplaceholder.typicode.com/todos/7") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    completion(nil)
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let title = json["title"] as? String {
                        DispatchQueue.main.async {
                            completion(title)
                        }
                    } else {
                        print("Failed to parse JSON")
                        completion(nil)
                    }
                } catch let parseError {
                    print("Error parsing JSON: \(parseError.localizedDescription)")
                    completion(nil)
                }
            }.resume()
        }
    }
}
