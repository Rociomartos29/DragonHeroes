//
//  TransformacionesDetailViewController.swift
//  DragonHeroes
//
//  Created by Rocio Martos on 17/1/24.
//

import UIKit

class TransformacionesDetailViewController: UIViewController {
    
    private let transform: HeroTransformation
    
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let imageView = UIImageView()
    
    // MARK: - Initialization
    
    init(transform: HeroTransformation) {
        self.transform = transform
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadTransformData()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        view.backgroundColor = .white
        
        nameLabel.font = .boldSystemFont(ofSize: 18)
        descriptionLabel.numberOfLines = 0
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, imageView, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
    }
    
    // MARK: - Data
    
    private func loadTransformData() {
        nameLabel.text = transform.name
        descriptionLabel.text = transform.description
        
        imageView.loadImage(from: transform.photo)
    }
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
    extension UIImageView {
      func loadImage(from url: URL) {
        // código para descargar y asignar imagen
      }
    }

