//
//  RecordViewController.swift
//  FindNumber
//
//  Created by Илья Алексейчук on 08.04.2023.
//

import UIKit

class RecordViewController: UIViewController {

    @IBOutlet weak var recordLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Fetching reccord from UserDefaults
        let record = UserDefaults.standard.integer(forKey: KeysUserDefaults.recordGame)
        
        //MARK: Display record
        if record != 0 {
            recordLabel.text = "Ваш рекорд - \(record) сек"
        } else {
            recordLabel.text = "Рекорд не установлен"
        }

        
    }
    //MARK: Close view controller
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
}
