//
//  CeldaCollectionViewCell.swift
//  DragonHeroes
//
//  Created by Rocio Martos on 17/1/24.
//

import UIKit

class CeldaCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var NombreHero: UILabel!
    @IBOutlet weak var ImagenHero: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    func configure(with heroe: DragonBallHero) {
        NombreHero.text = heroe.name

        if let url = URL(string: heroe.photo) {
            // Descargar la imagen de forma asíncrona
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        // Asignar la imagen al UIImageView en el hilo principal
                        self.ImagenHero.image = image
                    }
                }
            }
        }
    }
}
