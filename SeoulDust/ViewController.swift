//
//  ViewController.swift
//  SeoulDust
//
//  Created by jmlee on 2021/06/11.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    //MARK:- Property
    @IBOutlet weak var table: UITableView!
    var dustData : DustData?
    //OpenAPI URL
    let urlString = "http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getCtprvnRltmMesureDnsty?serviceKey=N6Zr7npJRiZbuek%2FYe7J%2BiOkwlqIgzllNtMGqALWCMuo%2Fvc4CX6cwxabU35B5tUVbKeCCOOaATpzike88zPk%2FA%3D%3D&returnType=json&numOfRows=100&pageNo=1&sidoName=%EC%84%9C%EC%9A%B8&ver=4.0"
    
    //MARK:- Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        getData()
    }
    
    func getData() {
        AF.request(urlString).responseJSON { response in
            switch response.result {
            case .success(let res):
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: res, options: .prettyPrinted)
                    let json = try JSONDecoder().decode(DustData.self, from: jsonData)
                    self.dustData = json
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                }
                catch(let err) {
                    print(err)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? DetailViewController else { return }
        let myIndexPath = table.indexPathForSelectedRow!
        let row = myIndexPath.row
        dest.staionName = (dustData?.response.body.items[row].stationName)!
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = dustData?.response.body.items.count else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell
        
        //지역 레이블
        cell.stationName.text = dustData?.response.body.items[indexPath.row].stationName
        
        //미세먼지 지수 레이블
        if let pm10Grade = dustData?.response.body.items[indexPath.row].pm10Grade {
            cell.pm10Value.backgroundColor = changeColor(pm10Grade)
            cell.pm10Value.text = "미세먼지: " + (pm10Grade) + "㎍/m³"
        }
        else {
            cell.pm10Value.backgroundColor = UIColor.lightGray
            cell.pm10Value.text = "측정 값 없음"
        }
        
        //통합대기등급 레이블
        if let khaiGrade = dustData?.response.body.items[indexPath.row].khaiGrade {
            cell.khaiGrade.backgroundColor = changeColor(khaiGrade)
            cell.khaiGrade.text = "통합대기등급: \(khaiGrade)등급"
        }
        else {
            cell.khaiGrade.backgroundColor = UIColor.lightGray
            cell.khaiGrade.text = "측정 값 없음"
        }
        
        return cell
    }
    
    //헤더 부분
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "서울시 지역별 미세먼지"
    }
    
    //레이블 컬러 변경
    func changeColor(_ key: String) -> UIColor {
        let numF = NumberFormatter()
        numF.numberStyle = .decimal
        let keyInt = Int(key)!
        switch keyInt {
        case 1:
            return UIColor.systemBlue
        case 2:
            return UIColor.systemGreen
        case 3:
            return UIColor.systemYellow
        case 4:
            return UIColor.systemRed
        default:
            break
        }
        return UIColor.white
    }
    
}
