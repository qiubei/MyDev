//
//  ReportTableViewController.swift
//  InnerpeaceSDK-Example
//
//  Created by Anonymous on 2018/8/14.
//  Copyright © 2018年 EnterTech. All rights reserved.
//

import UIKit
import BLESDK_Microphone

class ReportTableViewController: UITableViewController {

    private var reportList: NSArray {
        return IPFileManager.shared.readReport() ?? NSArray()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "report_id", for: indexPath)

        let dic = self.reportList[indexPath.row] as? NSDictionary
        if let d = dic {
            let result = Sleep.SleepFinishResult.objectForDic(dic: d)
            cell.textLabel?.text = "\(result)"
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = d["name"] as! String
        }
        return cell
    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }

}
