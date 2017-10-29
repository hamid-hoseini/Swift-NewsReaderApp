//
//  ViewController.swift
//  NewsReaderApp
//
//  Created by Hamid Hoseini on 10/21/17.
//  Copyright © 2017 Hamid Hoseini. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var articles: [Article]? = []
    let menuManager = MenuManager()
    var source = "techcrunch"
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchArticles(fromSource: source)
    }

    func fetchArticles(fromSource provider: String) {
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v1/articles?source=\(provider)&apiKey=")!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            self.articles = [Article]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                if let articlesFromJson = json["articles"] as? [[String: AnyObject]] {
                    for articleFromJson in articlesFromJson {
                        let article = Article()
                        if let  title = articleFromJson["title"] as? String,
                           let  author = articleFromJson["author"] as? String,
                           let  desc = articleFromJson["description"] as? String,
                           let  url = articleFromJson["url"] as? String,
                           let  urlToImage = articleFromJson["urlToImage"] as? String {
                            
                            article.author = author
                            article.desc = desc
                            article.url = url
                            article.imageUrl = urlToImage
                            article.headline = title
                            
                        }
                        self.articles?.append(article)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                print (error)
                return
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        cell.titleLabel.text = self.articles? [indexPath.item].headline
        cell.autorLabel.text = self.articles? [indexPath.item].author
        cell.descLabel.text = self.articles? [indexPath.item].desc
        cell.imgView?.downloadImage(from: (self.articles? [indexPath.item].imageUrl)!)
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let webVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "webId") as! WebViewController
        
        webVC.url = self.articles?[indexPath.item].url
        self.present(webVC, animated: true, completion: nil)
    }
    @IBAction func menuBtnPressed(_ sender: Any) {
        menuManager.openMenu()
        menuManager.mainVC = self
    }
}

extension UIImageView {
    func downloadImage(from url: String) {
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response , error) in
            if error != nil {
                print (error!)
                return
            }
            DispatchQueue.main.sync {
                self.image = UIImage(data: data! )
            }
        }
        task.resume()
    }
}

