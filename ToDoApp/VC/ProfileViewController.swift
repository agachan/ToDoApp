//
//  ProfileViewController.swift
//  ToDoApp
//
//  Created by AGA TOMOHIRO on 2020/12/25.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate{
    let storage = Storage.storage()
    let db = Firestore.firestore()
    var delegate: ProfileProtocol?
    var name = ""
    var job = ""
    var birthday = Date()
    var image = UIImage()
    @IBOutlet weak var profileImage: CircleImge!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var profileView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.contentMode = UIView.ContentMode.scaleAspectFill
        nameTextField.text = name
        profileImage.image = image
        jobTextField.text = job
        birthdayPicker.setDate(birthday, animated: true)
        nameTextField.delegate = self
        jobTextField.delegate = self
        print(birthday)
    }
    @IBAction func saveButton(_ sender: Any) {
        if nameTextField.text == ""{
            alart(VC: self, str: "名前と写真は必須です")
        }else{
            guard let image = profileImage.image else {return}
            delegate?.getImageName(name: nameTextField.text ?? "", image: image)
            let storageRef = storage.reference(forURL: "gs://todoapp-fb9db.appspot.com")
            let imageRef = storageRef.child("ProfileImage.jpg")
            guard let imageData = image.jpegData(compressionQuality: 1.0) else {return}
            imageRef.putData(imageData, metadata: nil){ metadata, error in
                if (error != nil) {
                    print("Uh-oh, an error occurred!")
                } else {
                    print("downloadURL:" )
                }
                imageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {return}
                    print(downloadURL)
                   
            }
                self.db.collection("PROFILE").document("DATA").updateData([
                    "NAME": self.nameTextField.text ?? "",
                    "JOB": self.jobTextField.text ?? "",
                    "BIRTHDAY": self.birthdayPicker.date
                ]){ err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID")
                    }
                }
            }
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: .curveEaseIn,
                animations: {
                    self.profileView.layer.position.x = -self.profileView.frame.width
                },
                completion: { bool in
                    self.dismiss(animated: true, completion: nil)
                }
            )
        }
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
                        self.profileView.layer.position.x = -self.profileView.frame.width
                },
                    completion: { bool in
                        self.dismiss(animated: true, completion: nil)
                }
                )
            }
        }
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "プロフィール画像", message: "カメラか写真フォルダを選択して下さい", preferredStyle:  UIAlertController.Style.actionSheet)
        // Defaultボタン
        let defaultAction_1: UIAlertAction = UIAlertAction(title: "カメラ", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in

            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            // UIImagePickerController カメラを起動する
            self.present(picker, animated: true, completion: nil)
        })
        let defaultAction_2: UIAlertAction = UIAlertAction(title: "写真フォルダ", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        })

        // Cancelボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "cancel", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("cancelAction")
        })
        alert.addAction(defaultAction_1)
        alert.addAction(defaultAction_2)
        alert.addAction(cancelAction)
            // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let menuPos = self.profileView.layer.position
        // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
        self.profileView.layer.position.x = -self.profileView.frame.width
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.profileView.layer.position.x = menuPos.x
        },
            completion: { bool in
        })
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        profileImage.image = image
        profileImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
