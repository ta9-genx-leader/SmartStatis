//
//  RecipeTableController.swift
//  SmartStatis
//
//  Created by wu yun en on 2019/5/1.
//  Copyright © 2019 GenX Leader. All rights reserved.
//

import UIKit
import WebKit
class RecipeTableController: UITableViewController,WKNavigationDelegate, UISearchBarDelegate {
    var viewDismissed = false
    var reload = false
    var dataArray = [[String: AnyObject]]()
    let processing: UIActivityIndicatorView = UIActivityIndicatorView()
    var dataLoad = false
    var cellList = [RecipeVideoCell]()
    @IBOutlet weak var searchBar: UISearchBar!
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if viewDismissed {
            webView.stopLoading()
        }
    }
    
    /*
     This method is to determine the height for the rows in each section.
     */
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return self.view.frame.size.height/2
    }
    
    /*
        This method is to initiate the view when it is loaded into memory.
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keyword = "Recipe with" + searchBar.text!
        search(keyword: keyword)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar = tabBarController as! TabBarViewController
        dataArray = tabBar.dataArray
        searchBar.delegate = self
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    /*
     This method is to search videos for the recipe from Youtube.
     */
    func search(keyword:String) {
        let videoType = keyword.replacingOccurrences(of: " ", with: "+")
        let apiKey = "AIzaSyB-axMN7H1QwsyN5SbrAN5Fo-ZWtG6k7pQ"
        var urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(videoType)&type=video&videoSyndicated=true&chart=mostPopular&maxResults=15&safeSearch=strict&order=relevance&order=viewCount&type=video&relevanceLanguage=en&regionCode=AU&key=\(apiKey)"
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
                            if !self.viewDismissed {
                                self.reload = true
                                self.tableView.reloadData()
                            }
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
     This method is to initiate the view for the cells in the table view.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row + 1 > cellList.count || reload {
            if processing.isAnimating {
                stopProcessing()
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeVideoCell", for: indexPath) as! RecipeVideoCell
            let videoId = dataArray[indexPath.row]["videoID"] as! String
            let title = dataArray[indexPath.row]["title"] as! String
            let url = URL(string: "https://www.youtube.com/embed/" + videoId)!
            print(url)
            cell.titleTextView.text = title.htmlDecoded
            cell.recipeVideoView.navigationDelegate = self
            cell.recipeVideoView.load(URLRequest(url: url))
            cell.recipeVideoView.backgroundColor = UIColor.black
            cell.textViewHeightConstraint.constant = cell.titleTextView.contentSize.height
            cellList.append(cell)
            return cell
        }
        else {
            return cellList[indexPath.row]
        }
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
