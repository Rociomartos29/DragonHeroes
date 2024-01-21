//
//  AuthService.swift
//  DragonHeroes
//
//  Created by Rocio Martos on 18/1/24.
//

import Foundation
class AuthService {

  private var token: String?

  func login(username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
    // Llamada API para autenticar
    let request = URLRequest(url: URL(string: "https://api.example.com/login")!)
    
    request.httpMethod = "POST"
    request.httpBody = "username=\(username)&password=\(password)".data(using: .utf8)

    URLSession.shared.dataTask(with: request) { data, response, error in
      if let error = error {
        completion(.failure(error))
        return
      }

      // Extraer token de la respuesta
      if let token = String(data: data!, encoding: .utf8) {
        self.token = token
        completion(.success(()))
      } else {
        completion(.failure(AuthError.invalidToken))
      }

    }.resume()
  }

  func getValidToken() -> String? {
    if let token = token, !expired(token) {
      return token
    }
    
    // Lógica para refrescar token si expiró
    refreshToken()
    
    return token
  }
  
  private func refreshToken() {
    // Llamada API para obtener nuevo token
    // Actualizar propiedad token
  }
  
  private func expired(_ token: String) -> Bool {
    // Verificar expiración de token
    return false
  }
  
  func logout() {
    // Lógica para invalidar token
  }
  
}
