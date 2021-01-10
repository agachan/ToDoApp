//
//  MenuViewController.swift
//  ToDoApp
//
//  Created by AGA TOMOHIRO on 2020/12/15.
//

import UIKit
import Firebase

class MenuViewController: UIViewController, ProfileProtocol{
    func getImageName(name: String, image: UIImage) {
        self.imageView.contentMode = UIView.ContentMode.scaleAspectFill
        self.nameLabel.text = name
        self.imageView.image = image
    }
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var menuTable: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    let storage = Storage.storage()
    let db = Firestore.firestore()
    var job = ""
    var birthday = Date()
    var data = [String:Any]()
    let menu = ["Profile","Category","Location"]
    var images:[UIImage] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        menuTable.tableFooterView = UIView(frame: .zero)
        let menuPos = self.menuView.layer.position
        // 初期位置を画面の外側にするため、メニューの幅の分だけマイナスする
        self.menuView.layer.position.x = -self.menuView.frame.width
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.menuView.layer.position.x = menuPos.x
        },
            completion: { bool in
        })

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "profileVC":
            print("profileVC")
            let VC = segue.destination as! ProfileViewController
            VC.image = imageView.image ?? UIImage()
            VC.name = nameLabel.text ?? ""
            VC.birthday = birthday
            VC.job = job
            VC.delegate = self
        case "categorySettingVC":
            print("categorySettingVC")
        case "locationVC":
            print("locationVC")
        default:
            break
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
                        self.menuView.layer.position.x = -self.menuView.frame.width
                },
                    completion: { bool in
                        self.dismiss(animated: true, completion: nil)
                }
                )
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let docRef = db.collection("PROFILE").document("DATA")
        docRef.getDocument() { (document, error) in
          if let document = document {
            self.data = document.data() ?? [String:Any]()
            self.nameLabel.text = self.data["NAME"] as? String
            self.job = self.data["JOB"] as? String ?? ""
            let timeStampBirthday = self.data["BIRTHDAY"] as? Timestamp
            self.birthday = timeStampBirthday?.dateValue() ?? Date()
            print("Cached document data: \(self.data)")
            print(self.birthday)
          } else {
            print("Document does not exist in cache")
          }
        }
        let reference = storage.reference(forURL: "gs://todoapp-fb9db.appspot.com/ProfileImage.jpg")
        reference.getData(maxSize:9578341) { data, error in
            if let error = error {
                print(error)
          } else {
            // Data for "images/island.jpg" is returned
            self.imageView.image = UIImage(data: data!)
            self.imageView.contentMode = UIView.ContentMode.scaleAspectFill
          }
        }
        

        menuTable.delegate = self
        menuTable.dataSource = self
        images = [getDefaltImages(str: "person"),getDefaltImages(str: "paintpalette"),getDefaltImages(str: "location")]
        // Do any additional setup after loading the view.
    }
    
    func getDefaltImages(str: String) -> UIImage{
        return UIImage(systemName: str) ?? UIImage()
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTable.dequeueReusableCell(withIdentifier: "Color") as! MenuTableViewControllerCell
        cell.menuLabel.text = menu[indexPath.row]
        cell.menuImage.image = images[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        menuTable.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0{
            performSegue(withIdentifier: "profileVC", sender: nil)
        }else if indexPath.row == 1{
            performSegue(withIdentifier: "categorySettingVC", sender: nil)
        }else{
            performSegue(withIdentifier: "locationVC", sender: nil)
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80
        }
    
}

class MenuTableViewControllerCell: UITableViewCell{
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)!
      }
}
