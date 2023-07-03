//
//  SettingsTableViewController.swift
//  FindNumber
//
//  Created by Илья Алексейчук on 07.04.2023.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var timeGameLabel: UILabel!
    @IBOutlet weak var switchTimer: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSettings()
    }
    
    //MARK: Updating timer state in settings model
    @IBAction func changeTimerState(_ sender: UISwitch) {
        Settings.shared.currentSettings.timerState = sender.isOn
    }
    //MARK: Come back to default settings
    @IBAction func resetSettings(_ sender: UIButton) {
        Settings.shared.resetSettings()
        loadSettings()
        
    }
    
    //MARK: Loading settings from settings model
    func loadSettings() {
        timeGameLabel.text = "\(Settings.shared.currentSettings.timeForGame) сек"
        switchTimer.isOn = Settings.shared.currentSettings.timerState
    }
    
    //MARK: Segue to select time VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "selectTimeVC":
            if let vc = segue.destination as? SelectTimeViewController {
                vc.data = Array(stride(from: 10, through: 120, by: 10))
            }
        default:
            break
        }
    }

}
