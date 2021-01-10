//
//  CategorySettingViewController.swift
//  ToDoApp
//
//  Created by AGA TOMOHIRO on 2020/12/18.
//

import UIKit
import Firebase

class CategorySettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CategorySettingProtocol {
    func getCagegoryData(text: String,index:Int) {
        datas[index].name = text
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(datas)
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: "CATCell") as! CatrgorySettingTableViewCell
        cell.colorView.backgroundColor = dataToView(color: datas[indexPath.row].rgb)
        cell.textFileld.text = datas[indexPath.row].name
        cell.index = indexPath.row
        cell.categoryDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 70
        }
    
    
    
    let db = Firestore.firestore()
    var datas = [Category]()
    @IBOutlet weak var categoryTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.tableFooterView = UIView(frame: .zero)
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
                self.categoryTableView.reloadData()
            }
        }
        
    }
    
@IBOutlet weak var categorySettingView: UIView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let menuPos = self.categorySettingView.layer.position
        // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
        self.categorySettingView.layer.position.x = -self.categorySettingView.frame.width
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.categorySettingView.layer.position.x = menuPos.x
        },
            completion: { bool in
        })
        
    }
    
    func saveData(str:String,index:Int){
        db.collection("Category").document(str).updateData([
            "NAME": datas[index].name
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        print(datas)
        saveData(str: "RED", index: 0)
        saveData(str: "GREEN", index: 1)
        saveData(str: "BLUE", index: 2)
        saveData(str: "YELLOW", index: 3)
        saveData(str: "PURPLE", index: 4)
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.categorySettingView.layer.position.x = -self.categorySettingView.frame.width
            },
            completion: { bool in
                self.dismiss(animated: true, completion: nil)
            }
        )
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag == 1 {
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: .curveEaseIn,
                    animations: {
                        self.categorySettingView.layer.position.x = -self.categorySettingView.frame.width
                },
                    completion: { bool in
                        self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    
}

class CatrgorySettingTableViewCell: UITableViewCell, UITextFieldDelegate {
    var categoryDelegate:CategorySettingProtocol?
    var index = 0
    @IBOutlet weak var textFileld: UITextField!{
        didSet{
            textFileld.delegate = self
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    @IBAction func textField(_ sender: UITextField) {
        categoryDelegate?.getCagegoryData(text: textFileld.text ?? "",index: index)
    }
    @IBOutlet weak var colorView: UIView!
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

public func dataToView(color:[Int]) -> UIColor{
    let r = color[0]
    let g = color[1]
    let b = color[2]
    return UIColor.lightrgb(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b))
}
