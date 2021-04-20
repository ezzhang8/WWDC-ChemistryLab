//
//  MainSupport.swift
//  ChemistryLab
//
//  Created by Eric Zhang on 2021-04-17.
//

import Foundation
import SQLite3
import SwiftUI
import PlaygroundSupport
import SceneKit

// Struct for storing element data once taken from the database
public struct Element: Identifiable, Hashable {
    public let id: Int
    public let name: String
    public let symbol: String
    public let desc: String
    public let state: Int
    public let melting: Double?
    public let boiling: Double?
    public let group: Int
    public let family: String
    public let mass: Double
    public let image: String?
    public let colors: [String]?
    
    // Matching element types to colors
    public static let colors = [
        "Nonmetal": Color.orange,
        "Alkali Metal": Color.red,
        "Alkaline Earth Metal": Color.pink,
        "Transition Metal": Color.blue,
        "Post-Transition Metal": Color(red: 0.26, green: 0.53, blue: 0.96),
        "Noble Gas": Color.purple,
        "Metalloid": Color.black,
        "Radioactive": Color(red: 0.43, green: 0.75, blue: 0.32),
        "Lanthanide": Color.green,
        "Actinide": Color(red: 0.88, green: 0.84, blue: 0.09)
    ]
}

// Class to help with convert temperature units
private class Temperature {
    static func convert(to: Int, from: Double) -> String {
        switch(to) {
            case 1:
                return String("\(round(from*(9/5) + 32)) °F")
            case 2:
                return String("\(round(from + 273.15)) K")
            default:
                return String("\(from) °C")
        }
    }
}

// SwiftUI view for viewing data about an element
struct ElementDetails: View {
    let element: Element
    
    @State var units = 0
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Button(action: {
                        PlaygroundPage.current.setLiveView(PeriodicTableView().frame(width: Window.x, height: Window.y))
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .scaledToFit()
                                .frame(width: 20)
                            Text("Back")
                        }
                    }
                    .padding([.top, .leading], 10)
                    Text(element.name)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(Element.colors[element.family])
                        .padding(10)
                    
                    VStack(alignment: .leading) {
                        if element.image?.suffix(4) == "usdz" {
                            // Show a 3D model where applicable
                            SceneView(scene: SCNScene(named: element.image!, inDirectory: "Objects"), options: [.autoenablesDefaultLighting,.allowsCameraControl])
                                .frame(width: 350 , height: 350)
                        }
                        else if element.image?.suffix(3) == "png" {
                            // Show an image with chemical symbol otherwise
                            ZStack {
                                Image(uiImage: UIImage(named: element.image!) ?? UIImage())
                                    .resizable()
                                    .colorMultiply(Color(red: (element.colors![0] as NSString).doubleValue/255, green: (element.colors![1] as NSString).doubleValue/255, blue: (element.colors![2] as NSString).doubleValue/255))
                                    .frame(width: 350, height: 350)
                                    .scaledToFit()
                                Text(element.symbol)
                                    .font(.system(size: 96, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                        }
                        // A lot of elements look similar, so most are retextures of a few common shapes
                    }
                    .padding(.leading, 15)
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    VStack {
                        VStack {
                            HStack {
                                Text("Element #" + String(element.id))
                                Spacer()
                            }
                            Text(element.symbol)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            
                            Text("Atomic Mass: "+String(element.mass).prefix(5))
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                            
                            HStack(spacing: 10){
                                VStack {
                                    Text(element.family)
                                        .font(.system(size: 12, weight: .semibold, design: .rounded))
                                        .foregroundColor(.white)

                                }
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .background(Element.colors[element.family])
                                .clipShape(Capsule())

                                
                                if (element.group == 17) {
                                    VStack {
                                        Text("Halogen")
                                            .font(.system(size: 12, weight: .semibold, design: .rounded))

                                    }
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 10)
                                    .background(Color.yellow)
                                    .clipShape(Capsule())

                                }
                                else if (element.family == "Actinide") {
                                    VStack {
                                        Text("Radioactive")
                                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                                            .foregroundColor(.white)

                                    }
                                    .padding(.vertical, 5)
                                    .padding(.horizontal, 10)
                                    .background(Element.colors["Radioactive"])
                                    .clipShape(Capsule())

                                }
                            }
                            

                        }
                        .padding(15)
                        .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                        .cornerRadius(10)
                        if (element.melting != nil || element.boiling != nil) {
                            VStack {
                                Picker(selection: $units, label: Text("Temperature Units")) {
                                    Text("Celsius").tag(0)
                                    Text("Fahrenheit").tag(1)
                                    Text("Kelvin").tag(2)
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                VStack(alignment: .leading) {
                                    if element.melting != nil {
                                        HStack {
                                            Text("Melting point: ")
                                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                            Text(Temperature.convert(to: units, from: element.melting!))
                                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                        }
                                    }
                                    if element.boiling != nil {
                                        HStack {
                                            Text("Boiling point: ")
                                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                            Text(Temperature.convert(to: units, from: element.boiling!))
                                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                        }

                                    }
                                }
                                .padding(15)
                            }
                            .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.trailing, 75)

                }
                Spacer()
            }
            VStack {
                Text(element.desc)
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(15)

            }
            .background(Color(red: 0.9, green: 0.9, blue: 0.9))
            .cornerRadius(15)
            .padding(.trailing, 55)
            .padding([.leading, .top, .bottom], 20)

        }
    }
}

