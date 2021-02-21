//
//  CarModelVC.swift
//  Car Fleet
//
//  Created by Astha yadav on 23/01/21.
//

import UIKit
import os
class CarModelVC: UIViewController,ServicesDelegate {
    
    @IBOutlet weak var modelTableView: UITableView!
    
    var pageNo = Int()
    var totalPageNo = Int()
    var sortedCarModel = [CarModel]()
    
    let restClient = RestClient.shared()
    
    var manufactrer:CarManufacturer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Model"
        modelTableView.tableFooterView = UIView()
        modelTableView.tableFooterView = UIView()
        modelTableView.estimatedRowHeight = 44.0
        modelTableView.rowHeight = UITableView.automaticDimension
        modelTableView.accessibilityIdentifier = "table--modelTV"

         
        
        pageNo = 0
        self.showSpinner(onView: self.view)
        restClient.getModelList(pageNo: pageNo, pageSize: AppConstants.PAGE_SIZE, manufacturer: manufactrer.id, delegate: self)
    }
    
    
    //MARK:- success
    func success(result: Any, withID: String) {
        if withID == "carModel"{
            self.removeSpinner()
            let resultDict = result as! [String : Any]
            totalPageNo = resultDict["totalPageCount"] as? Int ?? 0
            let modelDict : [String: String] = resultDict["wkda"] as! Dictionary<String, String>
            var carModel = [CarModel]()
            for (key, value) in modelDict {
                carModel.append(CarModel(id:key, title: value))
            }
            
            self.sortedCarModel.append(contentsOf:sortModel(carModel))
            DispatchQueue.main.async {
                self.modelTableView.reloadData()
            }
        }
    }
    
    //MARK:- api error
    func error(result: Any, withID: String) {
        if withID == "carModel"{
            self.removeSpinner()
            os_log("Got error while fatching data %@ ", log: .default, type: .error, result as! CVarArg)
            self.showToast(message: result as? String ?? "Something went wrong,Please try again later.")
        }
    }
    
    //MARK:- sortModel
     func sortModel(_ carModel: [CarModel]) -> [CarModel] {
        return carModel.sorted { (item1, item2) -> Bool in
            item1.id<item2.id
        }
    }
}

//MARK:- UITableViewDelegate , UITableViewDataSource
extension CarModelVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sortedCarModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarModelTableViewCell", for: indexPath) as! CarModelTableViewCell
        
        if (indexPath.row % 2) != 0{
            cell.backgroundColor = #colorLiteral(red: 0.8947182298, green: 0.8658382297, blue: 0, alpha: 0.3537081866)
        }else{
            cell.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 0.5)
        }

        let model = self.sortedCarModel[indexPath.row]
        cell.labelModel.text = model.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (self.sortedCarModel.count-2) == indexPath.row && totalPageNo > pageNo{
            pageNo = pageNo + 1
            restClient.getModelList(pageNo: pageNo, pageSize: AppConstants.PAGE_SIZE, manufacturer: manufactrer.id, delegate: self)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.sortedCarModel[indexPath.row]
        let message = String(format: "%@, %@", manufactrer.title,model.title)
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: UIAlertController.Style.alert)

    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

    self.present(alert, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
}
