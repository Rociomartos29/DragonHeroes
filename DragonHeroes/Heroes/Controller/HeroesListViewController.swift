//
//  HeroesListViewController.swift
//  DragonHeroes
//
//  Created by Rocio Martos on 17/1/24.
//

import UIKit

class HeroesListViewController: UICollectionViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, DragonBallHero>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, DragonBallHero>
    
    private let networkmodel = NetworkModel()
    private let model = NetworkModel.shared
    private var dataSource: DataSource?
    init() {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: 175, height: 175)
            layout.scrollDirection = .vertical
            super.init(collectionViewLayout: layout)
            
            //configureCollectionView()
           // configureNavigationBar()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //MARK: - View Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            print("Estoy funcionando")
            
            
            
            setupView()
            configureDataSource()
            fetchHeroes()
            model.fetchData { result in
                switch result {
                  case .success(let data):
                    print(String(data: data, encoding: .utf8)!)
                  case .failure(let error):
                    print(error)
                }
              }
            
        }
        
        //MARK: - Configuration Methods
    
        private func configureCollectionView() {
            collectionView.contentInset.left = 16
            collectionView.contentInset.right = 16
        }
        
        private func configureNavigationBar() {
            let logo = UIImage(named: "DragonBallLogo")
            let imageView = UIImageView(image: logo)
            imageView.contentMode = .scaleAspectFit
            
            navigationItem.titleView = imageView
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(logOut))
            
        }
        
        private func configureDataSource() {
            /*let registration = UICollectionView.CellRegistration<
                        CharacterCollectionViewCell,
                        GOTCharacter
                    >(
                        cellNib: UINib(
                            nibName: CharacterCollectionViewCell.identifier,
                            bundle: nil
                        )
                    ) { cell, _, character in
                        cell.configure(with: character)
                    }*/
            
            
            let registration = UICollectionView.CellRegistration<CeldaCollectionViewCell, DragonBallHero> (
            cellNib: UINib(
                nibName: "CeldaCollectionViewCell",
                bundle: nil)){
                    
                    cell, _, hero in
                    cell.configure(with: hero)
                }
            
            dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, hero in
                collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: hero)
            }
            
            collectionView.dataSource = dataSource
        }
        
        //MARK: - Data Fetching
    private func fetchHeroes() {
        model.getHeroes { [weak self] (result: Result<[DragonBallHero], DragonBallError>) in
            switch result {
            case let .success(heroes):
                print(heroes)
                DispatchQueue.main.async{
                    var snapshot = Snapshot()
                    snapshot.appendSections([0])
                    snapshot.appendItems(heroes)
                    self?.dataSource?.apply(snapshot)
                }
            case let .failure(error):
                print(error)
            }
        }
    }
        
        //MARK: - Action Methods
        @objc
        private func logOut() {
            let loginVC = LoginViewController()
            navigationController?.setViewControllers([loginVC], animated: true)
        }
        
        //MARK: - Navigation
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard (dataSource?.itemIdentifier(for: indexPath)) != nil else { return }
        
        _ = NetworkModel()  // Crear una instancia de NetworkModel
        _ = NetworkModel.shared.token
        /*networkModel.getTransformations( forHero: heroSelected) { [weak self] result in
            switch result {
            case let .success(listadoTransform):
                DispatchQueue.main.async {
                    let heroDetailViewController = HDetailViewController(hero: heroSelected, transformations: listadoTransform)
                    self?.navigationController?.show(heroDetailViewController, sender: nil)
                    }
                }
            case let .failure(error):
                print(error)*/
            
        }
    }

private extension HeroesListViewController{
    func setupView (){
        title = "Heroes"
    }
}
