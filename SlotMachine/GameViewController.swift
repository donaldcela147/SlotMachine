//
//  GameViewController.swift
//  SlotMachine
//
//  Created by Florian Cela on 4.2.21.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {

    @IBOutlet weak var collectLabel: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var collectButton: UIButton!
    @IBOutlet weak var creditLabel: UILabel!
    @IBOutlet weak var spinLabel: UIButton!
    @IBOutlet weak var currentBetLabel: UILabel!
    @IBOutlet weak var plusLabel: UIButton!
    @IBOutlet weak var minusLabel: UIButton!
    
    var sounds = ["sound", "collecter", "beep"]
    
    var credit = 500
    var currentBet = 5
    var player: AVAudioPlayer?
    
    @IBAction func collectAction(_ sender: UIButton?) {
        updateCredit()
        playSoundEffect(sound: "collecter")
        hideLabels()
    }
    
    func hideLabels(){
        collectLabel.alpha = 0
        collectButton.alpha = 0
        spinLabel.alpha = 1
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectLabel.alpha = 0
        collectButton.alpha = 0
    }
    
    func playSoundEffect(sound: String){
       
        let urlString = Bundle.main.path(forResource: sound, ofType: "mp3")
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            guard let urlString = urlString else {return}
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            guard let player = player else {
                print("player is nil")
                return }
            player.play()
            player.volume = 1
        }
        
        catch{
            print("Error occured")
        }
    }
    
    @IBAction func spinButton(_ sender: Any) {
        spinAndAssignImages()
        playSoundEffect(sound: "sound")
    }
    
    @IBAction func betPlus(_ sender: Any) {
        if currentBet < credit{
            playSoundEffect(sound: sounds[2])
            currentBet = currentBet + 5
            currentBetLabel.text = "CURRENT BET: \(currentBet)"
        }
        else if credit == 0{
            playSoundEffect(sound: sounds[2])
            currentBet = 0
            currentBetLabel.text = "CURRENT BET: \(currentBet)"
        }
        else if currentBet == credit{
            currentBet = credit
            currentBetLabel.text = "CURRENT BET: \(currentBet)"
        }
    }
    
    @IBAction func betMinus(_ sender: Any) {
        if currentBet == 5 {
            currentBet = 5
            currentBetLabel.text = "CURRENT BET: \(currentBet)"
        }
        else{
            playSoundEffect(sound: "beep")
            currentBet = currentBet - 5
            currentBetLabel.text = "CURRENT BET: \(currentBet)"
        }
    }
    
    func disableButton(button : UIButton){
        button.isEnabled = false
    }
    
    func spinAndAssignImages(){
        
        credit = credit - currentBet
        
        UIView.transition(with: image1, duration: 0.3, options: .transitionFlipFromTop, animations: nil, completion: nil)
        UIView.transition(with: image2, duration: 0.3, options: .transitionFlipFromTop, animations: nil, completion: nil)
        UIView.transition(with: image3, duration: 0.3, options: .transitionFlipFromTop, animations: nil, completion: nil)
        
        
        if credit < currentBet{
            currentBet = credit
            currentBetLabel.text = "CURRENT BET: \(currentBet)"
        }
        else if credit <= 0{
            creditLabel.text = "Game Over!"
            disableButton(button: spinLabel)
            disableButton(button: minusLabel)
            disableButton(button: plusLabel)
        }
        else{
            creditLabel.text = "CREDIT: \(credit)"
            currentBetLabel.text = "CURRENT BET: \(currentBet)"
        }
        
        updateCredit()
    }
    
    func updateCredit(){
        
        let image1number = Int.random(in: 1...4)
        let image2number = Int.random(in: 1...4)
        let image3number = Int.random(in: 1...4)
        
        assignImages(number: image1number, image: image1)
        assignImages(number: image2number, image: image2)
        assignImages(number: image3number, image: image3)
        
        if image1number == 1 && image2number == 1 && image3number == 1{
            credit = credit + (10 * currentBet)
            alpha()
        }
        else if image1number == 2 && image2number == 2 && image3number == 2{
            credit = credit + (30 * currentBet)
            alpha()
        }
        else if image1number == 3 && image2number == 3 && image3number == 3{
            credit = credit + (60 * currentBet)
            alpha()
        }
        else if image1number == 4 && image2number == 4 && image3number == 4{
            credit = credit + (150 * currentBet)
            alpha()
        }
    }
    
    func alpha(){
        collectButton.alpha = 1
        collectLabel.alpha = 1
        spinLabel.alpha = 0
    }
    
    func assignImages(number: Int, image: UIImageView){
        switch number {
        case 1:
            image.image = UIImage(named: "qershi")
        case 2:
            image.image = UIImage(named: "molla")
        case 3:
            image.image = UIImage(named: "rrushi")
        case 4:
            image.image = UIImage(named: "shtata")
        default:
            print("Error Ocured...!")
        }
    }
}
