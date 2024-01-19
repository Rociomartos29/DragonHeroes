//
//  TransformationsViewController.swift
//  DragonHeroes
//
//  Created by Rocio Martos on 17/1/24.
//

import UIKit
class TransformationsView: UIView {

  // aquí puedes agregar subvistas, constraints, etc
   // let coordinator: TransformationsCoordinator?
      
      ///init(coordinator: TransformationsCoordinator?) {
        ///self.coordinator = coordinator
         /// super.init(frame: .zero)
      }
    
   /// required init?(coder: NSCoder) {
      ///  fatalError("init(coder:) has not been implemented")
    ///}
    


  
   


class TransformationsViewController: UIViewController {

    private let transformationsView = TransformationsView.self

  override func viewDidLoad() {
    super.viewDidLoad()
    
      let transformationsView = TransformationsView.self // crear instancia

  }

}
