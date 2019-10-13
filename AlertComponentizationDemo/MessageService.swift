//
//  MessageService.swift
//  AlertComponentizationDemo
//
//  Created by 陳囿豪 on 2019/10/13.
//  Copyright © 2019 yasuoyuhao. All rights reserved.
//

import SwiftEntryKit
import PromiseKit

class MessageService {
    
    static let shared = MessageService()
    
    private init() { }
    
    fileprivate let attributesPopUp: EKAttributes = {
        var attributes = EKAttributes.centerFloat
        attributes.windowLevel = .alerts
        attributes.hapticFeedbackType = .success
        attributes.screenInteraction = .absorbTouches
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .disabled
        attributes.screenBackground = .color(color: EKColor.white.with(alpha: 0.5))
        attributes.entryBackground = .color(color: EKColor.white.with(alpha: 0.98))
        attributes.entranceAnimation = .init(scale: .init(from: 0.9,
                                                          to: 1,
                                                          duration: 0.4,
                                                          spring: .init(damping: 0.8,
                                                                        initialVelocity: 0)),
                                             fade: .init(from: 0,
                                                         to: 1,
                                                         duration: 0.3))
        attributes.exitAnimation = .init(scale: .init(from: 1,
                                                      to: 0.4,
                                                      duration: 0.4,
                                                      spring: .init(damping: 1,
                                                                    initialVelocity: 0)),
                                         fade: .init(from: 1,
                                                     to: 0,
                                                     duration: 0.2))
        attributes.displayDuration = .infinity
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.bounds.maxX), height: .fill)
        return attributes
    }()
    
    func showTableSelectionView<T: RawCaseable>(title: String, description: String, data: T.Type, image: UIImage? = nil, imageSize: CGSize = CGSize(width: 80, height: 80), isHaveCancel: Bool = true) -> Promise<T> where T.RawValue == String {
        
        return Promise<T>.init(resolver: { (resolver) in
            let title = EKProperty.LabelContent(text: title, style: .init(font: .systemFont(ofSize: 16), color: .black, alignment: .center))
            let description = EKProperty.LabelContent(text: description, style: .init(font: PopUpMessageFont.shared.subTitleFont, color: EKColor.black.with(alpha: 0.98), alignment: .center))
            
            let buttonFont: UIFont = .systemFont(ofSize: 16)
            let buttonColor: EKColor = EKColor.init(red: 0, green: 66, blue: 188)
            
            let image = EKProperty.ImageContent.init(image: image ?? #imageLiteral(resourceName: "icons8-swift"), size: CGSize(width: imageSize.width, height: imageSize.height), contentMode: .scaleAspectFit, makesRound: true)
            let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
            
            var buttonsBarContent = EKProperty.ButtonBarContent(with: [], separatorColor: buttonColor.with(alpha: 0.2), expandAnimatedly: true)
            
            // Close button
            if isHaveCancel {
                
                let closeButtonLabelStyle = EKProperty.LabelStyle(font: buttonFont, color: EKColor.black.with(alpha: 0.8))
                let closeButtonLabel = EKProperty.LabelContent(text: "取消", style: closeButtonLabelStyle)
                let closeButton = EKProperty.ButtonContent(label: closeButtonLabel, backgroundColor: .clear, highlightedBackgroundColor: EKColor.white.with(alpha: 0.05)) {
                    
                    resolver.reject(UIError.userDoIsCancal)
                    
                    SwiftEntryKit.dismiss()
                }
                
                buttonsBarContent.content.append(closeButton)
            }
            
            T.allCases.forEach { (item) in
                let controlButtonLabelStyle = EKProperty.LabelStyle(font: buttonFont, color: buttonColor)
                let controlButtonLabel = EKProperty.LabelContent(text: NSLocalizedString(item.rawValue, comment: ""), style: controlButtonLabelStyle)
                let controlButton = EKProperty.ButtonContent(label: controlButtonLabel, backgroundColor: .clear, highlightedBackgroundColor: buttonColor.with(alpha: 0.05)) {
                    SwiftEntryKit.dismiss()
                    
                    resolver.fulfill(item)
                    return
                }
                
                buttonsBarContent.content.append(controlButton)
            }
            
            let alertMessage = EKAlertMessage(simpleMessage: simpleMessage, buttonBarContent: buttonsBarContent)
            
            // Setup the view itself
            let contentView = EKAlertMessageView(with: alertMessage)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                SwiftEntryKit.display(entry: contentView, using: self.attributesPopUp)
            }
            
        })
    }
}

protocol RawCaseable: RawRepresentable, CaseIterable { }

struct PopUpMessageFont {
    
    static let shared = PopUpMessageFont()
    
    let titleFont = UIFont.systemFont(ofSize: 18, weight: .medium)
    let subTitleFont = UIFont.systemFont(ofSize: 12, weight: .medium)
    let buttonTitleFont = UIFont.systemFont(ofSize: 18, weight: .regular)
}

enum UIError: Error {
    case userDoIsCancal

    var localizedDescription: String {
        return getLocalizedDescription()
    }

    private func getLocalizedDescription() -> String {

        switch self {

        case .userDoIsCancal:
            return "Operation canceled"
        }

    }
}

enum FoodKind: String, RawCaseable {
    case steak = "牛排"
    case chickenChops = "雞排"
    case italianNoodles = "義大利麵"
    case hainanChickenRice = "海南雞飯"
}

enum HeroKind: String, RawCaseable {
    case fighter = "鬥士"
    case assassin = "刺客"
    case mage = "法師"
    case shooter = "射手"
    case support = "輔助"
}
