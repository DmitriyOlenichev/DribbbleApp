//
//  common.swift
//  DribbbleApp
//
//  Created by Admin on 17.09.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

//=
extension String {
    func dateFromFormat(dateFormat: String = "yyyy-MM-dd'T'HH:mm:ssz") -> Date? {
        //self "2013-07-21T19:32:00z"  //zZ?
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        return dateFormatter.date(from: self)
    }
    
    func stripHtml() -> String {
        let pat = "<[^>]+>"
        let regex = try! NSRegularExpression(pattern: pat, options: [])
        
            
        let res = regex.stringByReplacingMatches(in: self, range: NSMakeRange(0, self.characters.count), withTemplate: "")
        return res
    }
}

//=
extension Date {
    func desc() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy, HH:mm:ss"
        //dateFormatter.timeZone = TimeZone(name: "UTC")
        let dateStr = dateFormatter.string(from: self)
        
        return dateStr
    }
}

//=
extension UIImageView {
    func setRoundImage(url: String, width: CGFloat, height: CGFloat, transitionTime: TimeInterval = 0.2) -> Bool {
        guard !url.isEmpty else { return false }
        
        let placeholderImage = UIImage(named: "placeholder")!
        let imageFilter = AspectScaledToFillSizeCircleFilter(size: CGSize(width: width, height: height))
        self.af_setImage(withURL: URL(string: url)!, placeholderImage: placeholderImage, filter: imageFilter, imageTransition: .curlDown(transitionTime))
        return true
    }
}

extension Array where Element:Equatable {
    func unique() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
    
    func unique(of: [Element]) -> [Element] {
        var result = [Element]()
        
        for value in self {
            if of.containsValue(value) == false {
                result.append(value)
            } //else { debugPrint("**" + ) }
        }
        return result
    }
    
    func containsValue(_ el: Element) -> Bool {
        for val in self {
            //debugPrint("**\((val as! Shot).id.description) and \((el as! Shot).id.description)")
            if val == el {
                return true }
        }
        return false
    } 
    
}

//Shots Equatable fix
extension Array where Element:IdEquatable {
    func uniqueById(of: [Element]) -> [Element] {
        var result = [Element]()
        
        for value in self {
            if of.containsItemById(value) == false {
                result.append(value)
            } //else { debugPrint("**" + ) }
        }
        return result
    }
    
    func containsItemById(_ item: IdEquatable) -> Bool {
        for val in self {
            if val.id == item.id {
                return true
            }
        }
        return false
    }
}
    
extension UIScrollView {
    func  isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}



/*

protocol State {
    var state: ButtonState { get set }
}
//
extension UIBarButtonItem: State {
    //var state = "normal"
    var state: ButtonState
    func getState() -> ButtonState {
        let state = "normal"
        //return state
    }
}*/
