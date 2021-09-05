//
//  ViewController.swift
//  dustLjm
//
//  Created by 이정민 on 2021/06/11.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:- Property
    @IBOutlet weak var table: UITableView!
    var dustData : DustData?
    //OpenAPI URL
    let dustURL = "http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getCtprvnRltmMesureDnsty?serviceKey=332rIZusSZjb7HpmfHwrUm2miwcsR6uCmQCgCFEkC3ZDK5oglPDb%2BVv7inASnNxE7c4v3qZN3WRwXagfbGJkLA%3D%3D&returnType=json&numOfRows=100&pageNo=1&sidoName=서울&ver=1.0"
    
    //MARK:- Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        getData()
    }
    
    func getData() {
        if let url = URL(string: dustURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                guard let JSONdata = data else {return}
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(DustData.self, from: JSONdata)
                    self.dustData = decodedData
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                }
                catch {
                    print(error)
                }
            }
            task.resume()
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
        cell.stationName.text   = dustData?.response.body.items[indexPath.row].stationName
        cell.pm10Value.text     = "미세먼지: " + (dustData?.response.body.items[indexPath.row].pm10Value)! + "㎍/m³"
        //미세먼지 지수 레이블 컬러
        if let pm10Grade = dustData?.response.body.items[indexPath.row].pm10Grade {
            let numF = NumberFormatter()
            numF.numberStyle = .decimal
            let pm10GradeNumber = Int(pm10Grade)!
            if pm10GradeNumber == 1 {
                cell.pm10Value.backgroundColor = UIColor.systemBlue
            }
            else if pm10GradeNumber == 2 {
                cell.pm10Value.backgroundColor = UIColor.systemGreen
            }
            else if pm10GradeNumber == 3 {
                cell.pm10Value.backgroundColor = UIColor.systemYellow
            }
            else if pm10GradeNumber == 4 {
                cell.pm10Value.backgroundColor = UIColor.systemRed
            }
        }
        //통합대기등급 레이블 컬러
        if let khaiGrade = dustData?.response.body.items[indexPath.row].khaiGrade {
            let numF = NumberFormatter()
            numF.numberStyle = .decimal
            let khaiGradeNumber = Int(khaiGrade)!
            if khaiGradeNumber == 1 {
                cell.khaiGrade.backgroundColor = UIColor.systemBlue
            }
            else if khaiGradeNumber == 2 {
                cell.khaiGrade.backgroundColor = UIColor.systemGreen
            }
            else if khaiGradeNumber == 3 {
                cell.khaiGrade.backgroundColor = UIColor.systemYellow
            }
            else if khaiGradeNumber == 4 {
                cell.khaiGrade.backgroundColor = UIColor.systemRed
            }
            cell.khaiGrade.text = "통합대기등급: \(khaiGradeNumber)등급"
        }
        return cell
    }
    
    //헤더 부분
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "서울시 지역별 미세먼지"
    }
    
}
