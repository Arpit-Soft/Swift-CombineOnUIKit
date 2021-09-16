//
//  ViewController.swift
//  CombineOnUIkit
//
//  Created by Arpit Dixit on 16/09/21.
//

import UIKit
import Combine

extension Notification.Name {
    static let newMessage = Notification.Name(rawValue: "newMessage")
}

struct Message {
    let content: String
    let author: String
}

class ViewController: UIViewController {

    @IBOutlet weak var allowSwitch: UISwitch!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    @Published var canSendMessage: Bool = false
    private var switchSubscriber: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpProcessingChain()
    }
    
    func setUpProcessingChain() {
        switchSubscriber = $canSendMessage.receive(on: DispatchQueue.main).assign(to: \.isEnabled, on: sendMessageButton)
        
        let messagePublisher = NotificationCenter.Publisher(center: .default, name: .newMessage).map { notification -> String? in
            return (notification.object as? Message)?.content ?? ""
        }
        let messageSubscriber = Subscribers.Assign(object: messageLabel, keyPath: \.text)
        messagePublisher.subscribe(messageSubscriber)
    }
    
    @IBAction func didSwitch(_ sender: UISwitch) {
        canSendMessage = sender.isOn
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
        let message = Message(content: "The current time is \(Date())", author: "Me")
        NotificationCenter().post(name: .newMessage, object: message)
        
    }
}

