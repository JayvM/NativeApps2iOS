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
        updateLoginButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let session = dataController.session {
            self.performSegue(withIdentifier: "ChecklistsSegue", sender: session)
        }
    }
    
    /*
     USED AS GUIDANCE: How to pass data from a view controller to a tableview controller through a navigation controller
     SOURCE: https://stackoverflow.com/questions/25369412/swift-pass-data-through-navigation-controller
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChecklistsSegue" {
            let navigationController = segue.destination as? UINavigationController
            let checklistsTableViewController = navigationController?.viewControllers.first as! ChecklistsTableViewController
            let mainAccount = sender as! Account
            var checklists: [[Any]] = []
            
            for account in dataController.accounts {
                if account.email != mainAccount.email {
                    for checklist in account.checklists {
                        for sharedAccount in checklist.sharedAccounts {
                            if sharedAccount.email == mainAccount.email {
                                checklists.append([account.name, checklist])
                            }
                        }
                    }
                }
            }
            
            checklistsTableViewController.dataController = dataController
            checklistsTableViewController.account = mainAccount
            checklistsTableViewController.sharedChecklists = checklists
        }
        
        if segue.identifier == "AccountSegue" {
            let navigationController = segue.destination as? UINavigationController
            let accountTableViewController = navigationController?.viewControllers.first as! AccountTableViewController
            
            accountTableViewController.dataController = dataController
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
                dataController.writeSession(account)
                performSegue(withIdentifier: "ChecklistsSegue", sender: account)
                return
            }
        }
        
        let alert = UIAlertController(title: "Woops!", message: "The E-mail and/or password are incorrect.", preferredStyle: .alert)
        let tryAgain = UIAlertAction(title: "Try again", style: .default, handler: nil)
        
        alert.addAction(tryAgain)
        self.present(alert, animated: true)
    }

    @IBAction func newAccountButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "AccountSegue", sender: nil)
    }
    
    @IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {
    }
}
