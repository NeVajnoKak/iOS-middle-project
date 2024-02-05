//
//  Alerts.swift
//  TicTacToe
//
//  Created by Erkebulan Massainov on 03.02.2024.
//

import SwiftUI


struct AlertItem: Identifiable
{
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext
{
    static let humanWin = AlertItem(title: Text("You win!"),
                             message: Text("You are so smart. You beat your own AI."),
                             buttonTitle: Text("Hell Yeah"))
    
    static let computerWin = AlertItem(title: Text("You lose!"),
                             message: Text("You programmed super AI."),
                             buttonTitle: Text("Rematch"))
    
    static let draw = AlertItem(title: Text("Draw"),
                             message: Text("What a battle of wits we have here..."),
                             buttonTitle: Text("Try again"))
}
