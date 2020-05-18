//
//  MockNavigation.swift
//  DemoTests
//
//  Created by Aldo Martinez on 5/17/20.
//  Copyright © 2020 Andres Rivas. All rights reserved.
//

import UIKit

class MockNavigation: UINavigationController {
    
    var presentedView: UIViewController?
    var pushedView: UIViewController?
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentedView = viewControllerToPresent
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedView = viewController
    }
}
