//
//  LocationsTableViewController.swift
//  OnTheMap
//
//  Created by Antonio Maradiaga on 28/03/2015.
//  Copyright (c) 2015 Antonio Maradiaga. All rights reserved.
//

import UIKit

class LocationsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var studentsTableView: UITableView!
    
    var studentLocations = [StudentInformation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarItem.selectedImage = UIImage(named: "list")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        studentLocations = ParseClient.sharedInstance().allStudentLocations
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshData(sender: AnyObject?) {
        studentsTableView.reloadData()
    }

    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("studentLocationCell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = "\(studentLocations[indexPath.row].fullName)"
        cell.detailTextLabel?.text = "\(studentLocations[indexPath.row].mapString!)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UIApplication.sharedApplication().openURL(NSURL(string: studentLocations[indexPath.row].mediaURL!)!)
    }

}
