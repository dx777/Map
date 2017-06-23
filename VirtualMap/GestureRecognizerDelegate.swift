import UIKit

class GestureRecognizerDelegate: UIGestureRecognizer, UIGestureRecognizerDelegate {
  
    func gestureRecognizer(_: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
}
