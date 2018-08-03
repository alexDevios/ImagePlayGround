import Foundation
import UIKit

/*
 Одиночка, который хранит в себе кэш картинок + параметр ресайза картинок
 */
class Singelton {
    //
    static let sharedInstance = Singelton()
    let customImageViewWidth: CGFloat! //ресайз картинки
    lazy var imagesCache = NSCache<NSString, UIImage>() //кэш с картинками
    private init() {
        self.customImageViewWidth = 300.0
    }
}

//MARK: - Расширение UIImage для ресайза
extension UIImage {
    //
    func resizeImage(newWidth: CGFloat) -> UIImage {
        let newHeight = newWidth.newHeight(defaultWidth: self.size.width, defaultHeight: self.size.height)
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

//MARK: - Расширение CGFloat для получение высоты (учитывая соотношения высоты и ширины)
extension CGFloat {
    func newHeight(defaultWidth: CGFloat, defaultHeight: CGFloat) -> CGFloat {
        let newHeight = (self * defaultHeight) / defaultWidth
        return newHeight
    }
}

//MARK: - Расширение UIAlertController
extension UIAlertController {
    func present() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let roorVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                if let currentVC = roorVC.visibleViewController {
                    currentVC.present(self, animated: false, completion: nil)
                }
            }
        }
    }
}
