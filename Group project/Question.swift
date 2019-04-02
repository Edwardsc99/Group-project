import Foundation

class Question {
    
    var valueA: Int
    var valueB: Int
    
    var answer: Int {
        return valueA + valueB
    }
    
    var answers = [(Int, Int)]()
    
    
    var text: String {
        return "What is \(valueA) + \(valueB)"
    }
    
    init(valueA: Int, valueB: Int) {
        self.valueA = valueA
        self.valueB = valueB
        
        let genarator = AnswerGnerator(question: self)
        answers = genarator.answerList
    }
    
    func textForAnswer(number: Int) -> String {
        let answer = answers[number]
        return "\(answer.0) + \(answer.1)"
    }
    
}
