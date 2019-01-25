//
//  ViewController.swift
//  TestSocket
//
//  Created by IzumiYoshiki on 2019/01/22.
//  Copyright © 2019 IzumiYoshiki. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController {

    @IBOutlet var label: UILabel!
    @IBOutlet weak var textLabel: UITextField!
    
    var sendFlag :Bool = false
    @IBAction func send(_ sender: Any) {
        sendFlag = true

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rl :CFRunLoop = CFRunLoopGetCurrent();
        let manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.forceWebsockets(true)])
        let socket = manager.defaultSocket
//        DispatchQueue.global(qos: .userInteractive).async {
//
//            DispatchQueue.main.async {
            socket.on("connect") { data, ack in
                print("socket connected")
                
                print("send message")
                
                socket.emit("from_client", "Hello")
            }
            if sendFlag == true {
                sendFlag = false
                socket.connect()

                socket.emit("from_client", textLabel.text!)
                CFRunLoopRun()

            }
            socket.on("from_server") { data, ack in
                if let msg = data[0] as? String {
                    print("receive: " + msg)
                    
                    CFRunLoopStop(rl)
                    self.label.text = msg
                }
            }
            
            socket.connect()
            
            CFRunLoopRun()
//            }
//        }
        
    }

}

