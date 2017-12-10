
import UIKit
import PlaygroundSupport

struct AnimateableViewProperties {
    static let tagIndicator:Int = 99
}

class TestingGCDController:UIViewController {
    
    //MARK:- iVars
    private lazy var animateButton:UIButton = {
        let button = UIButton.init()
        button.backgroundColor = .brown
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.setTitle("Animate", for: .normal)
        button.addTarget(self, action: #selector(didTapRightBarButton), for: .touchUpInside)
        return button
    }()
    private lazy var rightBarButtonItem:UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem.init()
        barButtonItem.customView = animateButton
        return barButtonItem
    }()
    private let iPhone6PrimaryView:UIView = {
        let view = UIView(frame: CGRect(x:0, y:0, width: 368, height:667))
        view.backgroundColor = .lightGray
        return view
    }()
    private let animateableView:UIView = {
        let view = UIView(frame: CGRect(x:0, y:0, width:40, height:40))
        view.backgroundColor = .yellow
        view.tag = AnimateableViewProperties.tagIndicator
        return view
    }()
    
    //MARK:- Main view related private functions
    private func getAnimateableView(with tag:Int)->UIView {
        return self.iPhone6PrimaryView.viewWithTag(AnimateableViewProperties.tagIndicator)!
    }
    private func rightBarButtonStateDidBegin() {
        let button = self.navigationItem.rightBarButtonItem?.customView as! UIButton
        button.isUserInteractionEnabled = !button.isUserInteractionEnabled
        button.backgroundColor = UIColor.brown.withAlphaComponent(0.2)
    }
    private func rightBarButtonStateDidEnd() {
        let button = self.navigationItem.rightBarButtonItem?.customView as! UIButton
        button.isUserInteractionEnabled = !button.isUserInteractionEnabled
        button.backgroundColor = UIColor.brown.withAlphaComponent(1.0)
    }
    @objc func didTapRightBarButton() {
        //Diable the bar button user interaction
        rightBarButtonStateDidBegin()
        //Call the animation actions
        animateAnimateableViewHeight()
        animateAnimateableViewAngle()
        animateIphone6PrimaryViewBackgroundColor()
        //Enable the bar button user interaction
        rightBarButtonStateDidEnd()
    }
    
    //MARK:- Animation cleanup related private functions
    private func removeAnimateableViewAngleInclination() {
        let view = getAnimateableView(with: AnimateableViewProperties.tagIndicator)
        view.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi))
    }
    private func changeMainViewBackgroundColor() {
        self.iPhone6PrimaryView.backgroundColor = .lightGray
    }
    
    //MARK:- Animate related private functions
    private func animateAnimateableViewHeight() {
        let view = getAnimateableView(with: AnimateableViewProperties.tagIndicator)
        UIView.animate(withDuration: 5.0, animations: {
            view.frame = CGRect(x:368-40,y:667-(40+44),width:40,height:40)
        },completion: nil)
    }
    private func animateAnimateableViewAngle() {
        let view = getAnimateableView(with: AnimateableViewProperties.tagIndicator)
        UIView.animate(withDuration: 1.0, animations: {
            view.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi/4))
        }, completion:{ isSuccess in
            self.removeAnimateableViewAngleInclination()
        })
    }
    private func animateIphone6PrimaryViewBackgroundColor() {
        UIView.animate(withDuration: 3.0, animations: { [weak self] in
            self?.iPhone6PrimaryView.backgroundColor = .blue
            }, completion: { isSuccess in
                self.changeMainViewBackgroundColor()
        })
    }
    
    //MARK:- Overridden functions
    override func viewDidLoad() {
        self.title = "Basic:UIView(Animation)"
        view.backgroundColor = .white
        iPhone6PrimaryView.addSubview(animateableView)
        self.view.addSubview(iPhone6PrimaryView)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
}

let nc = UINavigationController.init(rootViewController: TestingGCDController())
nc.navigationBar.isTranslucent = false
PlaygroundPage.current.liveView = nc

