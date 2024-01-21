//
//  HeroesListViewController.swift
//  DragonHeroes
//
//  Created by Rocio Martos on 17/1/24.
//

import UIKit

class HeroesListViewController: UITableViewController {
    
    private let model = NetworkModel.shared
    private var heroes: [DragonBallHero] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    private func setupView() {
        title = "Heroes"
        tableView.register(CeldaCollectionViewCell.self, forCellReuseIdentifier: "HeroCell")
    }
    
    private func fetchData() {
        model.getHeroes { [weak self] result in
            switch result {
            case let .success(heroes):
                self?.heroes = heroes
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case let .failure(error):
                print("Error fetching heroes: \(error)")
            }
        }
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeroCell", for: indexPath) as! CeldaCollectionViewCell
        let hero = heroes[indexPath.row]
        cell.configure(with: hero)
        return cell
    }
    
}
