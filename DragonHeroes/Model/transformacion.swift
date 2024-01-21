//
//  transformacion.swift
//  DragonHeroes
//
//  Created by Rocio Martos on 16/1/24.
//

import Foundation
struct HeroTransformation: Codable, Hashable {
    
    let name: String
    let photo: String
    
    // Definir id como String
    let id: String
    
    let description: String
    
    private enum CodingKeys: String, CodingKey {
        case name, photo, description
        case id = "_id"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        photo = try container.decode(String.self, forKey: .photo)
        description = try container.decode(String.self, forKey: .description)
        
        // Decodificar id como String
        id = try container.decode(String.self, forKey: .id)
    }
    
    // Función para convertir a UUID si necesario
    func uuid() -> UUID? {
        // Validar que el string sea un UUID válido
        guard let uuid = UUID(uuidString: id) else {
            return nil
        }
        
        return uuid
    }
}
