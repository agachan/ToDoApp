//
//  ColorViewController.swift
//  ToDoApp
//
//  Created by AGA TOMOHIRO on 2020/12/11.
//

import UIKit
import Firebase


class ColorViewController: UIViewController{
    var redNum = 0
    var greenNum = 0
    var blueNum = 0
    var categoryName = ""
    let db = Firestore.firestore()
    var colorData = [[String:Any]()]
    enum SliderType: Int{
        case red = 0
        case green = 1
        case blue = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorTableView.delegate = self
        colorTableView.dataSource = self
        
        self.db.collection("color").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.colorData.append(document.data())
                    
                }
                self.colorTableView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        categoryName = categoryText.text ?? ""
        self.view.endEditing(true)
    }
    
    @IBOutlet weak var redColorSlider: UISlider!
    @IBOutlet weak var greenColorSlider: UISlider!
    @IBOutlet weak var blueColorSlider: UISlider!
    @IBOutlet weak var colorTableView: UITableView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var categoryText: UITextField!{
        didSet{
            categoryText.delegate = self
        }
    }
    @IBAction func colorSlider(_ sender: UISlider) {
        switch sender.tag {
        case SliderType.red.rawValue:
            redNum = Int(sender.value)
        case SliderType.green.rawValue:
            greenNum = Int(sender.value)
        case SliderType.blue.rawValue:
            blueNum = Int(sender.value)
        default:
            break
        }
        colorView.backgroundColor = .rgb(r: CGFloat(redNum), g: CGFloat(greenNum), b: CGFloat(blueNum))
    }
    
    @IBAction func registButton(_ sender: Any) {
        if categoryName == ""{
            let alert: UIAlertController = UIAlertController(title: "エラー", message: "カテゴリー名を入力してください", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                print("OK")
                
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }else{
            print(redNum,greenNum,blueNum,categoryName + "が登録されます")
            let alert: UIAlertController = UIAlertController(title: "色とカテゴリー名を登録してください", message: "保存してもいいですか？", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                print("OK")
                //                データの受け渡し
                var ref: DocumentReference? = nil
                ref = self.db.collection("color").addDocument(data: [
                    "R": self.redNum,
                    "G": self.greenNum,
                    "B": self.blueNum,
                    "CategoryName": self.categoryName
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                        
                    }
                }
                //                画面の初期化処理
                self.redNum = 0
                self.greenNum = 0
                self.blueNum = 0
                self.categoryName = ""
                self.categoryText.text = ""
                self.redColorSlider.value = 0.0
                self.greenColorSlider.value = 0.0
                self.blueColorSlider.value = 0.0
                self.colorView.backgroundColor = .rgb(r: CGFloat(self.redNum), g: CGFloat(self.greenNum), b: CGFloat(self.blueNum))
                
//                データを初期化してからダウンロードする
                self.colorData = [[:]]
                self.db.collection("color").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            self.colorData.append(document.data())
                            print(self.colorData)
                        }
                        self.colorTableView.reloadData()
                    }
                }
            })
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                print("Cancel")
            })
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
            
        }

    }
    
    func getColorData() -> [[String:Any]]{
        var data = [[:]]
        self.db.collection("color").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.colorData.append(document.data())
                    print(self.colorData)
                }
                self.colorTableView.reloadData()
            }
        }
        return colorData
    }
    
}

//TextFieldを閉じる画面
extension ColorViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        categoryName = textField.text ?? ""
        return true
    }
}

extension ColorViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("ColorData:" + String(colorData.count))
        print(colorData)
        return colorData.count-1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = colorTableView.dequeueReusableCell(withIdentifier: "ColorTableView") as! ColorTableViewCell
        cell.categoryName.text = colorData[indexPath.row+1]["CategoryName"] as? String
        cell.colorView.backgroundColor = .rgb(r: colorData[indexPath.row+1]["R"] as? CGFloat ?? 0, g: colorData[indexPath.row+1]["G"] as? CGFloat ?? 0, b: colorData[indexPath.row+1]["B"] as? CGFloat ?? 0)
        return cell
        
    }
    
    
}

class ColorTableViewCell: UITableViewCell{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var colorView: UIView!
    
}


extension UIColor{
    static func rgb(r:CGFloat,g:CGFloat,b:CGFloat) -> UIColor{
        return self.init(red: r/255, green: g/255, blue: b/255, alpha: 1.0)
    }
}
