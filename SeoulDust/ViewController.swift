//
//  ViewController.swift
//  SeoulDust
//
//  Created by jmlee on 2021/06/11.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:- Property
    @IBOutlet weak var table: UITableView!
    var dustData : DustData?
    //OpenAPI URL
    let dustURL = "http://apis.data.go.kr/B552584/ArpltnInforInqireSvc/getCtprvnRltmMesureDnsty?serviceKey=N6Zr7npJRiZbuek%2FYe7J%2BiOkwlqIgzllNtMGqALWCMuo%2Fvc4CX6cwxabU35B5tUVbKeCCOOaATpzike88zPk%2FA%3D%3D&returnType=json&numOfRows=100&pageNo=1&sidoName=%EC%84%9C%EC%9A%B8&ver=4.0"
    
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
                guard error == nil else { return }
                if let JSONdata = data {
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
            switch pm10GradeNumber {
                case 1:
                    cell.pm10Value.backgroundColor = UIColor.systemBlue
                case 2:
                    cell.pm10Value.backgroundColor = UIColor.systemGreen
                case 3:
                    cell.pm10Value.backgroundColor = UIColor.systemYellow
                case 4:
                    cell.pm10Value.backgroundColor = UIColor.systemRed
                default:
                    break
            }
        }
        //통합대기등급 레이블
        if let khaiGrade = dustData?.response.body.items[indexPath.row].khaiGrade {
            let numF = NumberFormatter()
            numF.numberStyle = .decimal
            let khaiGradeNumber = Int(khaiGrade)!
            switch khaiGradeNumber {
                case 1:
                    cell.khaiGrade.backgroundColor = UIColor.systemBlue
                case 2:
                    cell.khaiGrade.backgroundColor = UIColor.systemGreen
                case 3:
                    cell.khaiGrade.backgroundColor = UIColor.systemYellow
                case 4:
                    cell.khaiGrade.backgroundColor = UIColor.systemRed
                default:
                    cell.khaiGrade.text = "통합대기등급: \(khaiGradeNumber)등급"
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
