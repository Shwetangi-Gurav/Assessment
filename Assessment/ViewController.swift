//
//  ViewController.swift
//  Assessment
//
//  Created by SensiBolApple on 16/09/21.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startBtn: UIButton!
    
    lazy var urls: [Any] = {
        return Site.urlList()
    }()
    var basicCellIdentifier = "basic"
    var subtitleCellIdentifier = "SubtitleTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    @IBAction func startBtnClicked(_ sender: Any) {
        startBtn.isHidden = true
        loadRequests()
    }
    
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: subtitleCellIdentifier, bundle: nil), forCellReuseIdentifier: subtitleCellIdentifier)
    }
    
    
    func loadRequests() {
        let group = DispatchGroup()
        DispatchQueue.global().async {
            for (i , url) in self.urls.enumerated() {
                group.enter()
                let siteurl = (url as? Site)?.name ?? ""
                let urlString = "https://\(siteurl)"
                URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, res, error) -> Void in
                    // Site loaded successfully.
                    // Respective favicon is being used for site.
                    if let response = res as? HTTPURLResponse {
                        let contentLength = response.allHeaderFields["Content-Length"] as? String ?? "Content length not found"
                        let faviconUrl = "\(urlString)/favicon.ico"
                        let contentStr = self.getContentLengthStr(length: contentLength)
                        let siteInfo: SiteInfo = SiteInfo.init(name: siteurl, length: contentStr)
                        siteInfo.image = faviconUrl
                        self.urls[i] = siteInfo
                        
                        let indexPath = IndexPath.init(row: i, section: 0)
                        DispatchQueue.main.sync {
                            self.tableView.reloadRows(at: [indexPath], with: .fade)
                        }
                        
                        group.leave()
                    } else {
                        // Error while loading site.
                        // Parsed the error code and system icon "exclamationmark.triangle" used.
                    
                        let errorCode = (error as? NSError)?.code ?? 0
                        let siteInfo: SiteInfo = SiteInfo.init(name: siteurl, length: "Error Code: \(errorCode)")
                        self.urls[i] = siteInfo
                        let indexPath = IndexPath.init(row: i, section: 0)
                        DispatchQueue.main.sync {
                            self.tableView.reloadRows(at: [indexPath], with: .fade)
                        }
                        group.leave()
                    }
                }).resume()
                group.wait()
            }
        }
    }
    
    private func getContentLengthStr(length: String) -> String {
        guard let len = Double(length) else {  return "0KB" }
        
        if len > 1000 {
            let leninMB = String(format: "%.2f", (len / 1000))
            return "\(leninMB)MB"
        }
        return "(\(len)KB"
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "CONTENTS"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let urlStr = urls[indexPath.row] as? Site {
            let cell = tableView.dequeueReusableCell(withIdentifier: basicCellIdentifier,for: indexPath)
            cell.textLabel?.text = urlStr.name
            return cell
        }
        
        if let urlinfo = urls[indexPath.row] as? SiteInfo {
            if let cell: SubtitleTableViewCell = tableView.dequeueReusableCell(withIdentifier: subtitleCellIdentifier,for: indexPath) as? SubtitleTableViewCell {
                cell.siteName?.text = urlinfo.name
                cell.contentLen?.text = "\(urlinfo.length)"
                let url = URL(string: urlinfo.image ?? "")
                cell.favIcon?.self.sd_setImage(with: url, placeholderImage: UIImage.init(systemName: "exclamationmark.triangle"))
                return cell
            }
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let _ = urls[indexPath.row] as? SiteInfo {
            return 70
        }
        return 60
    }
    
}


