import UIKit
import Alamofire

class ImageView: UIViewController {

    @IBOutlet weak var imageView: UIImageView! //mageView
    var imageUrl: String? //ссылка на картинку
    let networkManager = NetworkManager() //Класс NetworkManager для запросов
    var mySingelton = Singelton.sharedInstance //сингтон
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! //ActivityIndicator
    
    //MARK: - viewDidLoad method
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        if let imageURL = imageUrl {
            navigationController?.hidesBarsOnTap = true
            automaticallyAdjustsScrollViewInsets = false
            if let imageData = mySingelton.imagesCache.object(forKey: imageURL as NSString) {
                activityIndicator.stopAnimating()
                imageView.image = imageData
            } else {
                networkManager.networkDataDelegate = self
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                DispatchQueue.global().async {
                    self.networkManager.createRequest(url: imageURL)
                }
            }
        }
    }
    
    //MARK: - viewWillDisappear method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //
        navigationController?.hidesBarsOnTap = false
    }
}
extension ImageView: NetworkDataProtocol {
    
    //MARK: - Загрузка и отображение картинки
    func responseResult(_ data: Data?) {
        if let data = data {
            if let image = UIImage(data: data)?.resizeImage(newWidth: self.view.frame.width) {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                mySingelton.imagesCache.setObject(image, forKey: self.imageUrl! as NSString)
                imageView.image = image
                activityIndicator.stopAnimating()
            }
        }
    }
}

