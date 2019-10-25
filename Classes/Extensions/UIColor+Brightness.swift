//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import Foundation
import UIKit

/// Constants for UIColor+Brightness extension.
private struct Constants {
    /// Value after which a color would be considered very bright or close to white.
    static let brightnessThreshold: Double = 0.8
}

/// Extension with utilities related to the brightness of a color.
extension UIColor {
    
    /// The brightness ranges from 0.0 (black) to 1.0 (white).
    var brightness: Double {
        return Double(rgbaComponents.red * 299 + rgbaComponents.green * 587 + rgbaComponents.blue * 114) / 1000.0
    }
    
    /// Whether the color is visible or not, based on its alpha component.
    var isVisible: Bool {
        return rgbaComponents.alpha > 0
    }
    
    /// Whether the color is close to white or not.
    var isAlmostWhite: Bool {
        return brightness > Constants.brightnessThreshold
    }
    
    /// Best matching color between black and white, based on the brightness of the current color.
    var matchingColor: UIColor {
        return isAlmostWhite ? .black : .white
    }
}
