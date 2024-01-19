//
//  Hero.swift
//  DragonHeroes
//
//  Created by Rocio Martos on 16/1/24.
//

import Foundation
struct DragonBallHero:Codable, Hashable{
    
    let photo: String
    let id, name, description: String

    var transformations: [HeroTransformation]

    
}


