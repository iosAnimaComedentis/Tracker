import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let mainViewController = MainViewController()
        let statisticViewController = StatisticViewController()
        
        mainViewController.title = "Трекеры"
        statisticViewController.title = "Статискика"
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [mainViewController, statisticViewController]
        
        let tabBarFirstItem = UITabBarItem(title: "Трекеры", image: UIImage(resource: .trackers ), tag: 0)
        let tabBarSecondtItem = UITabBarItem(title: "Статистика", image: UIImage(resource: .stats), tag: 1)
        mainViewController.tabBarItem = tabBarFirstItem
        statisticViewController.tabBarItem = tabBarSecondtItem
        
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
