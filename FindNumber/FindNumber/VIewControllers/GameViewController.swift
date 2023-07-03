//
//  GameViewController.swift
//  FindNumber
//
//  Created by Илья Алексейчук on 06.04.2023.
//

import UIKit

class GameViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var nextDigit: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    
    //MARK: Creating instance of game model
    lazy var game = Game(countItems: buttons.count) { [weak self] status, time in
        guard let self = self else {return}
        
        self.timerLabel.text = time.secondsToString()
        self.updateInfoGame(with: status)
        
    }
    
    
    
    //MARK: Setup screen
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()

        
    }
    
    //MARK: Pause the game if the screen disappears
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        game.stopGame()
    }
    
    
    //MARK: Button pressed action
    @IBAction func pressButton(_ sender: UIButton) {
        guard let buttonIndex = buttons.firstIndex(of: sender) else {return}
        game.check(index: buttonIndex)
        
        updateUI()
        
    }
    
    
    //MARK: New game function
    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        sender.isHidden = true
        setupScreen()
    }
    
    
    //MARK: Setup screen function
    private func setupScreen() {
        for index in game.items.indices {
            buttons[index].setTitle(game.items[index].title, for: .normal)
            buttons[index].alpha = 1
            buttons[index].isEnabled = true
            
        }
        nextDigit.text = game.nextItem?.title
        
        timerLabel.alpha = Settings.shared.currentSettings.timerState ? 1 : 0
    }
    
    
    //MARK: Update UI function
    private func updateUI() {
        for index in game.items.indices {
            buttons[index].alpha = game.items[index].isFound ? 0 : 1
            buttons[index].isEnabled = !game.items[index].isFound
            
            if game.items[index].isError {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.buttons[index].backgroundColor = .red
                } completion: { [weak self] _ in
                    self?.buttons[index].backgroundColor = .white
                    self?.game.items[index].isError = false
                }
            }
            
        }
        
        nextDigit.text = game.nextItem?.title
        updateInfoGame(with: game.status)
    }

    
    //MARK: Updating game status
    private func updateInfoGame(with status: StatusGame) {
        switch status {
        case .start:
            statusLabel.text = "Игра началась"
            statusLabel.textColor = .black
            newGameButton.isHidden = true
        case .win:
            statusLabel.text = "Вы выиграли!"
            statusLabel.textColor = .green
            newGameButton.isHidden = false
            if game.isNewRecord {
                showAlert()
            } else {
                showAlertActionSheet()
            }
        case .lose:
            statusLabel.text = "Вы проиграли"
            statusLabel.textColor = .red
            newGameButton.isHidden = false
            showAlertActionSheet()
        }
    }
    
    
    //MARK: Alert controller for the end of the game with new record
    private func showAlert() {
        let alert = UIAlertController(title: "Поздравляем!", message: "Вы устанновили новый рекорд!", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "ОК", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    
    //MARK: Alert controller for the end of the game without new record
    private func showAlertActionSheet() {
        let alert = UIAlertController(title: "Что вы хотите сделать далее?", message: nil, preferredStyle: .actionSheet)
        
        let newGameAction = UIAlertAction(title: "Начать новую игру", style: .default) { [weak self] (_) in
            self?.game.newGame()
            self?.setupScreen()
        }
        
        let showRecord = UIAlertAction(title: "Посмотреть рекорд", style: .default) { [weak self] (_) in
            self?.performSegue(withIdentifier: "recordVC", sender: nil)
        }
        
        let menuAction = UIAlertAction(title: "Перейти в меню", style: .destructive) { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(newGameAction)
        alert.addAction(showRecord)
        alert.addAction(menuAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
    
}
