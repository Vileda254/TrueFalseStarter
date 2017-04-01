//
//  ViewController.swift
//  TrueFalseStarter
//
//  Created by Pasan Premaratne on 3/9/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    let questionsPerRound = 10
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    var usedIndexes = [Int] ()
    var gameSound: SystemSoundID = 0

    let trivia = processQuestionData(from: initialData)


    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameStartSound()
        // Start game
        playGameStartSound()
        displayQuestion()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func displayQuestion() {
        indexOfSelectedQuestion = getRandomIndex(from: trivia)
        let selectedQuestion = trivia[indexOfSelectedQuestion]
        questionField.text = selectedQuestion.question
        playAgainButton.isHidden = true

        var answersArray = [String] ()
        for (key, _) in selectedQuestion.possibleAnswers {
            answersArray.append(key)
        }

        if answersArray.count == 3 {
            option1.setTitle(answersArray[0], for: .normal)
            option2.setTitle(answersArray[1], for: .normal)
            option3.setTitle(answersArray[2], for: .normal)
            option4.isHidden = true
        } else if answersArray.count == 4 {
            option1.setTitle(answersArray[0], for: .normal)
            option2.setTitle(answersArray[1], for: .normal)
            option3.setTitle(answersArray[2], for: .normal)
            option4.setTitle(answersArray[3], for: .normal)
            option4.isHidden = false
        }
    }
    
    func displayScore() {
        // Hide the answer buttons
        option1.isHidden = true
        option2.isHidden = true
        option3.isHidden = true
        option4.isHidden = true
        
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }

    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        let selectedQuestion = trivia[indexOfSelectedQuestion]
        let selectedAnswer = sender.titleLabel?.text
        
        if (selectedQuestion.isCorrect(answer: selectedAnswer!)) {
            correctQuestions += 1
            questionField.text = "Correct!"
            sender.backgroundColor = UIColor(red:0.09,green:0.67,blue:0.15,alpha:1.00)
        } else {
            questionField.text = "Sorry, the correct answer is: "
            sender.backgroundColor = UIColor(red:0.83,green:0.08,blue:0.08,alpha:1.00)
        }
        
        loadNextRoundWithDelay(seconds: 2)
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            setDefaultButtonColor()
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
        option1.isHidden = false
        option2.isHidden = false
        option3.isHidden = false
        option4.isHidden = false
        
        questionsAsked = 0
        correctQuestions = 0
        // Empty random used indexes array
        usedIndexes.removeAll()
        nextRound()
    }


    
    // MARK: Helper Methods

    // Function to get a random question index without indexes repeating
    func getRandomIndex(from questions: [Question]) -> Int {
        var indexOfQuestion: Int
        repeat {
            if usedIndexes.count == questions.count {
                usedIndexes.removeAll()
            }
            indexOfQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: questions.count)
        } while usedIndexes.contains(indexOfQuestion)

        usedIndexes.append(indexOfQuestion)

        return indexOfQuestion
    }

    func setDefaultButtonColor() {
        let defaultColor = UIColor(red:0.09,green:0.47,blue:0.58,alpha:1.00)
        option1.backgroundColor = defaultColor
        option2.backgroundColor = defaultColor
        option3.backgroundColor = defaultColor
        option4.backgroundColor = defaultColor
    }

    func loadNextRoundWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    func loadGameStartSound() {
        let pathToSoundFile = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
}

