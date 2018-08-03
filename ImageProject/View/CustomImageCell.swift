import Foundation
import UIKit

/*
 Кастомная ячейка с UIImageView
 */
class MyImageCell: UITableViewCell {
    //
    @IBOutlet weak var customImageView: UIImageView! //ImageView
    var mySingelton = Singelton.sharedInstance //синглтон
    let networkManager = NetworkManager() //класс нетворк-менеджер
    
    //Модель
    var modelView: ViewModel! {
        didSet {
            customImageView.image = nil
            if let imageURL = modelView.previewImageUrl {
                if let imageData = mySingelton.imagesCache.object(forKey: imageURL as NSString) {
                    customImageView.image = imageData
                } else {
                    DispatchQueue.global().async {
                        self.networkManager.networkDataDelegate = self
                        self.networkManager.createRequest(url: imageURL)
                    }
                }
            }
        }
    }
}

//MARK: - Расширение для UIImageView для загрузки картинки
extension MyImageCell: NetworkDataProtocol {
    //
    func responseResult(_ data: Data?) {
        if let data = data {
            if let image = UIImage(data: data)?.resizeImage(newWidth: self.mySingelton.customImageViewWidth) {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if let imageURL = modelView.previewImageUrl {
                    mySingelton.imagesCache.setObject(image, forKey: imageURL as NSString)
                    customImageView.image = image
                }
            }
        }
    }
}
