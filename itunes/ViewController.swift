//
//  ViewController.swift
//  itunes
//
//  Created by Argueta, Adan on 5/4/20.
//  Copyright © 2020 Argueta, Adan. All rights reserved.
//

import UIKit
import SwiftOverlays
import Alamofire
import AlamofireImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var mediaDict = Dictionary<String,[Media]>()
    var sections = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBAction func searchButtonTapped(_ sender: Any) {
        if searchTextField.text?.count ?? 0 > 1 {
            showWaitOverlay()
            let searchTerm = searchTextField.text?.replacingOccurrences(of: " ", with: "+")
            WebService().fetchItunesResultsFor(query: searchTerm!, success: {[weak self] dictionary in
                self?.mediaDict = dictionary
                self?.prepareDataAndReload()
                self?.removeAllOverlays()
            }, failure: {_ in
                
                self.removeAllOverlays()
            })
        }
    }
    
    func prepareDataAndReload() {
        sections = Array<String>(mediaDict.keys)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.setContentOffset(.zero, animated: false)
            self?.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaDict[sections[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mediaCell", for: indexPath) as? MediaCell
        
        let media = mediaFrom(indexPath: indexPath)
        cell?.configure(name: media?.name, artist: media?.artistName, imageUrl: media?.artworkUrl)
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPreview" {
            if let vc = segue.destination as? PreviewViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let media = mediaFrom(indexPath: indexPath)
                    vc.url = media?.previewURL ?? ""
                }
            }
        }
    }
    
    func mediaFrom(indexPath: IndexPath) -> Media? {
        return mediaDict[sections[indexPath.section]]?[indexPath.row]
    }
    
}


class MediaCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(name: String?, artist: String?, imageUrl: String?) {
        textLabel?.text = name
        detailTextLabel?.text = artist
        if let url = URL.init(string: imageUrl ?? "") {
            imageView?.af_setImage(withURL: url)
        }
    }
}


