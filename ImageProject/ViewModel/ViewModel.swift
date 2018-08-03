import Foundation

//ModelView
struct ViewModel {
    var mainImageUrl: String? //url оригинала
    var previewImageUrl: String? //url для превью
    var sizeWidth: Int? //width превью
    var sizeHeigt: Int? //height превью
    
    //init
    init(photo: Photos) {
        let firstImage = photo.images.first //получение оригинальной картинки (она всегда первая в массиве)
        let previewPhoto = photo.images.filter { photoUrl -> Bool in
            return photoUrl.width >= 300
            }.last //получаем все картинки, которые ольше 300px и забираем последнюю
        self.mainImageUrl = firstImage?.url //url на оригинал
        self.previewImageUrl = previewPhoto?.url ?? firstImage?.url //проверяем на наличие url на картинку для превью если ее нет, то используем оригинальную url
        self.sizeWidth = previewPhoto?.width ?? firstImage?.width //проверяем на наличие width на картинку для превью если ее нет, то используем оригинальный width
        self.sizeHeigt = previewPhoto?.height ?? firstImage?.height //проверяем на наличие height на картинку для превью если ее нет, то используем оригинальный height
    }
}
