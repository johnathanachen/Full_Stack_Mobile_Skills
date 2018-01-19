//
//  ViewController.swift
//  CollectionViewDemo
//
//  Created by Johnathan Chen on 1/18/18.
//  Copyright © 2018 JCSwifty. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var deleteButton: UIBarButtonItem!
    @IBOutlet private weak var addButton: UIBarButtonItem!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    @IBAction func deleteSelected() {
        if let selected = collectionView.indexPathsForSelectedItems {
            let items = selected.map{$0.item}.sorted().reversed()
            for item in items {
                collectionData.remove(at: item)
            }
            collectionView.deleteItems(at: selected)
        }
    }
    
    @IBAction func addItem() {
        collectionView.performBatchUpdates({
            for _ in 0..<2 {
                let text = "\(collectionData.count + 1) 🐱"
                collectionData.append(text)
                let index = IndexPath(row: collectionData.count - 1, section: 0)
                collectionView.insertItems(at: [index])
            }
        }, completion: nil)
    }

    var collectionData = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    
    @objc func refresh() {
        addItem()
        collectionView.refreshControl?.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // refresh the page upon pull down
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        collectionView.refreshControl = refresh
        
        // set the layout to 3 columns
        let width = (view.frame.size.width - 20) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = deleteButton
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            if let dest = segue.destination as? DetailsViewController,
                let index = sender as? IndexPath {
                dest.selection = collectionData[index.row]
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        deleteButton.isEnabled = editing
        addButton.isEnabled = !editing
        
        collectionView.allowsMultipleSelection = editing
        
        let indexes = collectionView.indexPathsForVisibleItems
        for index in indexes {
            let cell = collectionView.cellForItem(at: index) as! CollectionViewCell
            cell.isEditing = editing
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.titleLabel.text = collectionData[indexPath.row]
        cell.isEditing = isEditing
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            performSegue(withIdentifier: "DetailSegue", sender: indexPath)
        }
    }
    
    
}

