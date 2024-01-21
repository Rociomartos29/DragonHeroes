//
//  LoginViewController.swift
//  DragonHeroes
//
//  Created by Rocio Martos on 16/1/24.
//

import UIKit

final class LoginViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!


    // MARK: - Model
    private let model = NetworkModel.shared

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        _ = UIImage(named: "fondo4")
    }

    // MARK: - Actions

    
    @IBAction func didTapContinueButton(_ sender: Any) {
        zoomOut()
            model.login(
                user: emailTextField.text ?? "",
                password: passwordTextField.text ?? ""
            ) { [weak self] result in
                switch result {
                case let .success(token):
                    DispatchQueue.main.async {
                        let heroesListVC = HeroCollectionViewController()
                        if let navigationController = self?.navigationController {
                            navigationController.setViewControllers([heroesListVC], animated: true)
                        } else {
                            print("Error: No se encontró el controlador de navegación.")
                        }
                    }
                case let .failure(error):
                    print("🔴 \(error)")
                }
            }
        }
    func loginUser() {

        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
          return
        }

        model.login(
           user: emailTextField.text ?? "",
           password: passwordTextField.text ?? ""
         ) { [weak self] result in


             NetworkModel.shared.login(user: email, password: password) { [weak self] result in


               switch result {

                 case .success:
                   DispatchQueue.main.async{
                       let heroesListVC = HeroCollectionViewController();
                       self?.navigationController?.setViewControllers([heroesListVC], animated: true)
                   }
                 case .failure(let error):
                   print(error)

               }

             }
            
      }

    }

}

// MARK: - Animations
extension LoginViewController {
    func zoomIn() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            usingSpringWithDamping: 0.2,
            initialSpringVelocity: 0.5
        ) { [weak self] in
            self?.continueButton.transform = .identity
                .scaledBy(x: 0.94, y: 0.94)
        }
    }
    
    func zoomOut() {
        UIView.animate(
            withDuration: 0.15,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 2
        ) { [weak self] in
            self?.continueButton.transform = .identity
        }
    }
}
struct LoginResponse: Decodable {
  let token: String
}

func login(username: String, password: String) {

  let url = URL(string: "https://dragonball.keepcoding.education/api/login")!
  
  var request = URLRequest(url: url)
  request.httpMethod = "POST"
  
  let bodyData = "username=\(username)&password=\(password)"
  request.httpBody = bodyData.data(using: .utf8)
  
  let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
  
    guard let data = data, error == nil else {
      print(error?.localizedDescription ?? "Error desconocido")
      return
    }
    
      
    do {
      let json = try JSONDecoder().decode(LoginResponse.self, from: data)
      print("Login exitoso, token: ", json.token)
    } catch {
      print("Error decodificando JSON", error)
    }
  }
  
  task.resume()
  
}
