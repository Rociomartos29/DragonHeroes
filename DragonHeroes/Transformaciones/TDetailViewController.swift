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
    var transformation: HeroTransformation

        init(transform: HeroTransformation) {
            self.transformation = transform
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        //loadTransformData()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        guard let url = URL(string: transformation.photo) else {
               print("Invalid image URL: \(transformation.photo)")
               return
           }
           ImageTransformation.loadImage(from: url)
        view.backgroundColor = .white
        
        Name.text = transformation.name
        Descripcion.text = transformation.description
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Heroe", style: .plain, target: self, action: #selector(goBack))
    }
    
    // MARK: - Data
   
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
    extension UIImageView {
        func loadImage(from url: URL) {
                // Verifica que la URL sea válida
                guard url.scheme != nil else {
                    print("Invalid URL: \(url)")
                    return
                }

                // Descargar la imagen de la URL
                URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
                    guard let data = data, error == nil else {
                        print("Error loading image from URL: \(url), error: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }

                    // Crear una imagen desde los datos descargados
                    if let image = UIImage(data: data) {
                        // Asignar la imagen al UIImageView en el hilo principal
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    } else {
                        print("Error creating image from data")
                    }
                }.resume()
            }
        }
