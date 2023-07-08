
//
//  ScheduleViewController.swift
//  MinumYuk
//
//  Created by Larasati on 24/06/23.
//

import UIKit


extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell") as! ScheduleCell
        cell.timeLabel.text = scheduleList[indexPath.row]
        return cell

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        scheduleList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .right)
        updateScheduleListToUserDefaults()
    }
    
}

class ScheduleViewController: UIViewController, AddScheduleProtocol {
    func userFinishAddSchedule(timeDate: Date) {
        addScheduleListToUserDefaults(timeDate: timeDate)
        readScheduleListFromUserDefaults()
        tableView.reloadData()
    }
    
    func updateScheduleListToUserDefaults(){
        UserDefaults.standard.set(scheduleList, forKey: "ScheduleList")
    }

    
    @IBAction func goToAddSchedule(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddScheduleViewController") as! AddScheduleViewController
        
        nextViewController.delegate = self
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }

    
    
    
    
    var scheduleList = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let scheduleNib = UINib (nibName: "ScheduleCell", bundle: nil)
        tableView.register(scheduleNib, forCellReuseIdentifier: "ScheduleCell")
        tableView.dataSource = self
        
        readScheduleListFromUserDefaults()
//        addScheduleListToUserDefaults(time: "13:00")
        
        tableView.reloadData()
    }
    
    func addScheduleListToUserDefaults(timeDate: Date){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: timeDate)
        scheduleList.append(timeString)
        
        UserDefaults.standard.set(scheduleList, forKey: "ScheduleList")
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Minum Yuk Sekarang"
        content.body = "Jangan sampai lupa ya"
        content.sound = .default
        content.userInfo = ["value": "Data with local notification"]
                
        let fireDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: timeDate)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate, repeats: true)
        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
        
             

        center.add(request) { (error) in
            if error != nil {
                print("Error = \(error?.localizedDescription ?? "error local notification")")
            }else{
                print("Success add notif at \(fireDate)")
            }
        }
    }
    
    func readScheduleListFromUserDefaults(){
        let schedules = UserDefaults.standard.array(forKey: "ScheduleList") as? [String]
//        nil = kosong / empty
//        Optional Check
        
        guard let schedules = schedules else {
            print("Tidak ada schedule")
            return
        }

        scheduleList = schedules.sorted()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
