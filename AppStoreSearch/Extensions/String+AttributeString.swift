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
  
  var convertMB: String {
      guard let bytes = Int64(self) else { return ""}
      let formatter = ByteCountFormatter()
      formatter.allowedUnits = ByteCountFormatter.Units.useMB
      formatter.countStyle = ByteCountFormatter.CountStyle.binary
      formatter.includesUnit = false
      
      let result = formatter.string(fromByteCount: bytes) as String
      return "\(result)MB"
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

extension Array where Element == String {
  func converLanguage() -> (subTitle: String, content: String) {
    var titleResult: String = ""
    var descResults: [String] = []
    
    let locale = NSLocale.autoupdatingCurrent
    let languageCode = locale.languageCode!
    for code in self {
        let language = locale.localizedString(forLanguageCode: code)!
        if languageCode.uppercased() == code {
            titleResult = language
        }
        descResults.append(language)
    }
    
    let descResultsCount: Int = descResults.count
    let subTitle = (descResultsCount == 0) ? "\(titleResult)" : "\(titleResult)외 \(descResults.count)개"
    let content = descResults.joined(separator: ", ")
    
    return (subTitle, content)
  }
}
