//
//  CeldaCollectionViewCell.swift
//  DragonHeroes
//
//  Created by Rocio Martos on 17/1/24.
//

import UIKit

        
        class CeldaCollectionViewCell: UICollectionViewCell {
            static let identifier = "CeldaCollectionViewCell"
            @IBOutlet weak var NombreHero: UILabel!
            @IBOutlet weak var ImagenHero: UIImageView!
            var requestID: UUID?
            override func awakeFromNib() {
                super.awakeFromNib()
                // Initialization code
            }
            
            func configure(with heroe:DragonBallHero){
                guard let url = URL(string: heroe.photo) else {
                    print("Invalid image URL: \(heroe.photo)")
                    return
                }
                NombreHero.text = heroe.name
                ImagenHero.load(from: url)
                guard let url = URL(string: heroe.photo) else {
                    print("Invalid image URL: \(heroe.photo)")
                    return
                }
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
