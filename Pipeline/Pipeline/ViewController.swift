//

import Cocoa
import MetalKit

//The ViewController class contains a property renderer of type Renderer?, which will be responsible for rendering graphics using Metal.
//The viewDidLoad() method is called when the view controller's view is loaded into memory. In this method, the code checks if the view is an instance of MTKView (a Metal-enabled view) and assigns it to the metalView constant.
//If the view is not an instance of MTKView, a fatal error is triggered with a message indicating that the metal view is not set up correctly in the storyboard.
//If the view is an MTKView, an instance of the Renderer class is created and assigned to the renderer property. This initializes the Metal renderer with the MTKView as a parameter, allowing it to perform rendering operations.

class ViewController: NSViewController {
  
  var renderer: Renderer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let metalView = view as? MTKView else {
      fatalError("metal view not set up in storyboard")
    }
    renderer = Renderer(metalView: metalView)
  }
}
