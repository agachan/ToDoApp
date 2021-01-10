//
//  ListViewController.swift
//  ToDoApp
//
//  Created by AGA TOMOHIRO on 2020/12/08.
//

import UIKit
import Firebase


class ListViewController: UIViewController, CatchProtocol {
    
//    値を初期化
    var statusNum = 0
    let db = Firestore.firestore()
    var tagNum = 0
    var carrierData = [String:Any]()
    var datas = [Data]()
    var datasCAT = [Category]()
    @IBOutlet weak var listTableView: UITableView!
//    ViewDidLoad(画面の値を設定)
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.tableFooterView = UIView(frame: .zero)
        getData()
    }
//    画面遷移先への値をセットする
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "registVC":
            let registVC = segue.destination as! RegistViewController
            registVC.statusNum = statusNum
            registVC.editData = carrierData
            registVC.registDelegate = self
        case "sortVC":
            let sortVC = segue.destination as! SortViewController
            sortVC.sortDelegate = self
        case "menuVC":
            _ = segue.destination as! MenuViewController
        default:
            break
        }
    }
//      並び替えVCに関して値の並び替えを行う（プロトコルより参照）
    func sortViewData(tag: Int) {
            tagNum = arrayData(tag: tag)
    }
//      登録VCに関してデータの取得を行う（プロトコルより参照）
    func registViewData(statusNum: Int) {
        self.statusNum = statusNum
        datas = [Data]()
        // Do any additional setup after loading the view.
        getData()
    }
//    タグの値に関してデータの並び替えを行う
//    並び替えを行うとテーブルを再描画する
    func arrayData(tag:Int) -> Int{
        switch tag {
        case 0:
            datas = datas.sorted(by: {$1.registTime.dateValue() < $0.registTime.dateValue()})
            print("現在の表示は登録順です")
            listTableView.reloadData()
            return tag
        case 1:
            print("現在の表示は重要度順です")
            datas = datas.sorted(by: {$1.importance < $0.importance})
            listTableView.reloadData()
            return tag
        case 2:
            datas = datas.sorted(by: {$1.category > $0.category})
            print("現在の表示はカテゴリー順です")
            listTableView.reloadData()
            return tag
        case 3:
            datas = datas.sorted(by: {$1.limitTime.dateValue() > $0.limitTime.dateValue()})
            print("現在の表示は期限順です")
            listTableView.reloadData()
            return tag
        default :
            break
        }
        return tag
    }
    
//      Firebaseより値の取得を行う
    func getData(){
        self.db.collection("List").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
//                データはdatas[[String:Any]]によって管理される
                for document in querySnapshot!.documents {
                    var datas = document.data()
                    datas["ID"] = document.documentID
                    self.datas.append(Data.init(data: datas))
                }
//                  arrayData(tag:Int) -> Intよりタグによるデータの並び替えを行う
                self.tagNum = self.arrayData(tag: self.tagNum)
                
            }
        }
    }
}

extension ListViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func importanceToStar(importance:Int)->String{
        switch importance {
        case 0:
            return "★"
        case 1:
            return "★★"
        case 2:
            return "★★★"
        case 3:
            return "★★★★"
        case 4:
            return "★★★★★"
        default:
            break
        }
        return "なし"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: "listTableView") as! ListTableViewCell
        cell.contentName.text = datas[indexPath.row].title
        switch tagNum {
        case 0:
            cell.restrictTime.text = registTimeDisplay(date: datas[indexPath.row].registTime.dateValue())
        case 1:
            cell.restrictTime.text = importanceToStar(importance: datas[indexPath.row].importance)
        case 2:
            cell.restrictTime.text = datas[indexPath.row].category
        case 3:
            cell.restrictTime.text = limitTimeDisplay(date: datas[indexPath.row].limitTime.dateValue())
        default :
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        statusNum = 1
        carrierData = Data.dataToStrAny(datas[indexPath.row])()
        listTableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "registVC", sender: nil)
    }
    
}

class ListTableViewCell: UITableViewCell{
    required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)!
      }
    @IBOutlet weak var contentName: UILabel!
    @IBOutlet weak var restrictTime: UILabel!
    
}

class DateUtils {
    class func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }

    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

public func limitTimeDisplay(date: Date) -> String{
    let now = Date()
    let miniut = Date(timeIntervalSinceNow: 60)
    let hour = Date(timeIntervalSinceNow: 60*60)
    let tomorrow: Date = Date(timeIntervalSinceNow: 60*60*24)
    let dif = date.timeIntervalSince(now)
    if now > date{
        return "期限超過"
    }else if now <= date && date < miniut{
        return String(Int(dif)) + "秒後"
    }else if miniut <= date && date < hour{
        return String(Int(dif / 60)) + "分後"
    }else if hour <= date && date < tomorrow{
        return String(Int(dif / (60*60))) + "時間後"
    }else{
        return String(Int(dif / (60*60*24))) + "日後"
    }
}

public func registTimeDisplay(date: Date) -> String{
    let now = Date()
    let miniut = Date(timeIntervalSinceNow: -60)
    let hour = Date(timeIntervalSinceNow: -60*60)
    let yesterday: Date = Date(timeIntervalSinceNow: -60*60*24)
    let dif = now.timeIntervalSince(date)
    if now < date{
        return "期限が過ぎています"
    }else if now >= date && date > miniut{
        return String(Int(dif)) + "秒前"
    }else if miniut >= date && date > hour{
        return String(Int(dif / 60)) + "分前"
    }else if hour >= date && date > yesterday{
        return String(Int(dif / (60*60))) + "時間前"
    }else{
        return String(Int(dif / (60*60*24))) + "日前"
    }
}


