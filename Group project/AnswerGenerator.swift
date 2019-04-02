import Foundation

class AnswerGnerator {
    
    var numberOfAnswers = 6
    
    var answerList = [(Int, Int)]()
    
    init(question: Question) {
        
        for _ in 0..<numberOfAnswers {
            answerList.append((Int.random(in: 0...10), Int.random(in: 0...10)))
        }
        
    }
    
    
}
