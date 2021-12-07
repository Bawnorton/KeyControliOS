//
//  ViewController.swift
//  KeyControlSB
//
//  Created by Benjamin Norton on 2021-12-05.
//

import UIKit
import SwiftUI
import MultipeerConnectivity

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rotation = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(rotation, forKey: "orientation")
        
        let child = UIHostingController(rootView: KeyBoardView())
        child.view.translatesAutoresizingMaskIntoConstraints = false
        
        child.view.widthAnchor.constraint(equalToConstant: CGFloat(Device.width)).isActive = true
        child.view.heightAnchor.constraint(equalToConstant: CGFloat(2*Device.height - Device.keyHeightConst - 49)).isActive = true
        
//      For Testing
///        self.view.layer.borderWidth = 10
///        self.view.layer.borderColor = UIColor.red.cgColor

        self.view.addSubview(child.view)
        self.addChild(child)
    }
    
    func onPress(actionID: Int) {
        sendKeyAction(actionID: actionID, pressed: 0)
    }
    func onRelease(actionID: Int) {
        sendKeyAction(actionID: actionID, pressed: 1)
    }
    func sendKeyAction(actionID: Int, pressed: Int) {
        if MCGlobal.session == nil {
            return
        }
        if MCGlobal.session.connectedPeers.count > 0 {
            do {
                var data = Data()
                data.append(contentsOf: [UInt8(actionID)])
                data.append(contentsOf: [UInt8(pressed)])
                try MCGlobal.session.send(data, toPeers: MCGlobal.session.connectedPeers, with: .reliable)
            } catch {}
        } else {
            let ac = UIAlertController(title: "No Connected Peers", message: "", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in }))
            self.children.first!.present(ac, animated: true)
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override public var shouldAutorotate: Bool {
        return true
    }
}

