//
//  CeldaCollectionViewCell.swift
//  DragonHeroes
//
//  Created by Rocio Martos on 17/1/24.
//

import UIKit

class CeldaCollectionViewCell: UICollectionViewCell {
    static let identifier = "HeroCell"
    @IBOutlet weak var NombreHero: UILabel?
    @IBOutlet weak var ImagenHero: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with hero: DragonBallHero) {
        guard let url = URL(string: hero.photo) else {
            print("Invalid image URL: \(hero.photo)")
            return
        }
        NombreHero?.text = hero.name
        ImagenHero?.load(from: url)
    }
}

extension UIImageView {
    func load(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
