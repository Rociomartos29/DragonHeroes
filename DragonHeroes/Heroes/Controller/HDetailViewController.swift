//
//  HDetailViewController.swift
//  DragonHeroes
//
//  Created by Rocio Martos on 17/1/24.
//

import UIKit

class HDetailViewController: UIViewController {
    
    @IBOutlet weak var ImagenHero: UIImageView!
    @IBOutlet weak var NombreHero: UILabel!
    @IBOutlet weak var DescripcionHero: UILabel!
    @IBOutlet weak var transformationsButton: UIButton!
    var hero: DragonBallHero!
    let model = NetworkModel.shared
    
    init(hero: DragonBallHero, transformations: [HeroTransformation]) {
        super.init(nibName: nil, bundle: nil)
        self.hero = hero
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configura la vista con los datos del héroe
        configureView()
    }
    
    func configureView() {
        
        guard let url = URL(string: hero.photo) else {
            print("Invalid image URL: \(hero.photo)")
            return
        }
        ImagenHero.loadImage(from: url)
        NombreHero.text = hero.name
        DescripcionHero.text = hero.description
    }
    
    @IBAction func transformationsButtonTapped(_ sender: UIButton) {
        // Manejar la acción del botón de transformaciones
        showTransformations()
    }
    
    func showTransformations() {
        let heroID = self.hero.id
        if !heroID.isEmpty {
            
            // Solicitar las transformaciones para el héroe actual
            model.getTransformations(id: heroID) { [weak self] result in
                switch result {
                case let .success(transformations):
                    // Crear instancia de TransformationsViewController y pasar el héroe y las transformaciones
                    DispatchQueue.main.async { [weak self] in
                        let transformationsListVC = TransformationsViewController(hero: self!.hero)
                        self?.navigationController?.pushViewController(transformationsListVC, animated: true)
                    }
                    
                case let .failure(error):
                    print("Error fetching transformations: \(error)")
                }
            }
        }else {
            print("Error: el ID del héroe es nulo")
        }
    }
}

