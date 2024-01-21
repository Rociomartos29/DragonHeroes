//
//  TransformationsCollectionViewCell.swift
//  DragonHeroes
//
//  Created by Rocio Martos on 20/1/24.
//

import UIKit

class TransformationsCollectionViewCell: UICollectionViewCell {

    static let identifier = "TransformationsCell"
    @IBOutlet weak var NombreHero: UILabel?
    @IBOutlet weak var ImagenHero: UIImageView?
    var requestID: UUID?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with hero: HeroTransformation) {
           guard let url = URL(string: hero.photo) else {
               print("Invalid image URL: \(hero.photo)")
               return
           }
           NombreHero?.text = hero.name
           ImagenHero?.load(from: url)
       }
   }

