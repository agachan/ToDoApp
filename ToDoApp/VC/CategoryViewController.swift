//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by AGA TOMOHIRO on 2020/12/18.
//

import UIKit
import Firebase

class CategoryViewController: UIViewController {
    var categoryDelegate:CategoryProtocol?
    let db = Firestore.firestore()
    var datas = [Category]()
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryView.layer.cornerRadius = 20
        categoryTable.delegate = self
        categoryTable.dataSource = self
        categoryTable.tableFooterView = UIView(frame: .zero)
        getData()
    }
    func getData(){
        self.db.collection("Category").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
//                データはdatas[[String:Any]]によって管理される
                for document in querySnapshot!.documents {
                    var datas = document.data()
                    datas["ID"] = document.documentID
                    self.datas.append(Category.init(data: datas))
                }
                self.datas = self.datas.sorted(by: {$1.tag > $0.tag})
                self.categoryTable.reloadData()
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag == 1 {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}

extension CategoryViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTable.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryTableViewCell
        cell.categoryLabel.text = datas[indexPath.row].name
        cell.colorView.backgroundColor = dataToView(color: datas[indexPath.row].rgb)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryDelegate?.getCagegoryData(text: datas[indexPath.row].name,index:datas[indexPath.row].tag)
        dismiss(animated: true, completion: nil)
    }
    
    
}

class CategoryTableViewCell: UITableViewCell{
    
    required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)!
      }
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    
}

extension UIColor{
    static func lightrgb(r:CGFloat,g:CGFloat,b:CGFloat) -> UIColor{
        return self.init(red: r/255, green: g/255, blue: b/255, alpha: 0.8)
    }
}

public func textToViewColor(text:String) -> UIView{
    let view = UIView()
    switch text {
    case "Red":
        view.backgroundColor = RED
    case "Green":
        view.backgroundColor = GREEN
    case "Blue":
        view.backgroundColor = BLUE
    case "Yellow":
        view.backgroundColor = YELLOW
    case "Purple":
        view.backgroundColor = PURPLE
    default:
        break
    }
    return view
}

public let RED = UIColor.lightrgb(r: 220, g: 12, b: 51)
public let GREEN = UIColor.lightrgb(r: 160, g: 212, b: 104)
public let BLUE = UIColor.lightrgb(r: 172, g: 220, b: 227)
public let YELLOW = UIColor.lightrgb(r: 246, g: 250, b: 150)
public let PURPLE = UIColor.lightrgb(r: 176, g: 86, b: 236)
