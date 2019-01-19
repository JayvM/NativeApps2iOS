import Foundation

class Item: Codable {
    
    //Properties
    
    var name: String
    var imageId: Int?
    var note: String?
    
    //Initializer
    
    init(name: String, imageId: Int?, note: String?) {
        self.name = name
        self.imageId = imageId
        self.note = note
    }
}
