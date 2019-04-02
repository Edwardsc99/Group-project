import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var optionOneButton: UIButton!
    
    @IBAction func optionOne(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let question = Question(valueA: 1, valueB: 2)
        questionLabel.text = question.text
        optionOneButton.setTitle(question.textForAnswer(number: 0), for: .normal)
        
    }
    
}
