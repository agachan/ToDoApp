//
//  RegistViewController.swift
//  ToDoApp
//
//  Created by AGA TOMOHIRO on 2020/12/11.
//

import UIKit
import Firebase

class RegistViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, CategoryProtocol {

    var statusNum = 0
    var registDelegate:CatchProtocol?
    var importanceNum = 0
    var catID = 0
    let categoryVC = "categoryVC"
    let forImage = UIImage(systemName: "star.fill") ?? UIImage()
    let preImage = UIImage(systemName: "star") ?? UIImage()
    var editData = [String:Any]()
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var memoTextView: PlaceHolderTextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch statusNum {
        case 0:
            removeButton.isEnabled = false
            removeButton.alpha = 0
            titleTextField.text = ""
            urlTextField.text = ""
            datePicker.date = Date()
            importanceNum = 0
            catID = 0
            categoryButton.setTitle("なし", for: .normal)
            memoTextView.text = ""
        case 1:
            removeButton.isEnabled = true
            removeButton.alpha = 1
            let timeLimit = editData["LimitTime"] as! Timestamp
            datePicker.setDate(timeLimit.dateValue(), animated: true)
            titleTextField.text = editData["Title"] as? String
            urlTextField.text = editData["URL"] as? String
            categoryButton.setTitle(editData["Category"] as? String, for: .normal)
            catID = editData["CatID"] as? Int ?? 0
            memoTextView.text = editData["Memo"] as? String
            tagToImage(tag: editData["Importance"] as? Int ?? 0)
        default: break
        }

        titleTextField.delegate = self
        urlTextField.delegate = self
        memoTextView.delegate = self
    }
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var forthButton: UIButton!
    @IBOutlet weak var fifthButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    
    
    @IBAction func importanceButton(_ sender: UIButton) {
        tagToImage(tag: sender.tag)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == categoryVC{
            let categoryVC = segue.destination as! CategoryViewController
            categoryVC.categoryDelegate = self
        }
    }
    func getCagegoryData(text: String,index:Int) {
        categoryButton.setTitle(text, for: .normal)
        catID = index
    }
    @IBAction func categoryButton(_ sender: Any) {
        performSegue(withIdentifier: categoryVC, sender: nil)
    }
    
    func tagToImage(tag:Int){
        switch tag {
        
        case 0:
            importanceNum = tag
            setImage(first: forImage , second: preImage, third: preImage, forth: preImage, fifth: preImage)
        case 1:
            importanceNum = tag
            setImage(first: forImage , second: forImage, third: preImage, forth: preImage, fifth: preImage)
        case 2:
            importanceNum = tag
            setImage(first: forImage , second: forImage, third: forImage, forth: preImage, fifth: preImage)
        case 3:
            importanceNum = tag
            setImage(first: forImage , second: forImage, third: forImage, forth: forImage, fifth: preImage)
        case 4:
            importanceNum = tag
            setImage(first: forImage , second: forImage, third: forImage, forth: forImage, fifth: forImage)
        default:
            break
        }
    }
    
    func setImage(first:UIImage,second:UIImage,third:UIImage,forth:UIImage,fifth:UIImage){
        firstButton.setBackgroundImage(first, for: .normal)
        secondButton.setBackgroundImage(second, for: .normal)
        thirdButton.setBackgroundImage(third, for: .normal)
        forthButton.setBackgroundImage(forth, for: .normal)
        fifthButton.setBackgroundImage(fifth, for: .normal)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if (self.memoTextView.isFirstResponder) {
                self.memoTextView.resignFirstResponder()
            }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    let db = Firestore.firestore()
    @IBAction func registButton(_ sender: Any) {
        if self.titleTextField.text == ""{
            alart(VC: self, str: "タイトルは必須です")
        }else{
            switch statusNum {
            case 0:
                var ref: DocumentReference? = nil
                ref = self.db.collection("List").addDocument(data: [
                    "Title": titleTextField.text ?? "",
                    "URL":urlTextField.text ?? "",
                    "LimitTime": self.datePicker.date,
                    "Importance":self.importanceNum,
                    "Category":self.categoryButton.titleLabel?.text ?? "なし",
                    "CatID":self.catID,
                    "Memo":self.memoTextView.text ?? "",
                    "RegistTime":Date()
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                        
                    }
                    self.registDelegate?.registViewData(statusNum: 0)
                    self.dismiss(animated: true, completion: nil)
                }
            case 1:
                db.collection("List").document(editData["ID"] as! String).updateData([
                    "Title": titleTextField.text ?? "",
                    "URL":urlTextField.text ?? "",
                    "LimitTime": self.datePicker.date,
                    "Importance":self.importanceNum,
                    "Category":self.categoryButton.titleLabel?.text ?? "なし",
                    "CatID":self.catID,
                    "Memo":self.memoTextView.text ?? "",
                    "RegistTime":Date()
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                    self.registDelegate?.registViewData(statusNum: 0)
                    self.dismiss(animated: true, completion: nil)
                }
            default:
                alart(VC: self, str: "想定外のエラーが発生しました")
                break
            
        }
    }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        registDelegate?.registViewData(statusNum: 0)
    }
    
    @IBAction func urlButton(_ sender: Any) {
        let url = NSURL(string: urlTextField.text ?? "")
        if UIApplication.shared.canOpenURL(url! as URL){
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
    
    
    @IBOutlet weak var removeButton: UIButton!
    @IBAction func removeButton(_ sender: Any) {
        db.collection("List").document(editData["ID"] as! String).delete(){ err in
            if let err = err {
                print("Error removing document: \(err)")
                alart(VC: self, str: "削除時に問題が発生しました")
            } else {
                print("Document successfully removed!")
            }
        }
        registDelegate?.registViewData(statusNum: 0)
        dismiss(animated: true, completion: nil)
    }
}

public func alart(VC:UIViewController ,str:String){
    let alert: UIAlertController = UIAlertController(title: "エラー", message: str, preferredStyle:  UIAlertController.Style.alert)
    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
        (action: UIAlertAction!) -> Void in
        print("OK")
        
    })
    alert.addAction(defaultAction)
    VC.present(alert, animated: true, completion: nil)
}
