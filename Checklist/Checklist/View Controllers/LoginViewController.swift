import UIKit

class LoginViewController: UIViewController {
    
    //Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    //Properties
    
    let dataController = DataController()
    
    //Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Temporary
        let account = dataController.getTestAccount()
        //dataController.insertAccount(account)
        emailTextField.text = account.email
        passwordTextField.text = account.password
        
        updateLoginButton()
        errorLabel.text = ""
    }
    
    /*
     Stack Overflow: Passing data from a view controller to a tableview controller through a navigation controller
     https://stackoverflow.com/questions/25369412/swift-pass-data-through-navigation-controller
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChecklistsSegue" {
            let navigationController = segue.destination as? UINavigationController
            let checklistsTableViewController = navigationController?.viewControllers.first as! ChecklistsTableViewController
            
            checklistsTableViewController.dataController = sender as? DataController
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
        let accounts = dataController.accounts
        let email = emailTextField.text
        let password = passwordTextField.text
        
        for account in accounts {
            if account.email == email && account.password == password {
                dataController.currentAccount = account
                performSegue(withIdentifier: "ChecklistsSegue", sender: dataController)
                return
            }
        }
        
        errorLabel.text = "The E-mail or password is incorrect!"
    }

    @IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {
        guard segue.identifier == "SaveAccountUnwind" else {
            return
        }
        
        let accountTableViewController = segue.source as! AccountTableViewController
        
        if let account = accountTableViewController.account {
            dataController.insertAccount(account)
        }
    }
}
