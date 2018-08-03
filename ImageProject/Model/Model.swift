import Foundation

/*
 После успешного response "распихиваем" данные по структурам.
 Результат должен имееть массив с "альтернативными размерами" наших картинок. (нужно, что бы не загружать большую картинку для превью)
 */


//MARK: - 1st an 2nd level (root + [response])
struct Root: Decodable {
    var response: [Response]?
    
    /*-------------------------*/
    struct Response: Decodable {
        var photos: [Photos]?
    }
}

//MARK: - 3rd and 4th level ([photos] + [alt_sizes])
struct Photos: Decodable {
    var images: [Photo] //массив с альтернативными картинками (для получение разных размеров)
    
    /*-------------------------*/
    struct Photo: Decodable {
        var url: String //ссылка на картинку
        var width: Int //ширина
        var height: Int //высота
    }
}
extension Photos {
    private enum CodingKeys: String, CodingKey {
        case images = "alt_sizes"
    }
}
