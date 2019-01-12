import Foundation

class Account: Codable {
    
    //Properties
    
    var name: String
    var email: String
    var password: String
    
    //Static properties
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("accounts").appendingPathExtension("plist")

    //Initializer
    
    init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
    
    //Static methods
    
    static func getAccounts() -> [Account]? {
        guard let accounts = try? Data(contentsOf: archiveURL) else {
            return nil
        }
        
        return try? PropertyListDecoder().decode(Array<Account>.self, from: accounts)
    }
}
