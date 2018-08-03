import Foundation
import Alamofire
import UIKit

/*
 Проверка на коннект к интернету
 */
class InternetConnection {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

/*
 Класс, который выполняет запросы отправляет данные по делегату
 */
class NetworkManager {
    
    //MARK: - слабая ссылка на делегат
    weak var networkDataDelegate: NetworkDataProtocol?
    
    //MARK: - Функция запроса
    func createRequest(url: String) {
        if InternetConnection.isConnectedToInternet {
            Alamofire.request(url)
                .responseData { response in
                    if response.result.isSuccess {
                        self.networkDataDelegate?.responseResult(response.data)
                    } else {
                        let alert = UIAlertController(title: "Warning!", message: response.error?.localizedDescription ?? "Some problems", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default)
                        alert.addAction(ok)
                        alert.present()
                        self.networkDataDelegate?.responseResult(nil)
                    }
            }
        } else {
            let alert = UIAlertController(title: "Warning!", message: "Check your internet connection", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            alert.addAction(ok)
            alert.present()
            self.networkDataDelegate?.responseResult(nil)
        }
    }
}
