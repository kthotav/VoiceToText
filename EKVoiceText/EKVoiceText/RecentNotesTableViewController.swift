//
//  RecentNotesTableViewController.swift
//  EKVoiceText
//
//  Created by Karthik on 4/16/16.
//  Copyright © 2016 KarthikThota. All rights reserved.
//

import UIKit
import Firebase
import SwiftSpinner


class RecentNotesTableViewController: UITableViewController {

    // MARK: - Outlets

    
    // MARK: - Fields
    var notesID: Int?
    var notesInfo = NSDictionary()
    var notes = [String]()
    var users = [String]()
    let whiteColor = UIColor.whiteColor()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let backgroundImage = UIImage(named: "background")
//        let imageView = UIImageView(image: backgroundImage)
//        self.tableView.backgroundView = imageView
//        imageView.contentMode = .ScaleAspectFill
        
//        self.tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
//        self.tabBarController?.tabBar.barTintColor = whiteColor

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        loadNotes()
        self.notes = notes.reverse()
        self.users = users.reverse()
        tableView.reloadData()
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("note", forIndexPath: indexPath) as! NoteTableViewCell

       
        cell.noteLabel.text = notes[indexPath.row]
        cell.byLabel.text = "By: " + users[indexPath.row]


        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = .clearColor()
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        /*
        if segue.identifier == "showNoteDetail" {
            let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
            let notesDetailViewController = segue.destinationViewController as! NotesdetailViewController
            
            notesDetailViewController.noteDetail = notes[indexPath.row]
        }*/
        
        if segue.identifier == "showNoteDetail" {
            let indexPath: NSIndexPath = self.tableView.indexPathForSelectedRow!
            let notesDetailViewController = segue.destinationViewController as! AddNoteViewController
            
            notesDetailViewController.appendedNote = notes[indexPath.row]

        }
        
        if segue.identifier == "addNote" {
            SwiftSpinner.show("Loading...")
        }
        
    }
 
    
    func loadNotes() {
        var recentNotes = [String]()
        // var recentDates = [String]()
        var recentUsers = [String]()
        if let notesArray = notesInfo.valueForKey("notes") as? NSArray {
            for notes in notesArray {
                if let note = notes["notetext"] {
                    let unwrappedNote = note!
                    recentNotes.append(unwrappedNote as! String)
                    
                } else {
                    print ("note does not eixst")
                }
                
                if let user = notes["user"] {
                    let unwrappedUser = user!
                    recentUsers.append(unwrappedUser as! String)
                }
            }
            
        } else {
            print ("no notes")
        }
        
        self.notes = recentNotes
        self.users = recentUsers
        // self.dates = recentDates
        
    }
    
    @IBAction func cancelNoteViewController(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func saveNoteViewControlle(segue:UIStoryboardSegue) {
        let url = "https://ekvoicetext.firebaseio.com/"+"\(notesID!)"
        let ref = Firebase(url: url);
        let newNote =  ["date": "2015-11-15 11:15:38", "notetext": "\(newNoteText)", "user": "karthik"]
        let notesRef = ref.childByAppendingPath("notes")
        notesRef.childByAppendingPath("\(notes.count)").setValue(newNote)
        
        
        //add the new note to the notes and users arrays
        notes.insert(newNote["notetext"]!, atIndex:0)
        users.insert(newNote["user"]!, atIndex: 0)
        
        //update the tableView
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
  


}
