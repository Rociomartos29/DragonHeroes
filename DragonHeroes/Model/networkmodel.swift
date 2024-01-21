//
//  networkmodel.swift
//  DragonHeroes
//
//  Created by Rocio Martos on 16/1/24.
//
import Foundation

final class NetworkModel {
    // Creamos un singleton de NetworkModel
    // Singleton significa que esta instancia va a estar "viva"
    // durante todo el ciclo de vida de la aplicacion
    
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
        
        // Creamos un string cuyo formato sea %@:%@
        
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
        let expiryDate = Date().addingTimeInterval(3600)
        UserDefaults.standard.set(expiryDate, forKey:"expiryDate")
        
    }
    
    // Verificar expiración
    
    func getHeroes(
        completion: @escaping (Result<[DragonBallHero], DragonBallError>) -> Void
    ) {
        
        var components = baseComponents
        components.path = "/api/heros/all"
        guard let url = components.url else {
            completion(.failure(.malformedURL))
            return
        }
        print("URL: \(url)")
        
        
        guard let token = self.token else {
            completion(.failure(.unknown))
            return
        }
        
        // Crear un objeto URLComponents, para encodificarlo posteriormente
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "name", value: "")]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
        print("Request: \(urlRequest)")
        client.request(urlRequest, using: [DragonBallHero].self, completion: completion)
        /*{ result in
         switch result {
         case let .success(heroes):
         completion(.success(heroes))
         case let .failure(error):
         completion(.failure(error))
         }
         }*/
        
    }
    func getTransformations(id: String, completion: @escaping (Result<[HeroTransformation], DragonBallError>) -> Void){
        var components = baseComponents
        components.path = "/api/heros/tranformations"
        
        guard let url = components.url else {
            completion(.failure(.malformedURL))
            return
        }
        print("Request URL: \(url)")
        guard let token = token else {
            completion(.failure(.unknown))
            return
        }
        
        let urlString = "\(url.absoluteString)?id=\(id)"
        guard let _ = URL(string: urlString) else {
            completion(.failure(.malformedURL))
            return
        }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = [URLQueryItem(name: "id", value: id)]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = urlComponents?.query?.data(using: .utf8)
        
        client.request(urlRequest, using: [HeroTransformation].self) { result in
            completion(result)
        }
        
    }
    func fetchData(completion: @escaping (Result<Data, DragonBallError>) -> Void) {
        let components = baseComponents
        guard let url = components.url else {
            completion(.failure(.malformedURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            var result: Result<Data, DragonBallError> = .failure(.unknown)
            
            if error != nil {
                result = .failure(.unknown)
            } else if let data = data {
                result = .success(data)
            }
            
            // Realizar la llamada a completion en el hilo principal
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        task.resume()
    }
}
