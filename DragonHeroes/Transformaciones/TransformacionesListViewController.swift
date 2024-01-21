//
//  TransformacionesListViewController.swift
//  DragonHeroes
//
//  Created by Rocio Martos on 17/1/24.
//

import UIKit

final class TransformationsViewController: UICollectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, HeroTransformation>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, HeroTransformation>
    
    private let model = NetworkModel.shared
    private var dataSource: DataSource?
    private var hero: DragonBallHero
    

    
    init(hero: DragonBallHero) {
        self.hero = hero
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
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            layout.minimumInteritemSpacing = 20
            layout.minimumLineSpacing = 20
            
            guard collectionView.bounds.width > 0 else {
                print("Invalid collection view width: \(collectionView.bounds.width)")
                return
            }
            
            let totalSpacing = layout.minimumInteritemSpacing * 2 + layout.sectionInset.left + layout.sectionInset.right
            let itemWidth = (collectionView.bounds.width - totalSpacing) / 2
            
            guard itemWidth > 0 else {
                print("Invalid item width: \(itemWidth)")
                return
            }
            
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
            
        }
    }
    
    private func configureCollectionView() {
        // Register cell
        collectionView.register(UINib(nibName: "TransformationsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TransformationsCell")
        
        // Set up data source
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, transformation in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransformationsCell", for: indexPath) as! TransformationsCollectionViewCell
            // Configure the cell with hero and transformation data
            cell.configure(with: transformation)
            return cell
        }
        collectionView.dataSource = dataSource
    }
    
    private func fetchData() {
        let heroID = self.hero.id
        if !heroID.isEmpty {
            
            model.getTransformations(id: heroID) { [weak self] result in
                switch result {
                case let .success(transformations):
                    var snapshot = Snapshot()
                    snapshot.appendSections([0])
                    snapshot.appendItems(transformations)
                    
                    // Limpia la colección antes de aplicar el nuevo snapshot
                    self?.dataSource?.apply(snapshot, animatingDifferences: false)
                    
                case let .failure(error):
                    print("Error fetching transformations: \(error)")
                }
            }
        } else {
            print("Error: el ID del héroe es nulo")
        }
    }
}
extension TransformationsViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard let selectedTransformation = dataSource?.itemIdentifier(for: indexPath) else {
                return
            }

            // Crear instancia de TDetailViewController y pasar la transformación
            let detailViewController = TDetailViewController(transform: selectedTransformation)
            // Utiliza el UINavigationController proporcionado para la navegación
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }

