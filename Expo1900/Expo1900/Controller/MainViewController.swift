//
//  Expo1900 - ViewController.swift
//  Created by 사파리 파프리. 
//  Copyright © yagom academy. All rights reserved.
// 

import UIKit

private extension String {
    static var visitor: String { "방문객" }
    static var location: String { "개최지" }
    static var duration: String { "개최기간" }
}

final class MainViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var visitorsLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var decriptionLabel: UILabel!
    @IBOutlet weak var subViewShowButton: UIButton!
    
    let uiAppDelegate = UIApplication.shared.delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        fixViewOrientation(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fixViewOrientation(false)
    }
}

// MARK: - Method
private extension MainViewController {
    
    func setUpView() {
        guard let expoInfomation = Expo.parsingJson(name: "exposition_universelle_1900") else { return }
        guard let separationIndex = expoInfomation.title.firstIndex(of: "(") else { return }
        
        titleLabel.text = String(expoInfomation.title[..<separationIndex]) + "\n" + String(expoInfomation.title[separationIndex...])
        posterImageView.image = UIImage(named: "poster")
        visitorsLabel.text = setUpVisitorsLabel(expoInfomation)
        locationLabel.text = .location + " : \(expoInfomation.location)"
        durationLabel.text = .duration + " : \(expoInfomation.duration)"
        changeFont()
        decriptionLabel.text = expoInfomation.description
        subViewShowButton.setTitle("한국의 출품작 보러가기", for: .normal)
        subViewShowButton.maximumContentSizeCategory = .accessibilityMedium
    }
    
    func changeFont() {
        visitorsLabel.changePartFont(part: .visitor)
        locationLabel.changePartFont(part: .location)
        durationLabel.changePartFont(part: .duration)
    }
    
    func setUpVisitorsLabel(_ expo: Expo) -> String {
        if let formattedVisitors = expo.formattedVisitors {
            return .visitor + " : \(formattedVisitors)" + " \(String(format: NSLocalizedString("people", comment: "인원")))"
        } else {
            return "FormatError"
        }
    }
    
    func fixViewOrientation(_ fixed: Bool) {
        guard let appDelegate = uiAppDelegate as? AppDelegate else { return }
        
        appDelegate.isPortrait = fixed
        
        if fixed {
            let value = UIDeviceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
    }
}

// MARK: - UILabel AddAttribute
private extension UILabel {
    func changePartFont(part: String) {
        guard let text = self.text else { return }
        let mutableText = NSMutableAttributedString(string: text)
        let changingRange = (text as NSString).range(of: part)
        
        mutableText.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .title3), range: changingRange)
        
        self.attributedText = mutableText
    }
}
