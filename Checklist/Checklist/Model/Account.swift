import Foundation

class Account: Codable {
    
    //Properties
    
    let id: Int
    var name: String
    var email: String
    var password: String
    var checklists: [Checklist]

    //Initializer
    
    init(id: Int, name: String, email: String, password: String, checklists: [Checklist]?) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.checklists = checklists ?? []
    }
    
    //Methods
    
    func addChecklist(_ checklist: Checklist) {
        checklists.append(checklist)
    }
    
    func removeChecklist(_ index: Int) {
        checklists.remove(at: index)
    }
}
