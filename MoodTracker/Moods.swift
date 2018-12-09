class Moods {
    
    var id: Int
    var date: String?
    var emotion: String?
    var time: String?
    
    init(id: Int, date: String?, time: String?, emotion: String?){
        self.id = id
        self.date = date
        self.time = time
        self.emotion = emotion
    }
}
