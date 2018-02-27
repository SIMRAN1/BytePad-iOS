//
//  DownloadViewController.swift
//  BytePad
//

//  Copyright © 2016 Software Incubator. All rights reserved.
//

import UIKit
import QuickLook

class DownloadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, QLPreviewControllerDataSource {
    
    var items = [(name:String,detail:String,url:String)]()
    
    @IBOutlet weak var downloadsTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(items[(indexPath as NSIndexPath).row].url)
        
        //        performSegueWithIdentifier("DocumentViewSegue", sender: items[indexPath.row].url)
        
        let previewQL = QLPreviewController() // 4
        previewQL.dataSource = self // 5
        previewQL.currentPreviewItemIndex = (indexPath as NSIndexPath).row // 6
      //  navigationController?.pushViewController(previewQL, animated: true)
        present(previewQL, animated: true, completion: nil)
        //show(previewQL, sender: nil) // 7
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = self.downloadsTable.dequeueReusableCell(withIdentifier: "Download Cell") as? DownloadsTableCell {
            
            cell.initCell(items[(indexPath as NSIndexPath).row].name, detail:items[(indexPath as NSIndexPath).row].detail, fileURL: items[(indexPath as NSIndexPath).row].url)
            
            return cell
        }
        
        return DownloadsTableCell()
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        let titleLabel = UILabel()
        let colour = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.6)
        let attributes: [String : AnyObject] = [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: colour, NSKernAttributeName : 3.5 as AnyObject]
        titleLabel.attributedText = NSAttributedString(string: "BYTEPAD", attributes: attributes)
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        items.removeAll()
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("Hello"+String(describing: documentsUrl))
        
        // now lets get the directory contents (including folders)
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl[0], includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions())
            print("HI")
            print(directoryContents)
            
            for  file in directoryContents {
                print(file.lastPathComponent)
                print(file.absoluteURL)
                print(file.baseURL)
                print((file as NSURL).filePathURL)
                let fileName = file.absoluteString
                let fileArray = fileName.components(separatedBy: "_")
                let finalFileName = fileArray[fileArray.count-1]
                
                // Save the data in the list as a tuple
                self.items.append((file.lastPathComponent,"",file.absoluteString))
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        downloadsTable.reloadData()
    }
    
    // MARK: Preview
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return items.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let url:URL = URL(string: items[index].url)!
        print(url)
        return url as QLPreviewItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete", handler: { (action, IndexPath) in
            // Remove item from the array
            
            /*  guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
             let documentDirectoryFileUrl = documentsDirectory.appendingPathComponent(self.items[(indexPath as NSIndexPath).row].url)
             print("bc"+String(describing: documentDirectoryFileUrl))
             // Delete file in document directory
             if FileManager.default.fileExists(atPath: String(describing: documentDirectoryFileUrl)) {
             do {
             try FileManager.default.removeItem(at: documentDirectoryFileUrl)
             print("pc")
             } catch {
             print("Could not delete file: \(error)")
             }
             }*/
            self.removeItemForDocument(itemName: self.items[(indexPath as NSIndexPath).row].name, fileExtension:"."+self.items[(indexPath as NSIndexPath).row].url.characters.split(separator: ".").map(String.init)[1] )
            self.items.remove(at: IndexPath.row)
            
            // Delete the row from the table view
            tableView.deleteRows(at: [IndexPath as IndexPath], with: .fade)
        })
        
       // deleteAction.backgroundColor = Constants.Color.grey
        
        
        return [deleteAction]
    }
    func removeItemForDocument(itemName:String, fileExtension: String) {
        let fileManager = FileManager.default
        let NSDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let NSUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)
        guard let dirPath = paths.first else {
            return
        }
        let filePath = "\(dirPath)/\(itemName)"
        print("mc"+filePath)
        do {
            try fileManager.removeItem(atPath: filePath)
        } catch let error as NSError {
            print(error.debugDescription)
        }}
}

