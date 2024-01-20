//
//  HeroCollectionViewController.swift
//  DragonHeroes
//
//  Created by Rocio Martos on 20/1/24.
//

import UIKit

private let reuseIdentifier = "HeroCell"

class HeroCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    private let model = NetworkModel.shared
    private var heroes: [DragonBallHero] = []

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 175, height: 175)
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CeldaCollectionViewCell.self, forCellWithReuseIdentifier: "HeroCell")
        return collectionView
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        setupView()
        fetchData()
    }

    private func setupView() {
        title = "Heroes"
    }

    private func fetchData() {
        model.getHeroes { [weak self] result in
            switch result {
            case let .success(heroes):
                self?.heroes = heroes
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case let .failure(error):
                print("Error fetching heroes: \(error)")
            }
        }
    }

    // MARK: - Collection View Data Source

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroCell", for: indexPath) as? CeldaCollectionViewCell else {
            fatalError("Unable to dequeue CeldaCollectionViewCell")
        }

        let hero = heroes[indexPath.item]
        cell.configure(with: hero)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle item selection if needed
    }
}
