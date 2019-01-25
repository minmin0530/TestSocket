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
    var manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.forceWebsockets(true)])
    var socket: SocketIOClient! //= self.manager.defaultSocket

    @IBOutlet var label: UILabel!
    @IBOutlet weak var textLabel: UITextField!
    
    var sendFlag :Bool = false
    @IBAction func send(_ sender: Any) {
        sendFlag = true
        self.test()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        socket = self.manager.defaultSocket
        test()
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        test()
//    }
    
    func test() {
        let rl :CFRunLoop = CFRunLoopGetCurrent();
        if sendFlag == true {
            manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.forceWebsockets(true)])
            socket = self.manager.defaultSocket
        }
        //        DispatchQueue.global(qos: .userInteractive).async {
        //
        //            DispatchQueue.main.async {
        socket.on("connect") { data, ack in
            print("socket connected")
            
            print("send message")
            if self.sendFlag == true {
                self.sendFlag = false
                self.socket.connect()

//                CFRunLoopStop(rl)

                self.socket.emit("from_client", self.textLabel.text!)
//                CFRunLoopRun()
                
            } else {
                self.socket.emit("from_client", "Hello")
            }
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