// A square on the periodic table that is also a button that leads to a view about that element
struct PeriodicButton: View {
    let element: Element

    var body: some View {
        Button(action: {
            PlaygroundPage.current.setLiveView(ElementDetails(element: element).frame(width: Window.x, height: Window.y))
        }) {
            VStack {
                HStack {
                    Text(String(element.id))
                        .font(.system(size: 8, weight: .semibold, design: .rounded))
                        .padding(.leading, 5)
                    Spacer()
                }
                Text(element.symbol)
                    .font(.system(size: 12, weight: .bold, design: .rounded))

                Text(String(element.mass))
                    .font(.system(size: 8, weight: .semibold, design: .rounded))

            }
            .frame(width: 30, height: 38)
            .background(Element.colors[element.family])
            .cornerRadius(5)
            .padding(0.1)

        }
        .foregroundColor(.white)
    }
}

// The home view shown on startup
public struct HomePageView: View {
    public init() {}
    
    public var body: some View {
        VStack {
            Image(uiImage: UIImage(named: "beaker.png") ?? UIImage())
                .resizable()
                .frame(width: 200, height: 200)
                .scaledToFit()
            Text("Welcome to ChemistryLab")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .padding(.top, 10)
            Text("Learn about the 118 elements of the periodic table, or take a quiz to see how much you know.")
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .padding(.horizontal, 200)
                .padding(.bottom, 30)
                .multilineTextAlignment(.center)
            
            Button(action: {
                PlaygroundPage.current.setLiveView(PeriodicTableView().frame(width: Window.x, height: Window.y))
            }) {
                HStack {
                    Image(systemName: "rectangle.grid.3x2.fill")
                        .frame(width: 20)
                        .scaledToFit()
                    Text("Periodic Table")
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 15)

                .foregroundColor(.black)
                .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                .clipShape(Capsule())
                
            }
            
            Button(action: {
                PlaygroundPage.current.setLiveView(TestView().frame(width: Window.x, height: Window.y))
            }) {
                HStack {
                    Image(systemName: "questionmark.diamond.fill")
                        .frame(width: 20)
                        .scaledToFit()
                    Text("Elements Test")
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 15)

                .foregroundColor(.black)
                .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                .clipShape(Capsule())

            }

        }
    }
}

