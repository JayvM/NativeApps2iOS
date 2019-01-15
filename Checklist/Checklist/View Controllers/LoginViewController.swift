import UIKit

class LoginViewController: UIViewController {
    
    //Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var newAccountButton: UIButton!
    
    //Properties
    
    let dataController = DataController()
    
    //Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Temporary
        emailTextField.text = "jay@mail.com"
        passwordTextField.text = "pw"
        
        updateLoginButton()
    }
    
    /*
     USED AS GUIDANCE: How to pass data from a view controller to a tableview controller through a navigation controller
     SOURCE: https://stackoverflow.com/questions/25369412/swift-pass-data-through-navigation-controller
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChecklistsSegue" {
            let navigationController = segue.destination as? UINavigationController
            let checklistsTableViewController = navigationController?.viewControllers.first as! ChecklistsTableViewController
            
            checklistsTableViewController.dataController = sender as? DataController
        }
        
        if segue.identifier == "AccountSegue" {
            let navigationController = segue.destination as? UINavigationController
            let accountTableViewController = navigationController?.viewControllers.first as! AccountTableViewController
            
            accountTableViewController.dataController = sender as? DataController
        }
    }
    
    //Functions
    
    func updateLoginButton() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        loginButton.isEnabled = !email.isEmpty && !password.isEmpty
    }
    
    //Actions
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        updateLoginButton()
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        for account in dataController.accounts {
            if account.email == email && account.password == password {
                dataController.currentAccount = account
                performSegue(withIdentifier: "ChecklistsSegue", sender: dataController)
                return
            }
        }
        
        let alert = UIAlertController(title: "Woops!", message: "The E-mail and/or password are incorrect.", preferredStyle: .alert)
        let understood = UIAlertAction(title: "Let me try again", style: .default, handler: nil)
        
        alert.addAction(understood)
        self.present(alert, animated: true)
    }

    @IBAction func newAccountButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "AccountSegue", sender: dataController)
    }
    
    @IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {
    }
}
