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

        // Esta seria la forma correcta de representar una imagen
        // desde los assets de nuestro proyecto.
        _ = UIImage(named: "fondo4")
    }

    // MARK: - Actions
    @IBAction func buttonTouchCancel(_ sender: Any) {
        zoomOut()
    }
    
    @IBAction func buttonTouchDown(_ sender: Any) {
        zoomIn()
    }
    
    
    @IBAction func didTapContinueButton(_ sender: Any) {
        zoomOut()
        let heroesListVC = HeroesListViewController()
        navigationController?.pushViewController(heroesListVC, animated: true);
        model.login(
            user: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        ) { [weak self] result in
//            guard let self else { return }
            switch result {
                case let .success(token):
                    DispatchQueue.main.async {
                        let heroesListViewController = UIViewController()
                        self?.navigationController?.setViewControllers([heroesListViewController], animated: true)
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

           guard let self = self else { return }

             NetworkModel.shared.login(user: email, password: password) { [weak self] result in

               guard let self = self else { return }

               switch result {

                 case .success(let token):
                   // Navegar al listado de héroes
                   let heroesListVC = HeroesListViewController()
                   self.navigationController?.pushViewController(heroesListVC, animated: true)

                 case .failure(let error):
                   // Manejar el error
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

  // 1. Construir URL
  let url = URL(string: "https://dragonball.keepcoding.education/api/login")!
  
  // 2. Configurar el request
  var request = URLRequest(url: url)
  request.httpMethod = "POST"
  
  let bodyData = "username=\(username)&password=\(password)"
  request.httpBody = bodyData.data(using: .utf8)
  
  // 3. Hacer request con URLSession
  let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
  
    // 4. Verificar respuesta
    guard let data = data, error == nil else {
      print(error?.localizedDescription ?? "Error desconocido")
      return
    }
    
    // 5. Decodificar respuesta JSON
    do {
      let json = try JSONDecoder().decode(LoginResponse.self, from: data)
      print("Login exitoso, token: ", json.token)
    } catch {
      print("Error decodificando JSON", error)
    }
  }
  
  // 6. Comenzar tarea
  task.resume()
  
}
