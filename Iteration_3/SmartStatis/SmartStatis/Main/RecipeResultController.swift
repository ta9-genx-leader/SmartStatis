//
//  RecipeResultController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/4/24.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
import WebKit
/*
    This class is to manage the view for recipe result.
 */
class RecipeResultController: UIViewController, UITableViewDelegate, UITableViewDataSource,WKNavigationDelegate  {
    var viewDismissed = false
    var numberOfLoad = 0
    var dataArray = [[String: AnyObject]]()
    var keyword :String?
    var cellList = [RecipeCell]()
    let processing: UIActivityIndicatorView = UIActivityIndicatorView()
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var exitOutlet: UIButton!
    @IBAction func exitAction(_ sender: Any) {
        viewDismissed = true
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
        This method is to load the video from the url.
    */
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if viewDismissed {
            webView.stopLoading()
        }
    }

    /*
        This method is to determine the number of rows in each section.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    /*
        This method is to determine the numher of sections in the table view.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /*
        This method is to initiate the view for the cells in the table view.
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row + 1 > cellList.count {
            if processing.isAnimating {
                stopProcessing()
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
            let videoId = dataArray[indexPath.row]["videoID"] as! String
            let title = dataArray[indexPath.row]["title"] as! String
            cell.titleTextView.text = title.htmlDecoded
            cell.videoView.load(withVideoId: videoId)
            cell.videoView.backgroundColor = UIColor.black
            cellList.append(cell)
            return cell
        }
        else {
            return cellList[indexPath.row]
        }
    }
    
    /*
        This method is to determine the height for the rows in each section.
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return self.view.frame.size.height/2
    }
    
    /*
        This method is to search videos for the recipe from Youtube.
     */
    func search(keyword:String) {
        let videoType = keyword.replacingOccurrences(of: " ", with: "+")
        let apiKey = "AIzaSyDSqPMGrUCyPyrZWSkCSABN6cgsU9EaH2I"
        var urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(videoType)&type=video&videoSyndicated=true&chart=mostPopular&maxResults=10&safeSearch=strict&order=relevance&order=viewCount&type=video&relevanceLanguage=en&regionCode=AU&key=\(apiKey)"
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
                            if !self.viewDismissed {
                                self.tableView.reloadData()
                            }
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Recipe Not Found", message: "Please Try Again", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { [weak alert] (_) in
                                self.dismiss(animated: true, completion: nil)
                            }))
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
        This method is to initiate the view when it is loaded.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        startProcessing()
        exitOutlet.setRadiusWithShadow()
        self.tableView.alwaysBounceVertical = false
        self.tableView.allowsSelection = false
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.5))
        self.tableView.clipsToBounds = true
        self.tableView.layer.cornerRadius = 10.0
        self.tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        detailView.backgroundColor = UIColor(red: 200/255, green: 229/255, blue: 199/255, alpha: 1.0)
        detailView.layer.masksToBounds = false
        detailView.layer.shadowOffset = CGSize(width: -1, height: 1)
        detailView.layer.shadowOpacity = 0.4
        detailView.layer.shadowRadius = 2
        detailView.layer.cornerRadius = 10.0
        search(keyword: keyword!)
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
    }
}

extension WKWebView {
    /*
        This function is to add shadow to a Web view.
     */
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shouldRasterize = true
        layer.cornerRadius = 5.0
        layer.shadowRadius = 2
    }
}

extension UITextView {
    /*
        This function is to add shadow to a text view.
     */
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: -1, height: 1)
        //layer.shouldRasterize = true
        layer.shadowRadius = 2
    }
}

extension String {
    /*
        This function is to decode special characters sent from web view.
     */
    var htmlDecoded: String {
        let decoded = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil).string
        
        return decoded ?? self
    }
}
