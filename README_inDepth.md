# App Coordinator Explained

Hey, so lets go over exactly whats going on here and why this application is setup like this in the first place.

So lets start from the heart of the application

## App Delegate

Starting in the app delegate, we setup our Coordinator and NetworkDispatcher objects

```swift
  var window: UIWindow?

  private lazy var appCoordinator: Coordinator = self.makeCoordinator()
  private lazy var networkDispatcher: NetworkDispatcher = self.makeNetworkDispatcher()
```

within the `self.makeCoordinator()` function we setup our coordinator factory, connecting the
networkDispatcher in the process and returning an instance of our AppCoordinator.
```swift
return AppCoordinator(router: RouterImp(rootViewController: self.window?.rootViewController as! UINavigationController), coordinatorFactory: factory)
```

So you may have noticed the `RouterImp()` within the AppCoordinator initializer. What we are doing here is passing in our window form
the AppDelegate as the rootViewController. The router is what is used to push, pop, and set a view controller as the new root in our application


So after a little swizzling (the process of swapping out a function with another), which in this case is simple modifying the navigation bar,
we start out application with `appCoordinator.start()`

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        swizzling(UIViewController.self)
        appCoordinator.start()
        return true
    }
```

## AppCoordinator

This now takes us to the main component of this application. The appCoordinator, as the name implies, coordinates our application.
The best way to describe it is, imagine your application in multiple components, which we will call modules.
In this application we have a login page and then a homepage, so we have a login module and home module respectively.

So if we take a look at the `start()` function within `AppDelegate.swift`, we start by of course, running our login flow, to sign into
our app.

```swift
func start() {
        runLoginFlow()
    }

func runLoginFlow() {
        let coordinator = coordinatorFactory.makeEntryCoordinator(router: router)
        coordinator.homeFlow = { [weak self] userInfo in
            self?.runHomeFlow(with: userInfo)
        }
        coordinator.goToHome = { [weak self] in
            self?.runHomeFlow()
        }
        addDependency(coordinator)
        coordinator.start()
    }
```

What we are doing here is creating an EntryCoordinator object which will control the views within our login module (or login flow) and setting
the functions that can be used to switch to other coordinators (such as the home flow) within the app. You could also say instead of switching to other
coordinators, switching to other modules of the app.

After setting our functions we add our connect our coordinator to our app and fire it up.

### EntryCoordinator

Taking a look inside our `EntryCoordinator.swift` file containing our EntryCoordinator class, we see that the `start()` function
runs the `showLogin()` function which creates our login screen.

```swift
func start() {
       showLogin()
   }

   private func showLogin() {
       let loginScreenOutput = factory.makeLoginScreenOutput()
       loginScreenOutput.onLoginComplete = { [weak self] userInfo in
           self?.homeFlow?(userInfo)
       }
       loginScreenOutput.goToHome = {[weak self] in
           self?.goToHome?()
       }
       router.setRootModule(loginScreenOutput)
   }
```

Alright, so what's happening here is we are grabbing an instance of our LoginView from our factory,
setting the required functions defined in the protocol, and in this instance since this is the first view
in this module, setting it is as root view for our application. But of course, there is nothing wrong with simply pushing
the view as well.

At this point the AppCoordinator will then display our login view so the user can login. So this is probably a good point
discuss the Coordinator and Module factories used within our app.

## CoordinatorFactory

For the CoordinatorFactory we define the protocol like so

```swift
protocol CoordinatorFactory
{
    var networkDispatcher: NetworkDispatcher? { get set }

    func makeHomeCoordinator(router: Router) -> Coordinator & HomeCoordinatorOutput
    func makeEntryCoordinator(router: Router) -> Coordinator & EntryCoordinatorOutput
}
```
Which we then implement within `CoordinatorFactoryImp.swift`
```swift
final class CoordinatorFactoryImp: CoordinatorFactory
{
    var networkDispatcher: NetworkDispatcher?

    func makeHomeCoordinator(router: Router) -> Coordinator & HomeCoordinatorOutput {
        let factory = ModuleFactoryImp()
        factory.networkDispatcher = networkDispatcher
        return HomeCoordinator(router: router, factory: factory, coordinatorFactory: self)
    }

    func makeEntryCoordinator(router: Router) -> Coordinator & EntryCoordinatorOutput {
        let factory = ModuleFactoryImp()
        factory.networkDispatcher = networkDispatcher
        return EntryCoordinator(router: router, factory: factory, coordinatorFactory: self)
    }
}
```

So what is happening here is that we define our networkDispatcher variable, then create implement our functions
to return the coordinators for each module within our app. Within our functions we create a
module factory using `ModuleFactoryImp()`, setting the networkDispatcher, and then returning coordinator
for the respective module.

## ModuleFactoryImp

Taking a look inside our `ModuleFactoryImp` class, we see that it extends the protocols for each module
of our application. You can break module factory down even more if your application is more complex, but for the
sake of this demo, we just use one moduleFactoryImp to cover all our modules.

```swift
final class ModuleFactoryImp: HomeModuleFactory, EntryModuleFactory {

    var networkDispatcher: NetworkDispatcher?

    func makeHomeScreenOutput() -> HomeView {
        let controller = HomeController.controllerFromStoryboard(.home)
        return controller
    }

    func makeLoginScreenOutput() -> LoginView {
        let controller = LoginController.controllerFromStoryboard(.login)
        controller.entryService = EntryService(with: networkDispatcher!)
        return controller
    }
}
```

As you can see the each of our functions returns an instance of a viewController. We are getting the controller view
from the storyboard so if you take a look inside the `Home.storyboard` you will see that the storyboard ID for our controller
is HomeController. Make sure this is set when you add future pages, otherwise this will error.

Notice how in the `makeLoginScrenOutput()` function we are setting the entryService variable of the controller. This is how we
pass in our networkDispatcher to our controller so that we can use it within said controller. This allows us to reuse objects across
our app without having to recreate and/or use extra memory.
