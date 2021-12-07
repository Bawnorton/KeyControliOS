//
//  HostViewController.swift
//  KeyControlSB
//
//  Created by Benjamin Norton on 2021-12-05.
//

import Foundation
import UIKit
import MultipeerConnectivity

struct MCGlobal {
    static var peerID: MCPeerID!
    static var session: MCSession!
    static var advertiserAssistant: MCNearbyServiceAdvertiser! = nil
}

class HostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate {
    
    let cellReuseIdentifier = "cell"
    
    var connections: [String] = []
    
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        table.delegate = self
        table.dataSource = self
        
        setupConnectivity()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        perform(#selector(rotate), with: nil, afterDelay: 0.01)
    }
    
    @objc func rotate() {
        let rotation = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(rotation, forKey: "orientation")
    }
    
    @IBAction func closeSession(_ sender: UIButton) {
        if MCGlobal.advertiserAssistant != nil {
            MCGlobal.advertiserAssistant.stopAdvertisingPeer()
            MCGlobal.advertiserAssistant = nil
            MCGlobal.session.disconnect()
            let ac = UIAlertController(title: "Stopped Hosting", message: "", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in }))
            present(ac, animated: true)
            connections.removeAll()
            table.reloadData()
        } else {
            let ac = UIAlertController(title: "Not Currently Hosting", message: "", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in }))
            present(ac, animated: true)
        }
    }
    
    @IBAction func hostSession(_ sender: UIButton) {
        host()
        let ac = UIAlertController(title: "Started Hosting", message: "", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in }))
        present(ac, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = (table.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        cell.textLabel?.text = "Empty Connection"
        if self.connections.count > indexPath.row {
            cell.textLabel?.text = self.connections[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if connections.count > indexPath.row {
            if MCGlobal.session != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let secondVC = storyboard.instantiateViewController(identifier: "keyboardVC")

                show(secondVC, sender: self)
            }
        }
    }
    
    func setupConnectivity() {
        MCGlobal.peerID = MCPeerID(displayName: UIDevice.current.name)
        MCGlobal.session = MCSession(peer: MCGlobal.peerID, securityIdentity: nil, encryptionPreference: .required)
        MCGlobal.session.delegate = self
    }
    
    func host() {
        MCGlobal.advertiserAssistant = MCNearbyServiceAdvertiser(peer: MCGlobal.peerID, discoveryInfo: nil, serviceType: "key-transfer")
        MCGlobal.advertiserAssistant.delegate = self
        MCGlobal.advertiserAssistant.startAdvertisingPeer()
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
            self.connections = self.connections.filter{$0 != peerID.displayName}
        @unknown default:
            break
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {

    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let ac = UIAlertController(title: "Incoming Connection", message: "'\(peerID.displayName)' wants to connect", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Accept", style: .default, handler: { _ in
                    invitationHandler(true, MCGlobal.session)
                    self.connections.append("\(peerID.displayName)")
                    self.table.reloadData()
                }))
                ac.addAction(UIAlertAction(title: "Decline", style: .cancel, handler: { _ in
                    invitationHandler(false, nil)
                }))
                present(ac, animated: true)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override public var shouldAutorotate: Bool {
        return true
    }
}
