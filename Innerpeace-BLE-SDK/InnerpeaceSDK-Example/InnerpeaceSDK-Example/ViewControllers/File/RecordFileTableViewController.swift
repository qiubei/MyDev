//
//  RecordFileTableViewController.swift
//  InnerpeaceSDK-Example
//
//  Created by Anonymous on 2018/8/14.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import UIKit
import Files
import SVProgressHUD

class RecordFileTableViewController: UITableViewController {

    private var _files = [URL]()

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            _files = try Folder(path: IPFileManager.shared.audioPath).files.map {URL(fileURLWithPath: $0.path)}
        } catch {
            SVProgressHUD.showInfo(withStatus: "找不到录音文件")
            print("read file failed: \(error)")
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _files.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "record_file_id", for: indexPath)
        cell.textLabel?.text = _files[indexPath.row].lastPathComponent
        if let fileSize = try? FileManager.default.attributesOfItem(atPath: _files[indexPath.row].path)[FileAttributeKey.size] as? UInt, let size = fileSize {
            cell.detailTextLabel?.text = "size: " + String(size/22100) + "s"
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = _files[indexPath.row]
        let activity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        self.present(activity, animated: true, completion: nil)

        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let url = _files[indexPath.row]
            try? FileManager.default.removeItem(at: url)
            _files.remove(at: indexPath.row)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
}
