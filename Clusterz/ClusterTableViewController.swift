
import UIKit
import Foundation

class ClusterTableViewController: UITableViewController {

    let API_URL = "http://origin-www.svt.se/play4api/taglist/metadata"
    var clusters = [Cluster]()
    
    struct Cluster {
        var name: String
        var description: String
        var image: UIImage!
        
        init(data: NSDictionary) {
            self.name = data["name"] as! String
            
            if let descriptionText = data["description"] {
                self.description = descriptionText as! String
            } else {
                self.description = ""
            }
            
            if let thumbnailUrl = data["thumbnailSquare"] {
                if let url = NSURL(string: thumbnailUrl as! String) {
                    if let data = NSData(contentsOfURL: url) {
                        self.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: API_URL)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, errord) in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                do {
                    let values = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSArray
                
                    self.clusters = values.map({ (value: AnyObject) -> Cluster in
                        let dict = value as! NSDictionary
                        return Cluster(data: dict)
                    })
                
                    self.tableView.reloadData()
                } catch {
                    print("json error: \(error)")
                }
            }
        }
        
        task.resume()
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
        return self.clusters.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ClusterTableViewCell = tableView.dequeueReusableCellWithIdentifier("ClusterTableViewCell", forIndexPath: indexPath) as! ClusterTableViewCell
        
        let cluster = self.clusters[indexPath.row]
        cell.label.text = cluster.name
        cell.descriptionText.text = cluster.description
        cell.thumbnailImage.image = cluster.image
        return cell
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
        print("Segue id \(segue.identifier)")
        if (segue.identifier! == "showDetails") {
            if let destination = segue.destinationViewController as? DetailsViewController {
                if let index = tableView.indexPathForSelectedRow?.row {

                    let cluster = self.clusters[index]

                    destination.clusterImage = cluster.image
                    destination.clusterName = cluster.name
                }
            }
        }
    }


}
