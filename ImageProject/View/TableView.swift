import UIKit

class MyTableView: UITableViewController {
    //
    
    let searchController = UISearchController(searchResultsController: nil) //UISearchController
    let networkManager = NetworkManager() //Класс NetworkManager для запросов
    var myViewModel = [ViewModel]() //ViewModel
    var indexOfImage: Int! { //Индекс выбранной картинки
        didSet {
            self.performSegue(withIdentifier: "showImage", sender: nil)
        }
    }
    var mySingelton = Singelton.sharedInstance //сингтон
    
    //MARK: - viewDidLoad method
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        networkManager.networkDataDelegate = self
        setupController()
    }
    
    //MARK: - Сетим свойста таблички + UISearchController'а
    fileprivate func setupController() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "imageCell")
        //
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        //
        searchController.searchBar.keyboardAppearance = .dark
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.searchController = searchController
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
    }
    
    //MARK: - prepareForSegue method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if case let desVC as ImageView = segue.destination, segue.identifier == "showImage" {
            desVC.imageUrl = myViewModel[indexOfImage].mainImageUrl
        }
    }
}

//MARK: - расширение таблицы с описанием методов UITableViewDelegate и UITableViewDataSource
extension MyTableView {
    
    //MARK: - кол. секций
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: - кол. ячеек
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myViewModel.count
    }
    
    //MARK: - обработка нажатия на ячейку
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        //
        indexOfImage = indexPath.row
    }
    
    //MARK: - инициализация ячейки с передачей данных
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! MyImageCell
        let viewModel = myViewModel[row]
        cell.modelView = viewModel
        return cell
    }
    
    //MARK: - устанавливаем высоту в соответсвии размера картинки
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        let newHeight = mySingelton.customImageViewWidth.newHeight(defaultWidth: CGFloat(myViewModel[row].sizeWidth ?? 0), defaultHeight: CGFloat(myViewModel[row].sizeHeigt ?? 0))
        return newHeight
    }
}

//MARK: - Расширение таблицы. Функции UISearchBarDelegate и NetworkDataProtocol
extension MyTableView: UISearchBarDelegate, NetworkDataProtocol {
    
    //MARK: - Обработка нажатия кнопки "Поиск" в UISearchBar'е
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchImage(searchText: searchBar.text!)
    }
    
    //MARK: - Обработка нажатия кнопки "Отмена" в UISearchBar'е
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
    }
    
    //MARK: - Поиск картинок по введенному тексту
    func searchImage(searchText: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DispatchQueue.global().async {
            self.networkManager.createRequest(url: "https://api.tumblr.com/v2/tagged?tag=\(searchText)&api_key=CcEqqSrYdQ5qTHFWssSMof4tPZ89sfx6AXYNQ4eoXHMgPJE03U")
        }
    }
    
    //MARK: - обработка результатов поиска
    func responseResult(_ data: Data?) {
        DispatchQueue.global().async {
            if let data = data {
                do {
                    let newsData = try JSONDecoder().decode(Root.self, from: data)
                    if let responseArray = newsData.response {
                        self.myViewModel = responseArray
                            .compactMap { $0.photos }
                            .compactMap { $0 }
                            .flatMap { $0 }
                            .compactMap { $0 }
                            .map { return ViewModel(photo: $0) }
                    }
                } catch let error {
                    let alert = UIAlertController(title: "Warning!", message: error.localizedDescription, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(ok)
                    alert.present()
                }
            }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.searchController.isActive = false
                self.searchController.searchBar.text = nil
                self.tableView.reloadData()
            }
        }
    }
}
