
//
//  AddScheduleViewController.swift
//  MinumYuk
//
//  Created by Larasati on 24/06/23.
//

import UIKit

protocol AddScheduleProtocol: AnyObject{
    func userFinishAddSchedule(timeDate: Date)
}

class AddScheduleViewController: UIViewController {
    var timeDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    weak var delegate: AddScheduleProtocol?
    
    @IBAction func saveButton(_ sender: Any) {
        delegate?.userFinishAddSchedule(timeDate: timeDate)
        navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var timeValue: UIDatePicker!
    
    @IBAction func timePicker(_ sender: Any) {
        timeDate = timeValue.date
    }
    
    

}
