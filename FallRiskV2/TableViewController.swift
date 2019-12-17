//
//  TableViewController.swift
//  FallRiskAR
//
//  Created by Arjun Arun on 12/1/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class TableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:  #selector(refreshRiskData), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    @objc func refreshRiskData() {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mainInstance.risks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "healthyCell", for: indexPath)
        cell.textLabel?.text = mainInstance.risks[indexPath.row].name
        return cell
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
     
         controller.dismiss(animated: true, completion: nil)
     
    }
    @IBAction func mailTable(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            var total = String()
            for risk in mainInstance.risks {
              total += "Risk: " + risk.name + ", Risk Level: " + risk.level + "\n"
            }
            guard let data = total.data(using: String.Encoding.utf8) else { return }
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setSubject("Fall Risk Data")
            mailComposeViewController.setMessageBody("Risks analyzed from FallRiskAR App attached to this email.", isHTML: false)
            mailComposeViewController.addAttachmentData(data , mimeType: "text/csv", fileName: "risks.csv")
            present(mailComposeViewController, animated: true, completion: nil)
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
