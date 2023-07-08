//
//  ViewController.swift
//  MinumYuk
//
//  Created by Larasati on 18/06/23.
//


import UIKit

class ViewController: UIViewController {
    let scheduleList = ["08:00", "12:00", "14:00", "16:00"]
    var currentDrink:Int = 0
    let test = 10

    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var glass: UIView!
    @IBOutlet var water: UIView!
    @IBOutlet weak var bottle: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkDate()
        progressView.progress = 0
        
        currentDrink = UserDefaults.standard.integer(forKey: "currentDrink")
        progressLabel.text = "\(currentDrink) / 2000 ml"
        progressView.progress = Float(currentDrink)/Float(2000)
        
        configureViewInteraction()
        
    }
    
    
    func configureViewInteraction(){
        glass.isUserInteractionEnabled = true
        glass.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGlassTapped)))
        
        bottle.isUserInteractionEnabled = true
        bottle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlBottleTapped)))
        
        water.isUserInteractionEnabled = true
        water.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleWaterTapped)))
    }
    
    @objc func handleGlassTapped(){
        addWater(amount: 100)
    }
    
    @objc func handlBottleTapped(){
        addWater(amount: 200)
    }
    
    @objc func handleWaterTapped(){
        addWater(amount: 300)
    }
    
    func addWater(amount: Int){
        currentDrink = currentDrink + amount
        progressView.progress = Float(currentDrink) / 2000
        progressLabel.text = "\(currentDrink) / 2000 ml"
        
        UserDefaults.standard.set(currentDrink, forKey: "currentDrink")
        
    }
    
    func checkDate(){
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        let dateNow = Date()
        let startDate = calendar.startOfDay(for: dateNow)
        
        let currentDate = UserDefaults.standard.double(forKey: "currentDate")
        
        if currentDate == 0{
            UserDefaults.standard.set(startDate.timeIntervalSince1970, forKey: "currentDate")
        }else{
            let savedDate = Date(timeIntervalSince1970: currentDate)
            let dateTo = calendar.date(byAdding: .day, value: 1, to: savedDate)

            if dateNow > dateTo!{
                UserDefaults.standard.set(startDate, forKey: "currentDate")
                UserDefaults.standard.set(0, forKey: "currentDrink")
            }
        }
    }

    func requestNotificationUserPermission() {
        //Request for user permission
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert,.sound]) { permissionGranted, error in
            if(!permissionGranted)
            {
                notificationCenter.getNotificationSettings { (settings) in
                    if(settings.authorizationStatus != .authorized){
                        DispatchQueue.main.async {
                            let ac = UIAlertController(title: "Enable Notifications?", message: "To use reminder feature you must enable notifications in settings", preferredStyle: .alert)
                            let goToSettings = UIAlertAction(title: "Settings", style: .default){
                                
                                (_) in
                                guard let settingsURL = URL(string: UIApplication.openSettingsURLString)
                                else{
                                    return
                                }
                                if(UIApplication.shared.canOpenURL(settingsURL)){
                                    UIApplication.shared.open(settingsURL){ (_) in
                                    }
                                }
                            }
                            ac.addAction(goToSettings)
                            ac.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(_) in}))
                            self.present(ac,animated: true)
                        }
                    }
                }
            }
        }
    }

}

