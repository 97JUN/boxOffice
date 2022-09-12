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


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate{
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var dateInput: UITextField!
    
    var movieURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=298a0ec296e8096e6d71d4d05b016b7d&targetDt="
    
    var movieData : MovieData? //이니셜라이저도 없어서 옵셔널형으로 해준것이다. (초기값이 뭔지 모르기때문에)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        dateInput.delegate = self
        
        getData(with: movieURL)
        
    }
    @IBAction func searchPressed(_ sender: Any) {
        dateInput.endEditing(true)
        
        
    }
    func fetchURL(date: String) {
        let fetchURL = "\(movieURL)\(date)"
        getData(with: fetchURL)
    }

     func textFieldDidEndEditing(_ textField: UITextField) {
        if let dateText = dateInput.text {
            fetchURL(date: dateText)
        }
        dateInput.text = ""
    }
    
    func getData(with fetchURL: String) {
        if let url = URL(string: fetchURL) {    //nil이 아닐때만 {}안으로 들어간다.  1단계
            let session = URLSession(configuration: .default)       //2단계(Create a URLSession)
            let task = session.dataTask(with: url) { data, response, error in// 3단계( give a task)
                if error != nil {
                    print(error!)
                    return //에러가 있는경우
                }
                if let JSONdata = data {
                    //                    let dataString = String(data: JSONdata, encoding:.utf8)
                    //                    print(dataString!)
                    
                    ///////parseJSON 부분
                    ///
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
            task.resume() //4단계 start the task
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dateInput.endEditing(true)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else {
            textField.placeholder = "날짜를 입력하세요."
            return false
        }
    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let date = dateInput.text {
//            fetchDate(date: date)
//        }
//
//        dateInput.text = ""
//
//    }
    
    func fetchDate(date: String) {
        movieURL += dateInput.text!
      
    }
}

