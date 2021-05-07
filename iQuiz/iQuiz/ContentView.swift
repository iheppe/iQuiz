//
//  ContentView.swift
//  iQuiz
//
//  Created by Isabella Heppe on 5/6/21.
//

import SwiftUI

struct ContentView: View {
    let subjects = [
        Subject(name: "Mathematics", desc: "Quizzes on numbers that do cool stuff!", icon: "x.squareroot"),
        Subject(name: "Marvel Super Heroes", desc: "Quizzes on comic book and movie characters!", icon: "bolt.circle"),
        Subject(name: "Science", desc: "Quizzes on the elements of the universe!", icon: "leaf.arrow.circlepath")]
    @State private var showAlert = false;
    var body: some View {
        NavigationView {
            List(subjects) { subject in
                SubjectRow(subject: subject)
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
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct Subject: Identifiable {
    let id = UUID()
    let name: String
    let desc: String
    let icon: String
//    let questions: [Question]
}

//struct Question: Identifiable {
//    let id = UUID()
//    let question: String
//}

struct SubjectRow: View {
    let subject: Subject
    var body: some View {
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
