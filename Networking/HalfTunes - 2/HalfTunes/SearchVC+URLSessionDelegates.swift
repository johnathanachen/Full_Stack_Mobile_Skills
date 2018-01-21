//
//  SearchVC+URLSessionDelegates.swift
//  HalfTunes
//
//  Created by Johnathan Chen on 1/20/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit

extension SearchViewController: URLSessionDownloadDelegate {
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//    func saveDownload(download : Download, location : URL?, response : URLResponse?, error : Error?) {
    guard let sourceURL = downloadTask.originalRequest?.url else {return}
      
      downloadService.activeDownloads[sourceURL] = nil
      
      let destinationURL = localFilePath(for: sourceURL)
      
      let fileManager = FileManager.default
      try? fileManager.removeItem(at: destinationURL)
      do {
        try fileManager.copyItem(at: location, to: destinationURL)
      } catch let error {
        print("Could not copy file to disk: \(error.localizedDescription)")
      }
      
      if let index = trackIndex(for: downloadTask) {
        DispatchQueue.main.async {
          self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
      }
    }
  
  fileprivate func trackIndex(for task: URLSessionDownloadTask) -> Int? {
    guard let url = task.originalRequest?.url else { return nil }
    let indexedTracks = searchResults.enumerated().filter() { $0.1.url == url }
    return indexedTracks.first?.0
  }
  
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    if let url = downloadTask.originalRequest?.url,
      let download = downloadService.activeDownloads[url] {
      download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
      let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
      
      if let trackIndex = trackIndex(for: downloadTask) {
          DispatchQueue.main.async {
            if let trackCell = self.tableView.cellForRow(at: IndexPath(row: trackIndex, section: 0)) as? ProgressUpdateDelegate {
            trackCell.updateDisplay(progress: download.progress, totalSize: totalSize)
          }
        }
      }
    }
  }
  
}

extension SearchViewController: URLSessionDelegate {
  
  func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    DispatchQueue.main.async {
      if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
        let completionHandler = appDelegate.backgroundSessionCompletionHandler {
        appDelegate.backgroundSessionCompletionHandler = nil
        completionHandler()
    }
  }
}

}






