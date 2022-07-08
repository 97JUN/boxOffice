//
//  ViewController.swift
//  boxOffice
//
//  Created by 쭌이 on 2022/07/05.
//

import UIKit


struct MovieData : Codable {
    let boxOfficeResult : BoxOfficeResult //구조체의 변수이름(프로퍼티)들은 JSON 과 일치해야 한다. 유형들은 그냥 정해져도 됨
}
struct BoxOfficeResult : Codable {
    let dailyBoxOfficeList : [DailyBoxOfficeList]
}
struct DailyBoxOfficeList : Codable {
    let movieNm : String
    let audiCnt : String
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    
    let movieURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=298a0ec296e8096e6d71d4d05b016b7d&targetDt=20220707"
    
    var movieData : MovieData? //이니셜라이저도 없어서 옵셔널형으로 해준것이다. (초기값이 뭔지 모르기때문에)
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        getData()
        
    }
    
    func getData() {
        if let url = URL(string: movieURL) {    //nil이 아닐때만 {}안으로 들어간다
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let JSONdata = data {
                    //                    let dataString = String(data: JSONdata, encoding:.utf8)
                    //                    print(dataString!)
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(MovieData.self, from: JSONdata) //.self는 metatype로 decode에 JSONdata라는 값을 넣으려면 변환이 필요해서 변환하기위해
//                        print(decodedData.boxOfficeResult.dailyBoxOfficeList[0].movieNm)
//                        print(decodedData.boxOfficeResult.dailyBoxOfficeList[0].audiCnt)
                        self.movieData = decodedData //클로저 안에서 class의 프로퍼티에 접근하려면 self.써야함
                        DispatchQueue.main.async { //메인스레드에서 비동기 처리를 해라(UI를 메인이 아니라 네트워크가 작동하는 백그라운드 스레드에서 동작하기 때문에)
                            self.table.reloadData()
                        }
                    }catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! MyTableViewCell
        cell.movieName.text = movieData?.boxOfficeResult.dailyBoxOfficeList[indexPath.row].movieNm
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.description)
    }
    
    
    
    
    
}

