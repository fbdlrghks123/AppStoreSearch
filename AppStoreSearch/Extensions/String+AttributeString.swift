//
//  String+AttributeString.swift
//  AppStoreSearch
//
//  Created by RIH on 2020/09/19.
//  Copyright © 2020 Ickhwan Ryu. All rights reserved.
//

extension UUID {
  static var string: String {
      return UUID().uuidString
  }
}

extension String {
  var attributeString: NSAttributedString {
    let paragraphyStyle = NSMutableParagraphStyle().then {
      $0.lineSpacing = 3
    }
    let attributes: [NSAttributedString.Key: Any] = [
      .font : UIFont.systemFont(ofSize: 13),
      .foregroundColor : UIColor.label,
      .paragraphStyle : paragraphyStyle
    ]
    return NSAttributedString(string: self, attributes: attributes)
  }
  
  func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(
      with: constraintRect,
      options: .usesLineFragmentOrigin,
      attributes: [NSAttributedString.Key.font: font],
      context: nil)
    
    return CGFloat(boundingBox.height)
  }
  
}
