import Foundation

class Checklist: Codable {
    
    //Properties
    
    var name: String
    var items: [Item]
    var accounts: [Int]
    
    //Initializer
    
    init(name: String, items: [Item]?, accounts: [Int]?) {
        self.name = name
        self.items = items ?? []
        self.accounts = accounts ?? []
    }
}
