//
//  String+Ex.swift
//  NewHomework
//
//  Created by draak on 02/05/2019.
//  Copyright © 2019 Draak. All rights reserved.
//

import UIKit
import SVGKit

extension String {
    
    ///String -> Date
    func getDateFromString() -> Date {
        
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        dateStringFormatter.locale = Locale(identifier: "ko_KR")
        if let date = dateStringFormatter.date(from: self) {
            return date
        }
        return Date()
    }
    
    
    ///attributedString을 만든다
    func getAttributedString(font: UIFont,
                          color: UIColor,
                          align: NSTextAlignment = .left,
                          lineHeight: CGFloat = 0,
                          letterSpace: CGFloat = 0) -> NSAttributedString {
        
        return self.setAttribText(str: self,
                                  size: font.pointSize,
                                  lineHeight: lineHeight,
                                  letterSpace: letterSpace,
                                  align: align,
                                  color: color,
                                  font: font.fontName)
    }
    
    ///스트링과 같은 이름의 뷰컨트롤러를 생성한다
    func makeViewController() -> UIViewController {
        if let bundleName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String,
            let viewController = (NSClassFromString("\(bundleName).\(self)") as? UIViewController.Type) {
            
            return viewController.init()
            
        }
        return UIViewController()
    }
    
    ///SVG로 UIImage를 생성한다
    func getSVGImage(color: UIColor? = nil, resize: CGSize? = nil) -> UIImage {
        guard let imgPath = Bundle.main.path(forResource: self, ofType: "svg") else {
            return UIImage()
        }
        let svgImg = SVGKImage(contentsOfFile: imgPath)
        if resize != nil {
            svgImg?.size = resize!
        }
        
        let svgLayer = svgImg?.caLayerTree.sublayers
        
        for subLayer in svgLayer! {
            if subLayer is CAShapeLayer {
                let shapeLayer = subLayer as! CAShapeLayer
                if shapeLayer.fillColor != nil {
                    if let c = color {
                        shapeLayer.fillColor = c.cgColor
                    }
                }
            }
        }
        
        return (svgImg?.uiImage)!
    }
    
    /// 스타일 지정 및 폰트 지정
    private func setAttribText(str: String, size: CGFloat, lineHeight: CGFloat?, letterSpace: CGFloat?, align: NSTextAlignment, color: UIColor, font: String, isHtmlText: Bool = false) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = align
        
        if lineHeight != nil {
            paragraphStyle.minimumLineHeight = lineHeight!
            paragraphStyle.maximumLineHeight = lineHeight!
        }
        
        paragraphStyle.lineBreakMode = .byCharWrapping
        
        let labelFont = UIFont(name: font, size: size)
        var labelText: NSAttributedString? = nil
        var attributes: [NSAttributedString.Key: Any] = [:]
        
        if let lspace = letterSpace {
            attributes = [.paragraphStyle: paragraphStyle,
                          .kern: lspace,
                          .foregroundColor: color,
                          .font: labelFont!,
                          // NSBaselineOffsetAttributeName : -0.5
            ]
        } else {
            attributes = [.paragraphStyle : paragraphStyle,
                          .foregroundColor : color,
                          .font : labelFont!,
                          // NSBaselineOffsetAttributeName : -0.5
            ]
        }
        
        labelText = NSAttributedString(string: str as String, attributes: attributes)
        
        if isHtmlText {
            var htmlLabelText: NSAttributedString? = nil
            
            do {
                htmlLabelText = try NSAttributedString(data: str.data(using: .utf8)!, options: [.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey(rawValue: "CharacterEncoding"): String.Encoding.utf8.rawValue], documentAttributes: nil)
                labelText = htmlLabelText
            } catch let error as NSError {
//                print("HTML Attrib Text Error : %@", error.localizedDescription)
            }
        }
        
        return labelText!
    }
}
