
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!
    
    var nameArray = [String]()
    var dobArray = [String]()
    var ImageArray = [String]()
    

    let strURL = "http://microblogging.wingnity.com/JSONParsingTutorial/jsonActors"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
      self.downloadJSONWithURL()
        
    }

    func downloadJSONWithURL()
    {
        let url = NSURL(string: strURL)
        
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: { (data, response, error) in
            
            if let mainDict = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
            {
                if let actorArray = mainDict.value(forKey: "actors") as? NSArray
                {
                    for actor in actorArray
                    {
                        if let actorDict = actor as? NSDictionary
                        {
                            if let name = actorDict.value(forKey: "name")
                            {
                                self.nameArray.append(name as! String)
                            }
                            if let dob = actorDict.value(forKey: "dob")
                            {
                                self.dobArray.append(dob as! String)
                            }
                            if let img = actorDict.value(forKey: "image")
                            {
                                self.ImageArray.append(img as! String)
                            }
                        }
                    }
                }
                OperationQueue.main.addOperation ({
                    self.tblView.reloadData()
                })
            }
          
            
        }).resume()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return nameArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        
        cell.nameLabel.text = nameArray[indexPath.row]
        cell.dobLabel.text = dobArray[indexPath.row]
        
        let imgURL = NSURL(string: ImageArray[indexPath.row])
        
        if imgURL != nil
        {
            let data = NSData(contentsOf: imgURL as! URL)
            cell.imageView?.image = UIImage(data: data as! Data)
        }
        
        
        return cell
    }
    

}

