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
    var myTimer = Timer()
    var secondsOnTimer = 15

    let trivia = processQuestionData(from: initialData)

    @IBOutlet var answerOptions: [UIButton]!
    @IBOutlet var timerLables: [UILabel]!
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
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
        
        // Hide play again button
        playAgainButton.isHidden = true
        displayQuestion()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func displayQuestion() {
        //Start the countdown timer
        secondsOnTimer = 15
        startTimer()
        
        // Get a random question(non-repeating) from question source
        indexOfSelectedQuestion = getRandomIndex(from: trivia)
        let selectedQuestion = trivia[indexOfSelectedQuestion]
        questionField.text = selectedQuestion.question
        
        //Display answers for selected question
        let answersArray = selectedQuestion.answerStrings()
        
        let numberOfAnswers = answersArray.count
        
        switch numberOfAnswers {
        case 2:
            option1.setTitle(answersArray[0], for: .normal)
            option2.setTitle(answersArray[1], for: .normal)
            option3.isHidden = true
            option4.isHidden = true
        case 3:
            option1.setTitle(answersArray[0], for: .normal)
            option2.setTitle(answersArray[1], for: .normal)
            option3.setTitle(answersArray[2], for: .normal)
            option4.isHidden = true
        case 4:
            option1.setTitle(answersArray[0], for: .normal)
            option2.setTitle(answersArray[1], for: .normal)
            option3.setTitle(answersArray[2], for: .normal)
            option4.setTitle(answersArray[3], for: .normal)
        default:
            break
        }
    }
    
    func displayScore() {
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
    }

    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        // Disable answer buttons, so they can't be clicked again before next question
        toggleButtonsEnabledState(buttons: answerOptions, enabled: false)
        
        // Get selected question and answer as well as the correct answer
        let selectedQuestion = trivia[indexOfSelectedQuestion]
        let selectedAnswer = sender.titleLabel!.text
        let correctAnswer = selectedQuestion.correctAnswerString()
        
        if (selectedAnswer == correctAnswer) {
            correctQuestions += 1
            questionField.text = "Correct!"
            sender.backgroundColor = UIColor(red:0.09,green:0.67,blue:0.15,alpha:1.00)
        } else {
            questionField.text = "Sorry, the correct answer is: \n\(correctAnswer)"
            sender.backgroundColor = UIColor(red:0.83,green:0.08,blue:0.08,alpha:1.00)
        }
        
        // End countdown timer
        myTimer.invalidate()
        
        // Load next question/score screen
        loadNextRoundWithDelay(seconds: 2)
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Hide the answer buttons and timer labels
            toggleButtonsVisibility(buttons: answerOptions, visible: false)
            toggleLabelsVisibility(labels: timerLables, visible: false)
            
            // Display play again button
            playAgainButton.isHidden = false
            
            // Game is over
            displayScore()
        } else {
            // Show and enable all answer buttons
            toggleButtonsVisibility(buttons: answerOptions, visible: true)
            toggleButtonsEnabledState(buttons: answerOptions, enabled: true)
            setDefaultButtonColor()
            
            // Hide play again button
            playAgainButton.isHidden = true
            
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
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
    
    func toggleLabelsVisibility(labels: [UILabel]!, visible: Bool) {
        if visible {
            for label in labels {
                label.isHidden = false
            }
        } else if !visible {
            for label in labels {
                label.isHidden = true
            }
        }
    }
    
    func toggleButtonsVisibility(buttons: [UIButton]!, visible: Bool) {
        if visible {
            for button in buttons {
                button.isHidden = false
            }
        } else if !visible {
            for button in buttons {
                button.isHidden = true
            }
        }
    }
    
    func toggleButtonsEnabledState(buttons: [UIButton]!, enabled: Bool) {
        if enabled {
            for button in buttons {
                button.isEnabled = true
            }
        } else if !enabled {
            for button in buttons {
                button.isEnabled = false
            }
        }
    }

    func setDefaultButtonColor() {
        let defaultColor = UIColor(red:0.09,green:0.47,blue:0.58,alpha:1.00)
        for button in answerOptions {
            button.backgroundColor = defaultColor
        }
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
    
    func startTimer() {
        myTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
    }
    
    func timerUpdate() {
        if secondsOnTimer > 0 {
            timerLabel.text = String(secondsOnTimer)
            secondsOnTimer -= 1
        } else if secondsOnTimer == 0 {
            timerLabel.text = "0"
            questionField.text = "Sorry your time has run out."
            toggleButtonsEnabledState(buttons: answerOptions, enabled: false)
            questionsAsked += 1
            myTimer.invalidate()
            loadNextRoundWithDelay(seconds: 2)
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

