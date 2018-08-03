import UIKit
import Alamofire

class ImageView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //
        Alamofire.request("https://google.com").responseString { (data) in
            print(data.description)
        }
    }
}

