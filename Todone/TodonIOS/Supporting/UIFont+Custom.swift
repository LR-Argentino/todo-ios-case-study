//
//  CustomFont.swift
//  TodonIOS
//
//  Created by Luca Argentino on 10.02.2025.
//

import UIKit

extension UIFont {
   static var interBold16: UIFont {
       UIFont(name: "Inter18pt-Bold", size: 16) ?? .systemFont(ofSize: 16, weight: .bold)
   }

   static var interRegular12: UIFont {
       UIFont(name: "Inter28pt-Regular", size: 12) ?? .systemFont(ofSize: 12, weight: .regular)
   }
}
