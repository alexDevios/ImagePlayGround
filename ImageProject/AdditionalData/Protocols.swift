import Foundation

//MARK: - протокол с функцией содержащей данные о response
protocol NetworkDataProtocol: class {
    func responseResult(_ data: Data?)
}
