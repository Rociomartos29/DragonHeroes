//
//  transformacion.swift
//  DragonHeroes
//
//  Created by Rocio Martos on 16/1/24.
//

import Foundation
struct HeroTransformation: Codable {
    let name: String
    let photo: URL
    let id, description: String
}

extension HeroTransformation: Hashable{}
