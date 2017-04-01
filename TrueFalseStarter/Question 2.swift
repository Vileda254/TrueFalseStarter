let initialData: [[String: [String: Bool]]] = [
    ["This was the only US President to serve more than two consecutive terms.": ["George Washington": false, "Franklin D. Roosevelt": true, "Andrew Jackson": false]],
    ["Which of the following countries has the most residents?": ["Nigeria": true, "Russia": false, "Iran": false, "Vietnam": false]],
    ["In what year was the United Nations founded?": ["1918": false, "1919": false, "1945": true, "1954": false]],
    ["The Titanic departed from the United Kingdom, where was it supposed to arrive?": ["Paris": false, "Washington D.C.": false, "New York City": true, "Boston": false]],
    ["Which nation produces the most oil?": ["Iran": false, "Iraq": false, "Brazil": false, "Canada": true]],
    ["Which country has most recently won consecutive World Cups in Soccer?": ["Brazil": true, "Argentina": false, "Spain": false]],
    ["Which of the following rivers is longest?": ["Yangtze": false, "Mississippi": true, "Congo": false, "Mekong": false]],
    ["Which city is the oldest?": ["Mexico City": true, "Cape Town": false, "San Juan": false, "Sydney": false]],
    ["Which country was the first to allow women to vote in national elections?": ["Poland": true, "United States": false, "Sweden": false, "Senegal": false]],
    ["Which of these countries won the most medals in the 2012 Summer Games?": ["France": false, "Japan": false, "Great Britian": true]]
]

struct Question {
    let question: String
    let possibleAnswers: [String: Bool]

    func isCorrect(answer answerKey: String) -> Bool {
        var isCorrectAnswer: Bool = false
        for (key, value) in possibleAnswers {
            if answerKey == key {
                isCorrectAnswer = value
            }
        }

        return isCorrectAnswer
    }
}


func processQuestionData(from data: [[String: [String: Bool]]]) -> [Question] {
    var triviaQuestions = [Question] ()
    for question in data {
        for (key, value) in question {
            triviaQuestions.append(Question(question: key, possibleAnswers: value))
        }
    }

    return triviaQuestions
}


