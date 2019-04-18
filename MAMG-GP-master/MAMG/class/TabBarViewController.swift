import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let views = self.viewControllers
        views![0].tabBarItem.image = resizeIcon(image: UIImage.init(named: "home-3")!) //Home
        views![1].tabBarItem.image = resizeIcon(image: UIImage.init(named: "theatre-2")!) //Halls
        views![2].tabBarItem.image = resizeIcon(image: UIImage.init(named: "map-2")!) //Map
        views![3].tabBarItem.image = resizeIcon(image: UIImage.init(named: "users-2")!) //User
        
        views![0].tabBarItem.selectedImage = resizeIcon(image: UIImage.init(named: "home")!) //Home
        views![1].tabBarItem.selectedImage = resizeIcon(image: UIImage.init(named: "theatre")!) //Halls
        views![2].tabBarItem.selectedImage = resizeIcon(image: UIImage.init(named: "map-1")!) //Map
        views![3].tabBarItem.selectedImage = resizeIcon(image: UIImage.init(named: "group")!) //User
    }
    

    func resizeIcon(image: UIImage) -> UIImage {
        let iconSize = CGSize.init(width: 40, height: 40)
        UIGraphicsBeginImageContext(iconSize)
        image.draw(in: CGRect.init(x: 0, y: 0, width: iconSize.width, height: iconSize.height))
        let destImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
        UIGraphicsEndImageContext()
        return destImage!
    }

}
