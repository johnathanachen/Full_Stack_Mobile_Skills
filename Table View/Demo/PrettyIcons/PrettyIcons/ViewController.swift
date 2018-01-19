//
//  ViewController.swift
//  PrettyIcons
//
//  Created by Johnathan Chen on 1/18/18.
//  Copyright © 2018 JCSwifty. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var iconSets = [IconSet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconSets = IconSet.iconSets()
        navigationItem.rightBarButtonItem = editButtonItem
        
        tableView.allowsSelectionDuringEditing = true

       
    }

}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            
            tableView.beginUpdates()
            for (index, set) in iconSets.enumerated() {
                let indexPath = NSIndexPath(row: set.icons.count, section: index)
                tableView.insertRows(at: [indexPath as IndexPath], with: .automatic)
            }
            tableView.endUpdates()
            tableView.setEditing(true, animated: true)
        } else {
            tableView.beginUpdates()
            for (index, set) in iconSets.enumerated() {
                let indexPath = NSIndexPath(row: set.icons.count, section: index)
                tableView.deleteRows(at: [indexPath as IndexPath], with: .automatic)
            }
            tableView.endUpdates()
            tableView.setEditing(false, animated: true)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return iconSets.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let adjustment = isEditing ? 1 : 0
        
        let iconSet = iconSets[section]
        return iconSet.icons.count + adjustment
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let iconSet = iconSets[section]
        return iconSet.name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        
        let iconSet = iconSets[indexPath.section]
        
        if indexPath.row >= iconSet.icons.count && isEditing {
            
            cell.textLabel?.text = "Add Icon"
            cell.detailTextLabel?.text = nil
            cell.imageView?.image = nil
            
        } else {
            let icon = iconSet.icons[indexPath.row]
            
            cell.textLabel?.text = icon.title
            cell.detailTextLabel?.text = icon.subtitle
            
            if let iconImage = icon.image {
                cell.imageView?.image = iconImage
            } else {
                cell.imageView?.image = nil
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let set = iconSets[indexPath.section]
            set.icons.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            let newIcon = Icon(withTitle: "New Icon", subtitle: "", imageName: nil)
            let set = iconSets[indexPath.section]
            set.icons.append(newIcon)
            tableView.insertRows(at: [indexPath as IndexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        let set = iconSets[indexPath.section]
        if indexPath.row >= set.icons.count {
            return .insert
        }
        return .delete
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let set = iconSets[indexPath.section]
        if isEditing && indexPath.row < set.icons.count {
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let set = iconSets[indexPath.section]
        if indexPath.row >= set.icons.count && isEditing {
            self.tableView(tableView, commit: .insert, forRowAt: indexPath)
        }
    }
    
}


















