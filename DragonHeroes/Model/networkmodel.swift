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
    }
    
    func getHeroes(
        completion: @escaping (Result<[DragonBallHero], DragonBallError>) -> Void
    ) {
        var components = baseComponents
        components.path = "/api/heros/all"
        guard let url = components.url else {
            completion(.failure(.malformedURL))
            return
        }
        
        guard let token else {
            completion(.failure(.unknown))
            return
        }
        
        // Crear un objeto URLComponents, para encodificarlo posteriormente
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "name", value: "")]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        // Encodificamos el query item de url components
        urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
        
        client.request(urlRequest, using: [DragonBallHero].self, completion: completion)
    }
    func getTransformations(completion: @escaping (Result<[HeroTransformation], DragonBallError>)->Void){
        var components = baseComponents
        components.path = "/api/heros/tranformations"
        guard let url = components.url else{
            completion(.failure(.malformedURL))
            return
        }
        guard let token else{
            completion(.failure(.unknown))
            return
        }
        var urlComponents = URLComponents()
        urlComponents.queryItems = [URLQueryItem(name: "name", value: "")]
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        // Encodificamos el query item de url components
        urlRequest.httpBody = urlComponents.query?.data(using: .utf8)
        
        client.request(urlRequest, using: [HeroTransformation].self, completion: completion)
    }
    func fetchData(completion: @escaping (Result<Data, DragonBallError>) -> Void) {
        var components = baseComponents
        guard let url = components.url else { completion(.failure(.malformedURL))
            return}
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            var result: Result<Data, DragonBallError> =  .failure(.unknown)
            if let error = error {
                  // Error
                result = .failure(.unknown)
                } else if let data = data {
                  // Éxito
                  result = .success(data)

                  // Imprimir data
                  print(String(data: data, encoding: .utf8)!)

                }

                // 5. Pasar resultado completo
                completion(result)
              }

              // 6. Ejecutar tarea
              task.resume()

            }
}




