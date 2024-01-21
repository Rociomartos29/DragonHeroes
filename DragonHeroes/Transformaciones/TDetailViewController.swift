//
//  TDetailViewController.swift
//  DragonHeroes
//
//  Created by Rocio Martos on 20/1/24.
//

import UIKit

class TDetailViewController: UIViewController {

    @IBOutlet weak var Descripcion: UILabel!
    @IBOutlet weak var ImageTransformation: UIImageView!
    @IBOutlet weak var Name: UILabel!
    var transformation: HeroTransformation!
        let model = NetworkModel.shared
        
        init(transform: HeroTransformation) {
            super.init(nibName: nil, bundle: nil)
            self.transformation = transform
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            fatalError("init(coder:) has not been implemented")
        }
        
        // MARK: - Lifecycle
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            setupUI()
        }
        
        // MARK: - UI
        
        private func setupUI() {
            guard let url = URL(string: transformation.photo) else {
                   print("Invalid image URL: \(transformation.photo)")
                   return
               }
               ImageTransformation.loadImage(from: url)
            
            Name.text = transformation.name
            Descripcion.text = transformation.description
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        }
        
        // MARK: - Data
        
        @objc private func goBack() {
            navigationController?.popViewController(animated: true)
        }
    }


extension UIImageView {
    func loadImage(from url: URL) {
        print("Cargando imagen desde \(url)")

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error cargando imagen: \(error)")
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("No se pudo crear una imagen desde los datos descargados.")
                return
            }

            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
    }
}
