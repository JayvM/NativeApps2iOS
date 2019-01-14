import UIKit

class LoginViewController: UIViewController {
    
    //Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
         Stack Overflow: Passing data from a view controller to a tableview controller through a navigation controller
         https://stackoverflow.com/questions/25369412/swift-pass-data-through-navigation-controller
         */
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
        errorLabel.text = ""
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
        
        errorLabel.text = "The E-mail or password is incorrect!"
    }

    @IBAction func newAccountButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "AccountSegue", sender: dataController)
    }
    
    @IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {
    }
}
