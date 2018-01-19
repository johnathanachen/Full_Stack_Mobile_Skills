//
//  ViewController.swift
//  PrettyIcons
//
//  Created by Johnathan Chen on 1/18/18.
//  Copyright © 2018 JCSwifty. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var iconSets = [IconSet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconSets = IconSet.iconSets()

       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return iconSets.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let iconSet = iconSets[section]
        return iconSet.icons.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let iconSet = iconSets[section]
        return iconSet.name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        
        let iconSet = iconSets[indexPath.section]
        
        let icon = iconSet.icons[indexPath.row]
        
        cell.textLabel?.text = icon.title
        cell.detailTextLabel?.text = icon.subtitle
        
        if let iconImage = icon.image {
            cell.imageView?.image = iconImage
        }
        
        return cell
    }
    
}

