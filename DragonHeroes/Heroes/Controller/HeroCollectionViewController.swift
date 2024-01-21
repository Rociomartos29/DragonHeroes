//
//  HeroCollectionViewController.swift
//  DragonHeroes
//
//  Created by Rocio Martos on 20/1/24.
//

import UIKit

private let reuseIdentifier = "HeroCell"

final class HeroCollectionViewController: UICollectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, DragonBallHero>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, DragonBallHero>
    var selectedHero: DragonBallHero?
    private let model = NetworkModel.shared
    private var dataSource: DataSource?
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
                
        collectionView.backgroundColor = .white
        title = "Heroes"
        
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
            
            guard collectionView.bounds.width > 0 else { return }
            
            let totalSpacing = layout.minimumInteritemSpacing * 2 + layout.sectionInset.left + layout.sectionInset.right
            let itemWidth = (collectionView.bounds.width - totalSpacing) / 2
            
            guard itemWidth > 0 else { return }
            
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
            
        }
    }
    
    private func configureCollectionView() {
        collectionView.register(UINib(nibName: "CeldaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HeroCell")
        
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, hero in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroCell", for: indexPath) as! CeldaCollectionViewCell
            cell.configure(with: hero)
            return cell
        }
        collectionView.dataSource = dataSource
    }
    
    private func fetchData() {
        model.getHeroes { [weak self] result in
            switch result {
            case let .success(heroes):
                var snapshot = Snapshot()
                snapshot.appendSections([0])
                snapshot.appendItems(heroes)
                self?.dataSource?.apply(snapshot, animatingDifferences: true)
                
            case let .failure(error):
                print("Error fetching heroes: \(error)")
            }
        }
    }
}

extension HeroCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedHero = dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        
        self.selectedHero = selectedHero
        
        let detailViewController = HDetailViewController(hero: selectedHero, transformations: [])
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
