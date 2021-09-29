//
//  PictureCaption.swift
//  Gallery
//
//  Created by Rey Jairus Marasigan on 9/14/21.
//

import UIKit

class PictureCaption: NSObject, NSCoding {
    var caption: String
    var imageData: Data?
    var date: String
    
    init(caption: String, imageData: Data, date: String) {
        self.caption = caption
        self.imageData = imageData
        self.date = date
    }
    
    //decoding the properties of person from NSCoder
    required init(coder aDecoder: NSCoder) {
        caption = aDecoder.decodeObject(forKey: "caption") as? String ?? ""
        imageData = aDecoder.decodeObject(forKey: "imageData") as? Data
        date = aDecoder.decodeObject(forKey: "date") as? String ?? ""
    }

    //encoding the properties of Person so that it can be stored using userDefault
    func encode(with aCoder: NSCoder) {
        aCoder.encode(caption, forKey: "caption")
        if let imageDat = imageData {
            aCoder.encode(imageDat, forKey: "imageData")
        }
        aCoder.encode(date, forKey: "date")
    }

}
