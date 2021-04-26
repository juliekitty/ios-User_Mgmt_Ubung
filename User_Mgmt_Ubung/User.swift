//
//  User.swift
//  User_Mgmt_Ubung
//
//  Created by Julie Landry on 26.04.21.
//

import SwiftUI

class User: Identifiable {
    let name: String
    let age: Int
    let id: UUID
    let timeStamp: Date
    
    init(name: String, age: Int, id: UUID, timeStamp: Date) {
        self.name = name
        self.age = age
        self.id = id
        self.timeStamp = timeStamp
    }
    
    func convertDateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}


class Repository {
    private (set) var questionCounter: Int = 0
    private (set) var pointsCount: Int = 0
    private (set) var wrongAnswersCounter: Int = 0
    
    var users: [User] = [User]()
    
    internal init() {
        self.users = fillUsers()
    }
    private func fillUsers() -> [User] {
        
        return [User(name: "Julie", age: 35, id: UUID(), timeStamp: Date()-15*86400),
                User(name: "Bob", age: 45, id: UUID(), timeStamp: Date()-100*86400),
                User(name: "Alex", age: 89, id: UUID(), timeStamp: Date()-300*86400),
                User(name: "John", age: 12, id: UUID(), timeStamp: Date()-200*86400),
                User(name: "Johnny", age: 45, id: UUID(), timeStamp: Date()-50*86400),
                User(name: "Francis", age: 54, id: UUID(), timeStamp: Date()-30*86400),
                User(name: "Léonie", age: 8, id: UUID(), timeStamp: Date()-60*86400),
                User(name: "Gaspard", age: 9, id: UUID(), timeStamp: Date()-80*86400),
                User(name: "Alexis", age: 32, id: UUID(), timeStamp: Date()-20*86400),
        ]
    }
    
    
    func addUser(user: User) -> [User] {
        self.users.append(user)
        return self.users
    }
    
}