// Generating the periodic table, taking advantage of periods and alignment
struct PeriodicTableView: View {
    let db = Database.open(name: "chem")

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    PlaygroundPage.current.setLiveView(HomePageView().frame(width: Window.x, height: Window.y))
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .scaledToFit()
                            .frame(width: 20)
                        Text("Back")
                    }
                }
                .padding(.leading, 10)
                Spacer()
            }
            
            Text("Periodic Table of Elements")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .padding(10)
            Text("Select an element")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .padding(.bottom, 10)

            HStack(alignment: .bottom) {
                // Generate groups 1 through 18
                ForEach(1..<19) {i in
                    VStack {
                        ForEach(Database.getElements(group: i, db: db!), id: \.self) { element in
                            PeriodicButton(element: element)
                        }
                    }
                }
            }
            Spacer().frame(height: 20)
            // Generate the lanthanides and actinides
            ForEach(19..<21) { i in
                HStack {
                    ForEach(Database.getElements(group: i, db: db!), id: \.self) { element in
                        PeriodicButton(element: element)
                    }
                }
            }

        }
        .padding(.trailing, 35)
    }
}

// The view that tests the user on a random element
struct TestView: View {
    let elements = Database.getRandomElements(db: Database.open(name: "chem")!, amnt: 4)
    var redacted: String
    let answer: Element
    let options = ["a", "b", "c", "d"]
    
    @State var selected: Int? = nil
    @State var answered: Bool = false
    
    init() {
        self.answer = elements[Int.random(in: 0..<4)]
        self.redacted = answer.desc.replacingOccurrences(of: answer.name, with: "??????")
        self.redacted = self.redacted.replacingOccurrences(of: answer.name.lowercased(), with: "??????")
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    PlaygroundPage.current.setLiveView(HomePageView().frame(width: Window.x, height: Window.y))
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .scaledToFit()
                            .frame(width: 20)
                        Text("Back")
                    }
                }
                .padding([.leading, .top], 15)
                Spacer()
            }

            Text("What element does this describe?")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .padding(10)
            
          
            
            VStack {
                Text(redacted)
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding(15)

            }
            .background(Color(red: 0.9, green: 0.9, blue: 0.9))
            .cornerRadius(15)
            .padding(.trailing, 55)
            .padding([.leading, .top, .bottom], 20)
            
            VStack {
                ForEach(0..<4) { i in
                    Button(action: {
                        if answered == false {
                            self.selected = i
                            answered = true
                        }
                    }) {
                        HStack {
                            Image(systemName: options[i]+".circle.fill")
                                .frame(width: 20)
                                .scaledToFit()
                            Text(elements[i].name)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 15)

                        .foregroundColor(.black)
                        .background((selected == i) ? Color(red: 0.5, green: 0.67, blue: 0.96) : Color(red: 0.9, green: 0.9, blue: 0.9))
                        .clipShape(Capsule())

                    }
                    
                }
            }
            .padding(.trailing, 15)
            if selected != nil  {
                if elements[selected!].name == answer.name {
                    VStack {
                        VStack {
                            Text("You're correct!")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.center)
                                .padding(7)
                                .foregroundColor(.white)
                            
                            Button(action: {
                                PlaygroundPage.current.setLiveView(TestView().frame(width: Window.x, height: Window.y))
                            }) {
                                HStack {
                                    Image(systemName: "arrow.uturn.right")
                                        .scaledToFit()
                                        .frame(width: 20)
                                    Text("New Question")
                                }
                            }
                            .foregroundColor(.white)
                            .padding(15)
                        }
                        .padding(10)
                    }
                    .background(Color(red: 0.2, green: 0.8, blue: 0.2))
                    .cornerRadius(15)
                    .padding(.trailing, 65)
                    .padding([.leading, .top, .bottom], 30)

                }
                else {
                    VStack {
                        VStack {
                            Text("You're incorrect...")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.center)
                                .padding(4)
                                .foregroundColor(.white)
                            Text("The correct answer was "+answer.name+".")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 5)
                                .foregroundColor(.white)

                            
                            Button(action: {
                                PlaygroundPage.current.setLiveView(TestView().frame(width: Window.x, height: Window.y))
                            }) {
                                HStack {
                                    Image(systemName: "arrow.uturn.right")
                                        .scaledToFit()
                                        .frame(width: 20)
                                    Text("New Question")
                                }
                            }
                            .foregroundColor(.white)
                            .padding(15)

                        }
                        .padding(10)
                    }
                    .background(Color(red: 0.8, green: 0.2, blue: 0.2))
                    .cornerRadius(15)
                    .padding(.trailing, 65)
                    .padding([.leading, .top, .bottom], 30)

                }
            }
            Spacer()
        }
    }
}

