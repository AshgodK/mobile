struct Event: Decodable {
    let id: String
    let title: String
    let description: String
    let organizer: String
    let location: String
    let date: String
    let image: String
    let v: Int

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case organizer
        case location
        case date
        case image
        case v = "__v"
    }

    init(id: String, title: String, description: String, organizer: String, location: String, date: String, image: String, v: Int) {
        self.id = id
        self.title = title
        self.description = description
        self.organizer = organizer
        self.location = location
        self.date = date
        self.image = image
        self.v = v
    }
}
