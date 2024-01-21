//
//  TransformacionesListViewController.swift
//  DragonHeroes
//
//  Created by Rocio Martos on 17/1/24.
//

import UIKit
private let reuseIdentifier = "TransformationsCell"

final class TransformationsViewController: UICollectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, HeroTransformation>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, HeroTransformation>
    
    private let model = NetworkModel.shared
    private var dataSource: DataSource?
    private var hero: DragonBallHero
    private var transformations: [HeroTransformation]
    
    init(hero: DragonBallHero, transformations: [HeroTransformation]) {
        self.hero = hero
        self.transformations = transformations
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
        
        // Configure the collection view appearance
        collectionView.backgroundColor = .white
        
        title = "\(hero.name)'s Transformations"
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustCollectionViewLayout()
    }
    
    private func configureCollectionView() {
        collectionView.register(UINib(nibName: "TransformationsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TransformationsCell")
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, transformation in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransformationsCell", for: indexPath) as! TransformationsCollectionViewCell
            cell.configure(with: transformation)
            return cell
        }
        
        collectionView.dataSource = dataSource
    }
    
    private func fetchData() {
        model.getTransformations { [weak self] (result: Result<[HeroTransformation], DragonBallError>) in
               
               switch result {
               case let .success(transformations):
                   print("Transformations: \(transformations)")

                   // Imprime la respuesta del servidor antes de la decodificación
                   if let data = try? JSONSerialization.data(withJSONObject: transformations, options: .prettyPrinted),
                      let jsonString = String(data: data, encoding: .utf8) {
                       print("Server Response JSON:\n\(jsonString)")
                   }

                   var snapshot = Snapshot()
                   snapshot.appendSections([0])
                   snapshot.appendItems(transformations, toSection: 0)
                   self?.dataSource?.apply(snapshot, animatingDifferences: true)
                   
               case let .failure(error):
                   print("Error fetching transformations: \(error)")
                   // Handle the error appropriately, e.g., show an alert to the user
               }
           }
       }
    
    private func adjustCollectionViewLayout() {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        
        // Asegúrate de que el ancho de la colección sea mayor que cero
        guard collectionView.bounds.width > 0 else {
            return
        }
        
        // Calcula el ancho del elemento teniendo en cuenta el espaciado y el borde
        let totalSpacing = layout.minimumInteritemSpacing * 2 + layout.sectionInset.left + layout.sectionInset.right
        let itemWidth = (collectionView.bounds.width - totalSpacing) / 2
        
        // Asegúrate de que el ancho de la celda sea mayor que cero
        guard itemWidth > 0 else {
            return
        }
        
        // Ajusta la altura según sea necesario
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
}
