import Foundation

class Account: Codable {
    
    //Properties
    
    var name: String
    var email: String
    var password: String
    var checklists: [Checklist]
    
    //Static properties
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("accounts").appendingPathExtension("plist")

    //Initializer
    
    init(name: String, email: String, password: String, checklists: [Checklist]?) {
        self.name = name
        self.email = email
        self.password = password
        self.checklists = checklists ?? []
    }
    
    //Static methods
    
    static func getTestAccount() -> Account {
        let item1 = Item(name: "Bread")
        let item2 = Item(name: "Potatoes")
        let item3 = Item(name: "Chocolate")
        
        let items = [item1, item2, item3]
     
        let account1 = Account(name: "Patsy", email: "patsy@mail.com", password: "pw", checklists: [])
        let account2 = Account(name: "Eric", email: "eric@mail.com", password: "pw", checklists: [])
        
        let accounts = [account1, account2]
        
        let checklist = Checklist(name: "Grocery store", items: items, accounts: accounts)
        
        return Account(name: "Jay", email: "jay@mail.com", password: "pw", checklists: [checklist])
        
    }
    
    static func getAccounts() -> [Account]? {
        guard let encodedAccounts = try? Data(contentsOf: archiveURL) else {
            return nil
        }
        
        return try? PropertyListDecoder().decode(Array<Account>.self, from: encodedAccounts)
    }
    
    static func saveAccount(_ accounts: [Account]) {
        let encodedAccounts = try? PropertyListEncoder().encode(accounts)
        
        try? encodedAccounts?.write(to: archiveURL, options: .noFileProtection)
    }
}
