//
//  TransformacionesListViewController.swift
//  DragonHeroes
//
//  Created by Rocio Martos on 17/1/24.
//

/*import UIKit

class TransformacionesListTableViewController: UITableViewController {

  var hero: DragonBallHero!
var transformationsCoordinator: TransformationsCoordinator?

  override func viewDidLoad() {
    super.viewDidLoad()
      let token = NetworkModel.shared.token
      NetworkModel.shared.getTransformations( forHero: hero) { result in
      
      // Crear un coordinador para SwiftUI
        switch result {
            case .success(let transformations):
              let coordinator = TransformationsCoordinator(transformations: transformations)

        case .failure(let error): break
              // Manejar error
          }

        }
      // Agregar la vista de SwiftUI como una subview
      let transformationsView = TransformationsView(coordinator: transformationsCoordinator)
      transformationsView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(transformationsView)
      
      // Ajustar constraints
      transformationsView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
      transformationsView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
      transformationsView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
      transformationsView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
      
    }

  }



// Coordinador para manejar navegación
class TransformationsCoordinator: NSObject, UINavigationControllerDelegate {
    
    let transformations: [HeroTransformation]
    
    init(transformations: [HeroTransformation]) {
        self.transformations = transformations
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Manejar navegación
    }
    
}*/
