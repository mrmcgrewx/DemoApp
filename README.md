# bare-bone-app
An example app that uses an app coordinator to separate navigation logic from view controllers.

In todays world no application ever stays the same as it grows over time, and this is no different for ios applications.
This app demonstrates the use of an app coordinator design pattern and network distpatcher.

# App Coordinator
The general idea of the app coordinator pattern is to decouple navigation logic from your view controllers. As much of a fan 
as I am of storyboard segues, depending on your implementation they may come back to bite you when you decide to upgrade 
the workflow of your application.

The idea is, 1) you define a protocol for the view for the required navigation functions, for example:

```swift
protocol YourView: NSObjectProtocol, Presentable {
    var onSettingsButtonTap: (() -> Void)? { get set }
    var onMenuButtonTap: (() -> Void)? { get set }
    var onDisplayUserDataButtonTap: ((String) -> Void)? { get set }
}
```

Cool, so now that you have your protocol 2) you need to require it within a factory. In this implementation you will notice that
the factories are split up by storyboards. While this is not necessary it helps keep your flows organized.
So lets say we want to add the `YourView` protocol to the existing barebone app. For this example we will add it to our
`HomeModuleFactory` protocol like so:

```swift
protocol HomeModuleFactory {
    func makeHomeScreenOutput() -> HomeView
    func makeYourViewScreenOutput() -> YourView //This is the line we added
}
```

Awesome. Now with the function added, 3) you need to implement the function. Before implementing the function make sure
that you have YourView controller already defined and ready to go in your home storyboard. Once that is setup, navigate to the `ModuleFactoryImp` class and
implement the function like so:

```swift
func makeYourViewScreenOutput() -> YourView {
        let controller = YourView.controllerFromStoryboard(.home)
        return controller
    }
```
This is also where you would pass in any universal app data, such as userInfo or the network dispatcher if you needed to
make calls to an external api from the view controller (an example is in this app).


So because we implemented our YourView in the HomeModule, we will now create a function in our `HomeCoordinator` class to
create this controller view, like so:

```swift
private func showYourView() {
        let yourViewOutput = factory.makeYourViewScreenOutput()
        yourViewOutput.onSettingsButtonTap = { [weak self] in
            self?.changeToSettings()
        }
        yourViewOutput.onMenuButtonTap = { [weak self] in
            self?.changeToMenu()
        }
        yourViewOutput.onSettingsButtonTap = { [weak self] user in
            self?.onDisplayUserDataButtonTap(with: user)
        }
        
        router.setRootModule(homeScreenOutput, hideBar: false, animated: true)
}
```
So in this example with our router we set the view as our root module, but you could easily just push the view onto the stack 
if desired.

And that is pretty much the jist of it. I'm assuming that you have a decent enough knowledge of swift to know how to implement
this navigation function into the view controller.

# Network Dispatcher
The network dispatcher handles all the networking, so we dont have to create URLSessions all the time, just reuse the same one
throughout the application.

To set the url endpoint, simply go the to app coordinator and modify:

```swift
private func makeNetworkDispatcher() -> NetworkDispatcher {
        let environment = Environment("prod", host: "http://localhost.com" )
        return NetworkDispatcher(environment: environment)
    }
```

Take a look inside the API folder to see how to setup url endpoints and pass data to and from a server.


Any questions feel free to ask.

![Image](https://s3-us-west-2.amazonaws.com/public-mcgrew/screenshot.png)
