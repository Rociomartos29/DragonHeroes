//
//  networkmodel.swift
//  DragonHeroes
//
//  Created by Rocio Martos on 16/1/24.
//

import Foundation
final class NetworkModel {
    var authToken: String?

    static let shared = NetworkModel()
    
     var token: String? {
        get {
            if let token = LocalDataModel.getToken() {
                return token
            }
            return nil
        }
        set {
            if let token = newValue {
                LocalDataModel.save(token: token)
            }
        }
    }
    
    private var baseComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "dragonball.keepcoding.education"
        return components
    }
    
    private let client: APIClientProtocol
    
    // Ponemos el inicializador privado, para prevenir
    // que NetworkModel sea instanciado desde fuera.
    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }
    
    func login(
        user: String,
        password: String,
        completion: @escaping (Result<String, DragonBallError>) -> Void
    ) {
        var components = baseComponents
        components.path = "/api/auth/login"
        
        guard let url = components.url else {
            completion(.failure(.malformedURL))
            return
        }
        
        
        let loginString = String(format: "%@:%@", user, password)
        // Encodificamos el login string a un objeto Data
        guard let loginData = loginString.data(using: .utf8) else {
            completion(.failure(.encodingFailed))
            return
        }
        // Encodificamos la string con un algoritmo criptografico
        // en base 64
        let base64LoginString = loginData.base64EncodedString()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        client.jwt(urlRequest) { [weak self] result in
            switch result {
            case let .success(token):
                self?.token = token
                completion(.success(token))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    func getTransformations(forHero hero: DragonBallHero, completion: @escaping (Result<[HeroTransformation], Error>) -> Void) {

      // Construir URL
      guard let url = URL(string: "https://dragonball.keepcoding.education/heroes/\(hero.id)/transformations") else {
        completion(.failure(URLError(.badURL)))
        return
      }

      // Configurar request
      var request = URLRequest(url: url)
      request.httpMethod = "GET"
      
      // Agregar token al header
      request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

      // Hacer request
      let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

        guard let data = data, error == nil else {
          completion(.failure(error!))
          return
        }

        // Parsear respuesta JSON
        do {
          let transformations = try JSONDecoder().decode([HeroTransformation].self, from: data)
          completion(.success(transformations))
        } catch {
          completion(.failure(error))
        }

      }

      task.resume()

    }
    
    func getHeroes(
        completion: @escaping (Result<[DragonBallHero], DragonBallError>) -> Void
    ) {
        var components = baseComponents
        components.path = "https://dragonball.keepcoding.education/api/heros/all"
        
        guard let url = components.url else {
            completion(.failure(.malformedURL))
            return
        }
    
        guard let token = self.token else {
            completion(.failure(.unknown))
            return
        }

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: "name", value: "")]
        
        guard let finalURL = urlComponents?.url else {
            completion(.failure(.malformedURL))
            return
        }

        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = "POST"

        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
   
        client.request(urlRequest, using: [DragonBallHero].self, completion: completion)
    }
}
