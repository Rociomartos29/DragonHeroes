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
    init(hero: DragonBallHero, transformations: [HeroTransformation]) {
        // Código de inicialización aquí
        super.init(nibName: nil, bundle: nil) // Llamada al inicializador designado de UIViewController
    }
    
    // Inicializador requerido para conformar al protocolo NSCoding
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Inicialización personalizada, si es necesario
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if hero.transformations.isEmpty {
            transformationsButton.isHidden = true
        }
    }
    @IBAction func showTransformationsTapped() {
        
        /* let transformationsListVC = TransformacionesListTableViewController()
         transformationsListVC.hero = hero
         
         navigationController?.pushViewController(transformationsListVC, animated: true)
         
         }
         /*
          
          }
          */*/
    }
}
