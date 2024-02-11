//
//  QuizFlowManagerTests+Helpers.swift
//  JLPTQuizTests
//
//  Created by Mu Yu on 2/8/24.
//

@testable import JLPTQuiz

extension QuizFlowManagerTests {
    func makeSUTSetupWithTwoQuestionsTwoOptionsAndFirstOptionIsCorrect() -> (sut: QuizFlowManager, quiz1: Quiz, quiz2: Quiz) {
        let correctOption = QuizOptionEntry(wording: "correct option", linkedEntryID: "id-1", isAnswer: true)
        let wrongOption = QuizOptionEntry(wording: "wrong option", linkedEntryID: "id-2", isAnswer: false)
        let quiz1 = makeQuizItem(id: "id-1", options: [correctOption, wrongOption])
        let quiz2 = makeQuizItem(id: "id-2", options: [correctOption, wrongOption])
        let service = FakeQuizService(quizList: [quiz1.model, quiz2.model])
        let flowManager = QuizFlowManager(service: service)
        return (flowManager, quiz1.model, quiz2.model)
    }
    
    func makeSUTSetupWithOneQuestionTwoOptionsAndFirstOptionIsCorrect() -> (sut: QuizFlowManager, quiz: Quiz) {
        let correctOption = QuizOptionEntry(wording: "correct option", linkedEntryID: "id-1", isAnswer: true)
        let wrongOption = QuizOptionEntry(wording: "wrong option", linkedEntryID: "id-2", isAnswer: false)
        let quiz = makeQuizItem(id: "id-1", options: [correctOption, wrongOption])
        let service = FakeQuizService(quizList: [quiz.model])
        let flowManager = QuizFlowManager(service: service)
        return (flowManager, quiz.model)
    }
}

class FakeQuizService: QuizService {
    
    private let quizList: [Quiz]
    
    init(quizList: [Quiz]) {
        self.quizList = quizList
    }
    
    func generateSession(filteredBy: JLPTQuiz.QuizConfig?) throws -> JLPTQuiz.Session {
        return Session(quizList: quizList)
    }
}
