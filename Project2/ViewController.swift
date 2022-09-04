//
//  ViewController.swift
//  Project2
//
//  Created by Hassan Sohail Dar on 15/8/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    var questionsAsked = 0
    var correctAnswer = 0
    
    var countries = [String]()
    var highScore = 0

    var score = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let defaults = UserDefaults.standard
        
        if let highestScore = defaults.object(forKey: "highScore") as? Data {
                let jsonDecoder = JSONDecoder()
            
            do {
                highScore = try jsonDecoder.decode(Int.self, from: highestScore)
            } catch {
                print("highest score could not be saved.")
            }
        }
        
        print("high score = \(highScore)")
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]

        button1.layer.borderWidth  = 1
        button2.layer.borderWidth  = 1
        button3.layer.borderWidth  = 1
        
        button1.layer.borderColor = UIColor.green.cgColor
        button2.layer.borderColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0).cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(scoreTapped))

        
        askQuestion()
    }

    func askQuestion (action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)

        title = "\(countries[correctAnswer].uppercased()), SCORE = \(score)"
        
        if questionsAsked >= 10 {
            scoreTapped()
            questionsAsked = 0
            score = 0
            
            
        }
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong! That is the flag of \(countries[sender.tag].uppercased())"
            score -= 1
        }
        
        let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        
        present(ac, animated: true)
        questionsAsked += 1
        //default, concel, destructive UIHint....
        
        
    }
    
    @objc func scoreTapped() {
        
        title = "Final score"
        
         if score > highScore {
            highScore = score
             //save the score in the UserDefaults
             let jsonEncoder = JSONEncoder()
             if let savedData = try? jsonEncoder.encode(highScore) {
                 let defaults = UserDefaults.standard
                 defaults.set(savedData, forKey: "highScore")
             } else {
                 print("Failed to save High Score.")
             }
             
             let ac  = UIAlertController(title: "Wow", message: "Congratulations!! You beat the high score of the game.", preferredStyle: .alert)
             
             ac.addAction(UIAlertAction(title: "Ok", style: .default))
             
             present(ac, animated: true)
             
    }
        
        let ac = UIAlertController(title: title, message: "Your Total score is \(score)", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        
        present(ac, animated: true)
    }
}

