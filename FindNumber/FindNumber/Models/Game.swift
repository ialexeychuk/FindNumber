//
//  Game.swift
//  FindNumber
//
//  Created by Илья Алексейчук on 06.04.2023.
//

import Foundation

enum StatusGame {
    case start
    case win
    case lose
}

class Game {
    
    
    
    struct Item {
        var title: String
        var isFound = false
        var isError = false
    }
    
    //MARK: Variable declaration
    private let data = Array(1...99)
    
    var items: [Item] = []
    
    private var countItems: Int
    
    var nextItem: Item?
    
    var isNewRecord = false
    
    //MARK: Game status
    var status: StatusGame = .start {
        didSet {
            if status != .start {
                if status == .win {
                    let newRecord = timeForGame - secondsGame
                    let record = UserDefaults.standard.integer(forKey: KeysUserDefaults.recordGame)
                    
                    if record == 0 || newRecord < record {
                        UserDefaults.standard.set(newRecord, forKey: KeysUserDefaults.recordGame)
                        isNewRecord = true
                    }
                }
                stopGame()
            }
        }
    }
    
    private var timeForGame: Int
    private var secondsGame: Int {
        didSet {
            if secondsGame == 0 {
                status = .lose
            }
            updateTimer(status, secondsGame)
        }
    }
    //MARK: Working with timer
    private var timer: Timer?
    
    private var updateTimer: ((StatusGame,Int) -> ())
    
    init(countItems: Int, updateTimer: @escaping (_ status: StatusGame,_ seconds: Int) -> ()) {
        self.countItems = countItems
        self.timeForGame = Settings.shared.currentSettings.timeForGame
        self.secondsGame = self.timeForGame
        self.updateTimer = updateTimer
        setupGame()
    }
    
    //MARK: Preparing for the game
    private func setupGame() {
        isNewRecord = false
        var digits = data.shuffled()
        items.removeAll()
        while items.count < countItems {
            let item = Item(title: String(digits.removeFirst()))
            items.append(item)
        }
        
        nextItem = items.shuffled().first
        
        updateTimer(status, secondsGame)
        
        if Settings.shared.currentSettings.timerState {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] (_) in
                self?.secondsGame -= 1
            })
        }
    }
    
    //MARK: Start new game
    func newGame() {
        status = .start
        self.secondsGame = self.timeForGame
        setupGame()
    }
    
    //MARK: Checking the correctness of the choice
    func check(index: Int) {
        guard status == .start else {return}
        
        if items[index].title == nextItem?.title {
            items[index].isFound = true
            nextItem = items.shuffled().first(where: { item in
                item.isFound == false
            })
            
        } else {
            items[index].isError = true
        }
        
        if nextItem == nil {
            status = .win
        }
    }
    //MARK: Stop game
    func stopGame() {
        timer?.invalidate()
    }
}


//MARK: Extension for the Integer to format time
extension Int {
    func secondsToString() -> String {
        let seconds = self % 60
        let minutes = self / 60
        return String(format: "%d:%02d", minutes,seconds)
    }
}
