//
//  RecipeViewController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/5/2.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
/*
    This controller is to manage the view for searching indregients from Youtube.
 */
class RecipeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    var dataArray = [[String: AnyObject]]()
    let processing: UIActivityIndicatorView = UIActivityIndicatorView()
    var dataLoad = false
    var cellList = [RecipeCell]()
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    /*
        This function is to manage the action when the user taps the "Search" button.
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        if !self.checkWiFi() {
            let alert = UIAlertController(title: "Disconnection", message: "Your device is disconnected.\r\nplease try to login again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                self.dismiss(animated: false, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let keyword = "Recipe with" + searchBar.text!
        search(keyword: keyword)
    }
    
    /*
        This function is to determine the number of rows for each section in the table view.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataArray.count == 0 {
            return 1
        }
        return dataArray.count
    }
    
    /*
        This function is to determine number of sections in the table view.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        if dataArray.count == 0 {
            return 2
        }
        return 1
    }
    
    /*
        This function is to initialize the view before it appears.
     */
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.backgroundView = UIImageView(image: UIImage(named: "cookingView"))
        self.tableView.backgroundView?.alpha = 0.2
    }
    
    /*
     This function is to determine the height for the rows in each section.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170 + self.view.frame.size.height/6
    }
    
    /*
        This function is to determine the number of cells for each section in the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataArray.count == 0 {
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableCell", for: indexPath) as! RecipeCell
                cell.videoTitle.text = ""
                cell.videoTitle.layer.backgroundColor = UIColor.clear.cgColor
                cell.recipeVideoView.layer.backgroundColor = UIColor.clear.cgColor
                cell.videoTitle.backgroundColor = UIColor.lightGray
                cell.recipeVideoView.backgroundColor = UIColor.lightGray
                cell.videoTitle.layer.cornerRadius = 10
                cell.videoTitle.layer.masksToBounds = true
                cell.recipeVideoView.layer.cornerRadius = 10
                cell.recipeVideoView.layer.masksToBounds = true
                print(cell.contentView.subviews.count)
                let height = 150 + self.view.frame.size.height/6
                if cell.contentView.subviews.count < 3 {
                    cell.contentView.backgroundColor = UIColor.clear
                    let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 10, width: self.view.frame.size.width - 20, height: height))
                    whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
                    whiteRoundedView.layer.masksToBounds = false
                    whiteRoundedView.layer.cornerRadius = 10.0
                    whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
                    whiteRoundedView.layer.shadowOpacity = Float(0.3/(Double(indexPath.row)+1))
                    whiteRoundedView.layer.shadowRadius = 2
                    cell.contentView.addSubview(whiteRoundedView)
                    cell.contentView.sendSubviewToBack(whiteRoundedView)
                }
                cell.backgroundColor = UIColor.clear
                cell.contentView.layer.opacity = Float(0.5/(Double(indexPath.row)+1))
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTextCell", for: indexPath) as! TextCell
                cell.backgroundColor = UIColor.clear
                return cell
            }
        }
        if indexPath.row + 1 > cellList.count {
            if processing.isAnimating {
                stopProcessing()
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableCell", for: indexPath) as! RecipeCell
            let videoId = dataArray[indexPath.row]["videoID"] as! String
            let title = dataArray[indexPath.row]["title"] as! String
            cell.videoTitle.text = title.htmlDecoded
            cell.videoTitle.layer.cornerRadius = 10
            cell.videoTitle.layer.masksToBounds = true
            cell.recipeVideoView.layer.cornerRadius = 10
            cell.recipeVideoView.layer.masksToBounds = true
            cell.videoTitle.layer.backgroundColor = UIColor.clear.cgColor
            cell.recipeVideoView.load(withVideoId: videoId)
            cell.recipeVideoView.layer.backgroundColor = UIColor.black.cgColor
            cellList.append(cell)
            print(cell.contentView.subviews.count)
            let height = 150 + self.view.frame.size.height/6
            if cell.contentView.subviews.count < 3 {
                cell.contentView.backgroundColor = UIColor.clear
                let whiteRoundedView : UIView = UIView(frame: CGRect(x: 10, y: 10, width: self.view.frame.size.width - 20, height: height))
                whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.9])
                whiteRoundedView.layer.masksToBounds = false
                whiteRoundedView.layer.cornerRadius = 10.0
                whiteRoundedView.layer.shadowOffset = CGSize(width: -1, height: 1)
                whiteRoundedView.layer.shadowOpacity = 0.4
                whiteRoundedView.layer.shadowRadius = 2
                cell.contentView.addSubview(whiteRoundedView)
                cell.contentView.sendSubviewToBack(whiteRoundedView)
            }
            cell.contentView.layer.opacity = 1
            cell.backgroundColor = UIColor.clear
            return cell
        }
        else {
            cellList[indexPath.row].videoTitle.layer.cornerRadius = 10
            cellList[indexPath.row].videoTitle.layer.masksToBounds = true
            cellList[indexPath.row].recipeVideoView.layer.cornerRadius = 10
            cellList[indexPath.row].recipeVideoView.layer.masksToBounds = true
            return cellList[indexPath.row]
        }
    }
    
    /*
        This function is to initialize the view when it is loaded.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        processing.transform = CGAffineTransform(scaleX: 2, y: 2)
        searchBar.layer.shadowColor = UIColor.black.cgColor
        searchBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        searchBar.layer.shadowRadius = 2.0
        searchBar.layer.shadowOpacity = 0.4
        searchBar.layer.masksToBounds = false
        searchBar.backgroundColor = UIColor.darkGray
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.5))
        tableView.allowsSelection = false
        searchBar.delegate = self
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    /*
     This method is to search videos for the recipe from Youtube.
     */
    func search(keyword:String) {
        startProcessing()
        cellList = [RecipeCell]()
        let videoType = keyword.replacingOccurrences(of: " ", with: "+")
        let apiKey = HttpUrl().youtubeApiKey
        var urlString = HttpUrl().getYoutubeUrl(videoType:videoType,apiKey:apiKey)
        urlString = urlString.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed)!
        let targetURL = URL(string: urlString)
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: targetURL!) {
            data, response, error in
            if error != nil {
                print(error!.localizedDescription)
                let alert = UIAlertController(title: "Video Not Found", message: "Please try agian.", preferredStyle: .alert)
                self.present(alert, animated: true)
                return
            }
            else {
                do {
                    typealias JSONObject = [String:AnyObject]
                    let  json = try JSONSerialization.jsonObject(with: data!, options: []) as! JSONObject
                    let
                    items = json["items"] as! Array<JSONObject>
                    self.dataArray = [[String: AnyObject]]()
                    if items.count  != 0 {
                        for i in 0 ..< items.count {
                            let snippetDictionary = items[i]["snippet"] as! JSONObject
                            // Initialize a new dictionary and store the data of interest.
                            var youVideoDict = JSONObject()
                            youVideoDict["title"] = snippetDictionary["title"]
                            youVideoDict["channelTitle"] = snippetDictionary["channelTitle"]
                            youVideoDict["thumbnail"] = ((snippetDictionary["thumbnails"] as! JSONObject)["high"] as! JSONObject)["url"]
                            youVideoDict["videoID"] = (items[i]["id"] as! JSONObject)["videoId"]
                            self.dataArray.append(youVideoDict)
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.stopProcessing()
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Recipe Not Found", message: "Please Try Again", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                }
                catch {
                    print("json error: \(error)")
                }
            }
        }
        task.resume()
    }

    /*
     This method is to start the processing animation.
     */
    func startProcessing() {
        processing.center = self.view.center
        processing.hidesWhenStopped = true
        tableView.accessibilityElementsHidden = true
        processing.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(processing)
        processing.startAnimating()
    }
    
    /*
     This method is to stop the processing animation.
     */
    func stopProcessing() {
        tableView.accessibilityElementsHidden = false
        processing.stopAnimating()
        if !self.checkWiFi() {
            let alert = UIAlertController(title: "Disconnection", message: "Your device is disconnected.\r\nplease try to login again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: {(UIAlertAction) -> Void in
                self.navigationController?.dismiss(animated: false, completion: nil)
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
}