public class Database {
    
    public init() {}
    
    // Private helper method to turn SQLite data into a usable struct for displaying information to the user
    private static func handleResult(query: OpaquePointer) -> Element {
        let id = Int(sqlite3_column_int(query, 0))
        let name = String(cString: sqlite3_column_text(query, 1)!)
        let symbol = String(cString: sqlite3_column_text(query, 2)!)
        let desc = String(cString: sqlite3_column_text(query, 3)!)
        let state = Int(sqlite3_column_int(query, 4))
        var melting: Double? = sqlite3_column_double(query, 5)
        var boiling: Double? = sqlite3_column_double(query, 6)
        let colorText = sqlite3_column_text(query, 7)
        let imageText = sqlite3_column_text(query, 8)
        let group = Int(sqlite3_column_int(query, 9))
        let family = String(cString: sqlite3_column_text(query, 10)!)
        let mass = sqlite3_column_double(query, 11)

        let image: String? = imageText == nil ? nil : String(cString: imageText!)
        let colors: [String]? = colorText == nil ? nil : String(cString: colorText!).components(separatedBy: ", ")

        if melting == 0.0 {
            melting = nil
        }
        if boiling == 0.0 {
            boiling = nil
        }
      
        let element = Element(id: id, name: name, symbol: symbol, desc: desc, state: state, melting: melting, boiling: boiling, group: group, family: family, mass: mass, image: image, colors: colors)

        return element
    }
    
    // Pulls all elements for a given group, useful for generating the periodic table with SwiftUI
    public static func getElements(group: Int, db: OpaquePointer) -> [Element] {
        let statement = "SELECT * FROM elements WHERE groups=\(group);"
        var array = [Element]()
        var query: OpaquePointer?
        if sqlite3_prepare_v2(db, statement, -1, &query, nil) == SQLITE_OK {
            while(sqlite3_step(query) == SQLITE_ROW) {
                array.append(handleResult(query: query!))
            }
        }
        else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\nQuery is not prepared \(errorMessage)")
        }
        sqlite3_finalize(query)
        
        return array
    }
    public static func getRandomElements(db: OpaquePointer, amnt: Int) -> [Element] {
        var array = [Element]()
        var nums = [Int]()
        
        // Generate amnt unique atomic numbers between 1 and 94 inclusive
        while nums.count < amnt {
            let num = Int.random(in: 1..<95)
            
            if !nums.contains(num) {
                nums.append(num)
            }
        }
        
        // Pull elements out of the database
        for num in nums {
            let statement = "SELECT * FROM elements WHERE num=\(num);"
            var query: OpaquePointer?

            if sqlite3_prepare_v2(db, statement, -1, &query, nil) == SQLITE_OK {
                while (sqlite3_step(query) == SQLITE_ROW) {
                    let element = handleResult(query: query!)
                    
                    array.append(element)
                }
            }
            else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\nQuery is not prepared \(errorMessage)")
            }
            sqlite3_finalize(query)

        }
        
        return array
    }
    // Opens a connection to the SQLite database
    public static func open(name: String) -> OpaquePointer? {
        var db: OpaquePointer?
        let path = Bundle.main.path(forResource: name, ofType: "db")
        
        if sqlite3_open(path, &db) == SQLITE_OK {
            return db
        } else {
            return nil
        }
    }
}

// Set screen resolution to 800x600
public class Window {
    public static let x: CGFloat = 800
    public static let y: CGFloat = 600
}
