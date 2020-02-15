import UIKit

public struct Scene<A: UIViewController> {
    public init () { }
    
    public func render() -> A {
        guard let nib = (String(describing: type(of: self)) as NSString).components(separatedBy: ".").first else {
            fatalError()
        }
                
        let vc = A(nibName: String(nib.replacingOccurrences(of: "Scene<", with: "").dropLast()),
                   bundle: Bundle(for: A.self))
        
        return vc
    }
}

public func navigationLink<A: UIViewController>(from vc: UIViewController, destination: Scene<A>, completion: (A) -> Void, isModal: Bool =  false) -> Void {
    let to = destination.render()
    
    if isModal {
        completion(to)
        
        vc.present(to, animated: true)
        return
    }
    
    vc.navigationController?.pushViewController(to, animated: true)
    
    completion(to)
}
