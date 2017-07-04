//
//  TravelTableViewController.swift
//  TaipeiTravel
//
//  Created by PeterChen on 2017/7/4.
//  Copyright © 2017年 PeterChen. All rights reserved.
//

import UIKit

class TravelTableViewController: UITableViewController {

    let travelURL = "http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=36847f3f-deff-4183-a5bb-800737591de5"
    var travelInfos = [TravelInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTravelData()
        tableView.estimatedRowHeight = 139.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return travelInfos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TravelTableViewCell

        // Configure the cell...
        cell.address.text = travelInfos[indexPath.row].address
        cell.category.text = travelInfos[indexPath.row].category
        cell.MRTStation.text = travelInfos[indexPath.row].MRT
        cell.placeName.text = travelInfos[indexPath.row].title
        let data = NSData(contentsOf: URL(string: travelInfos[indexPath.row].travelImage)!)
        cell.placeImage.image = UIImage(data: data! as Data)!
        return cell
    }
    
    func getTravelData() {
        guard let travelUrl = URL(string: travelURL) else {
            print("URL error")
            return
        }
        var urlRequest = URLRequest(url: travelUrl)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) -> Void in
            if let error = error {
                print("Get Data Error")
                print(error)
                return
            }
            if let data = data {
                self.travelInfos = self.parseJSONData(data: data)
                OperationQueue.main.addOperation {self.tableView.reloadData()}
            }
            
        }
        task.resume()
    }
 
    func parseJSONData(data: Data) -> [TravelInfo] {
        var travelInfos = [TravelInfo]()
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: [String: AnyObject]]
            let jsonInfos = jsonResult?["result"]!["results"] as! [AnyObject]
            for jsonInfo in jsonInfos {
                let travelInfo = TravelInfo()
                travelInfo.title = jsonInfo["stitle"] as! String
                travelInfo.address = jsonInfo["address"] as! String
                travelInfo.category = jsonInfo["CAT2"] as! String
                travelInfo.description = jsonInfo["xbody"] as! String
//                travelInfo.openTime = jsonInfo["MEMO_TIME"] as! String
//                if jsonInfo["MRT"] {
//                    travelInfo.MRT = "無"
//                } else {
//                    travelInfo.MRT = jsonInfo["MRT"] as! String
//                }
                
//                travelInfo.traffic = jsonInfo["info"] as! String
                let travelImage = (jsonInfo["file"] as! String).components(separatedBy: "http://")
                travelInfo.travelImage = "http://\(travelImage[1])"
                print("Image: \(travelInfo.travelImage)")
                travelInfos.append(travelInfo)
            }
            
        } catch {
            print(error)
        }
        
        return travelInfos
    }

}
