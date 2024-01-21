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

        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
        
        func configure(with transformation: HeroTransformation) {
            guard let url = URL(string: transformation.photo) else {
                print("Invalid image URL: \(transformation.photo)")
                return
            }
            
            NombreHero?.text = transformation.name
            ImagenHero?.load(from: url)
        }
    }
