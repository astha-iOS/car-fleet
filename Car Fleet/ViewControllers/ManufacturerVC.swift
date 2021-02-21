//
//  ManufacturerVC.swift
//  Car Fleet
//
//  Created by Astha yadav on 23/01/21.
//

import UIKit
import os
class ManufacturerVC: UIViewController,ServicesDelegate {

    @IBOutlet weak var manufacturerTableView: UITableView!
    
    let restClient = RestClient.shared()
    var pageNo = Int()
    var totalPageNo = Int()
    var sortedCarManufacturer = [CarManufacturer]()
    
    
        
    //MARK:- view did load
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        manufacturerTableView.tableFooterView = UIView()
        manufacturerTableView.estimatedRowHeight = 44.0
        manufacturerTableView.rowHeight = UITableView.automaticDimension
        manufacturerTableView.accessibilityIdentifier = "tbl"
        pageNo = 0
        self.showSpinner(onView: self.view)
        restClient.getManufacturerList(pageNo: pageNo, pageSize: AppConstants.PAGE_SIZE, delegate: self)
        
    }
    
    
    //MARK:- success
    func success(result: Any, withID: String) {
        if withID == "manufacturer"{
            self.removeSpinner()
            let resultDict = result as! [String : Any]
            totalPageNo = resultDict["totalPageCount"] as? Int ?? 0
            let manufacturersDict : [String: String] = resultDict["wkda"] as! Dictionary<String, String>
            var carManufacturer = [CarManufacturer]()
            for (key, value) in manufacturersDict {
                carManufacturer.append(CarManufacturer(id:key, title: value))
            }
            

            self.sortedCarManufacturer.append(contentsOf: sortManufacturer(carManufacturer))
            DispatchQueue.main.async {
                self.manufacturerTableView.reloadData()
            }
        }
    }
    
    //MARK:- api error
    func error(result: Any, withID: String) {
        if withID == "manufacturer"{
            self.removeSpinner()
            self.showToast(message: result as? String ?? "Something went wrong,Please try again later.")
        }
    }
    
    //MARK:- sortManufacturer
    func sortManufacturer(_ carManufacturer: [CarManufacturer]) -> [CarManufacturer] {
        return carManufacturer.sorted { (item1, item2) -> Bool in
            item1.id<item2.id
        }
    }
}

//MARK:- UITableViewDelegate , UITableViewDataSource
extension ManufacturerVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sortedCarManufacturer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManufacturerTableCell", for: indexPath) as! ManufacturerTableCell
        
        if (indexPath.row % 2) != 0{
            cell.backgroundColor = #colorLiteral(red: 0.9535087943, green: 0.4413236976, blue: 0.1285568178, alpha: 0.3537081866)
        }else{
            cell.backgroundColor = #colorLiteral(red: 0.5615147352, green: 0.8315619826, blue: 0.9627962708, alpha: 0.497496699)
        }
        
        let manufactrer = self.sortedCarManufacturer[indexPath.row]
        cell.labelManufacturer.text = manufactrer.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (self.sortedCarManufacturer.count-2) == indexPath.row && totalPageNo > pageNo{
            pageNo = pageNo + 1
            restClient.getManufacturerList(pageNo: pageNo, pageSize: AppConstants.PAGE_SIZE, delegate: self)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CarModelVC") as? CarModelVC {
            if let navigator = navigationController {
                let manufactrer = self.sortedCarManufacturer[indexPath.row]
                vc.manufactrer = manufactrer
                navigator.pushViewController(vc, animated: true)
            }
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
   
}


