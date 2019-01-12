import Foundation

class Checklist: Codable {
    
    //Properties
    
    var name: String
    var items: [Item]
    var accounts: [Account]
    
    //Initializer
    
    init(name: String, items: [Item], accounts: [Account]) {
        self.name = name
        self.items = items
        self.accounts = accounts
    }
}
