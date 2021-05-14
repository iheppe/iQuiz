//
//  ContentView.swift
//  iQuiz
//
//  Created by Isabella Heppe on 5/6/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            MainBody()
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct MainBody: View {
    let subjects = [
        Subject(name: "Mathematics", desc: "Quizzes on numbers that do cool stuff!", icon: "x.squareroot",
                questions: [Question("What is 1 + 1?", 1, ["0", "2", "1", "-1"]),
                            Question("Bobby has 10 apples. He eats 5 of them, and gives one away. How many does he have left?", 3, ["5", "10", "6", "4"]),
                            Question("What is NOT a type of triangle?", 2,["Right", "Isosceles", "Cute", "Scalene"])
                ]
        ),
        Subject(name: "Marvel Super Heroes", desc: "Quizzes on comic book and movie characters!", icon: "bolt.circle",
                questions: [Question("Who is the first Avenger?", 0, ["Captain America", "The Hulk", "Thor", "Iron Man"])
                ]
        ),
        Subject(name: "Science", desc: "Quizzes on the elements of the universe!", icon: "leaf.arrow.circlepath",
                questions: [Question("What's the first element in the periodic table?", 3, ["Helium", "Oxygen", "Carbon", "Hydrogen"]),
                            Question("What is Newton's third law of motion?", 2, ["An object will only ever move down.", "Everything remains in a persistent state of motion until acted on","For every action, there is an equal and opposite reaction", "Gravity is great!"]),
                            Question("What is the powerhouse of the cell?", 1, ["Smooth endoplasmic reticulum", "Mitochondria", "Nucleolus", "Golgi apparatus"])])]
    @State private var showAlert = false
    var body: some View {
        List(subjects) { item in
            SubjectRow(subject: item)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    self.showAlert = true
                }) {
                    Image(systemName: "gear")
                }
            }
        }
        .alert(
            isPresented: $showAlert,
            content: {
                Alert(title: Text("Settings"),
                    message: Text("Settings go here"),
                    dismissButton: .default(Text("OK"))) }
        )
    }
}

struct Subject: Identifiable {
    let id = UUID()
    let name: String
    let desc: String
    let icon: String
    var questions: [Question]
    
    init(name: String, desc: String, icon: String, questions: [Question]) {
        self.name = name
        self.desc = desc
        self.icon = icon
        self.questions = questions
    }
    
}

struct Question: Identifiable {
    let id = UUID()
    let question: String
    let correct: Int
    let answers: [String]
    
    init(_ question: String, _ correct: Int, _ answers: [String]) {
        self.question = question
        self.correct = correct
        self.answers = answers
    }
    
    
}

struct SubjectRow: View {
    let subject: Subject
    var body: some View {
        NavigationLink(destination: QuestionPage(questions: subject.questions, curr: 0, currQuestion: subject.questions[0], correct: 0)) {
            HStack {
                Image(systemName: subject.icon)
                    .font(.largeTitle)
                VStack (alignment: .leading, spacing: 5) {
                    Text(subject.name)
                        .font(.body)
                    Text(subject.desc)
                        .font(.caption)
                }.padding(4)
            }
        }.isDetailLink(false)
        .navigationBarTitle("Home")
    }
}

struct QuestionPage: View {
    var questions: [Question]
    var curr: Int
    var currQuestion: Question
    var correct: Int
    @State var selectedAnswer = 0
    var body: some View {
        VStack {
            Spacer()
            Text(currQuestion.question)
            Spacer()
            ForEach(currQuestion.answers.indices) { i in
                Button(action: {
                    if (i == currQuestion.correct) {
                        selectedAnswer = 1
                    } else {
                        selectedAnswer = 0
                    }
                }, label: {Text(self.currQuestion.answers[i])})
                .padding(5)
            }
            Spacer()
            HStack {
                Spacer()
                NavigationLink(destination: AnswerPage(questions: questions,
                                                       curr: curr,
                                                       currQuestion: questions[curr],
                                                       correct: correct,
                                                       selectedAnswer: selectedAnswer)) {
                    Text("Next")
                }
                .navigationBarTitle("Question " + String(curr + 1))
                .padding(20)
            }.padding(20)
        }
    }
}


struct AnswerPage: View {
    var questions: [Question]
    var curr: Int
    var currQuestion: Question
    var correct: Int
    var selectedAnswer: Int
    var body: some View {
        VStack {
            Spacer()
            Text(currQuestion.question)
            Spacer()
            Text(currQuestion.answers[currQuestion.correct])
            Spacer()
            if (selectedAnswer == 1) {
                Text("You got it correct!")
            } else {
                Text("You got it wrong :(")
            }
            
            Spacer()
            HStack {
                Spacer()
                if (curr == questions.count - 1) {
                    NavigationLink(destination: FinalPage(questions: questions, correct: correct + selectedAnswer)) {
                        Text("Next")
                    }
                    .navigationBarTitle("Answer " + String(curr + 1))
                    .padding(20)
                } else {
                    NavigationLink(destination: QuestionPage(questions: questions,
                                                             curr: curr + 1,
                                                             currQuestion: questions[curr + 1],
                                                             correct: correct + selectedAnswer)) {
                        Text("Next")
                    }
                    .navigationBarTitle("Answer " + String(curr + 1))
                    .padding(20)
                }
            }.padding(20)
        }
    }
}

struct FinalPage: View {
    var questions: [Question]
    var correct: Int
    var body: some View {
        Spacer()
        if questions.count == correct{
            Text("You did perfect! Great job!")
        } else if correct == 0 {
            Text("Nice try, but you didn't do so well. Better luck next time!")
        } else {
            Text("Pretty good!")
        }
        Spacer()
        Text(String(correct) + " out of " + String(questions.count))
        Spacer()
        HStack {
            Spacer()
            NavigationLink(destination: MainBody(),
                   label:{Text("Back to Home")})
                .navigationBarTitle("Finished")
            .padding(20)
        }.padding(20)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
