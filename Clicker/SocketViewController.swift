//
//  LectureViewController.swift
//  Clicker
//
//  Created by AE7 on 4/12/17.
//  Copyright © 2017 cuappdev. All rights reserved.
//

import UIKit
import SocketIO

class SocketViewController: UIViewController {
    
    var socket: SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///
        socket = SocketIOClient(socketURL: URL(string: "http://10.148.6.14:3000")!, config: [.forcePolling(true)])
        
        socket.on("connect") { data, ack in
            print("socket connected")
        }
        
        socket.on("message") { data in
            print(data)
        }
        
        socket.connect()
        
        let b = UIButton(frame: CGRect(x: 15, y: 50, width: 100, height: 50))
        b.backgroundColor = .red
        b.setTitle("Hi Dan!", for: .normal)
        view.addSubview(b)
        b.addTarget(self, action: #selector(emitSocketMsg(sender:)), for: .touchUpInside)
    }
    
    func emitSocketMsg(sender: UIButton) {
        socket.emit("message", sender.title(for: .normal) ?? "")
    }
}
