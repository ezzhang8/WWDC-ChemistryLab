//
//  Main.xcplaygroundpage
//  ChemistryLab
//
//  Created by Eric Zhang on 2021-04-17.
//

import PlaygroundSupport
import SwiftUI

//: To see most of the source code for this playground, see MainSupport.swift in Sources
struct ContentView: View {
    var body: some View {
        HomePageView()
    }
}

//: Sets playground size to 800x600
let viewController = UIHostingController(rootView: ContentView().frame(width: Window.x, height: Window.y))

PlaygroundPage.current.liveView = viewController
PlaygroundPage.current.needsIndefiniteExecution = true

/*:
 External media credits:
 These images/models I used to save time and make my views more appealing, which also allowed me to spend more time with programming in Swift for this project.
 
 beaker.png: https://dryicons.com/icon/beaker-icon-5765
 Used as the home page icon
 
 balloon.png:
 Public domain, tinted different colors in the playground for different elements
 
 chem.db: Original work
 
 mercury.png:
 Modified, public domain image, used for Gallium, Mercury, and Caesium elements
 
 nuclear.png:
 Straight from Wikimedia Commons, public domain, used to represent radioactive elements.
 
 powder.png:
 https://www.pngkey.com/maxpic/u2t4r5i1i1w7u2a9/
 Tinted to represent sulfur and phosphorus.
 
 smoke.png:
 Public domain, used for representing the halogens.
 
 metal.usdz:
 https://www.turbosquid.com/3d-models/3d-rock-cliff-model-1623382
 Licensed under the TurboSquid 3D Model License. Originally a .obj file, but converted to a .usdz file using the command line usdzconvert tool.
 
 diamond.usdz:
 https://www.turbosquid.com/3d-models/free-perfect-model/675252
 Licensed under the TurboSquid 3D Model License. Originally a .obj file, but converted to a .usdz file using the command line usdzconvert tool.

I included these third-party models so I could more time on the playground rather than 3D modelling.
 
 
 ]*/
