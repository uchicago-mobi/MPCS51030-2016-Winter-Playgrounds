import Foundation
import XCPlayground
import UIKit

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let string = "Washington (CNN) Retired Supreme Court Justice Sandra Day O&#39;Connor says President Barack <b>Obama</b> should name Antonin Scalia&#39;s replacement. O&#39;Connor, a nominee of President Ronald Reagan who became the court&#39;s swing vote until she retired from&nbsp;..."
print(string)

let label = UILabel(frame: CGRect(x: 0, y: 0, width: 1000, height: 100))
label.text = string
label.numberOfLines = 3

///: Use regular expression to strip out the html tags
///: This leaves some of the markup.
let regex = try! NSRegularExpression(pattern: "<.*?>", options: [.CaseInsensitive])
let range = NSMakeRange(0, string.characters.count)
let htmlLessString :String = regex.stringByReplacingMatchesInString(string, options: [],
    range:range ,
    withTemplate: "")
print(htmlLessString)


///:  Use the html for format the string using `NSAttributedString`.
var attrStr = try! NSAttributedString(
        data: string.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
        options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
        documentAttributes: nil)
label.attributedText = attrStr


extension String {
  func html2attributedString() -> NSAttributedString {
    let attrStr = try! NSAttributedString(
        data: self.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
        options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
        documentAttributes: nil)
    return attrStr
  }
}

label.attributedText = "This is an HTML string.  This word is <b>bold</b>. This contains a '&nbsp;&nbsp;'".html2attributedString()

  
