//
//  ViewController.swift
//  Colour Picker - Udacity NanoDegree Mini Project - iOS Developer
//
//  Created by Matthew Folbigg on 08/12/2020.
//

import UIKit

class ViewController: UIViewController {

    //MARK: IB Outlets
    @IBOutlet var redSlider : UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var colourView: UIView!
    
    @IBOutlet var redNumberLabel: UILabel!
    @IBOutlet var greenNumberLabel: UILabel!
    @IBOutlet var blueNumberLabel: UILabel!

    //MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    
    //MARK: Methods
    func updateUI() {
        updateColourView()
        updateSliderColour()
        updateNumberLabels()
    }
    
    func updateColourView() {
        let red = CGFloat(redSlider.value)
        let green = CGFloat(greenSlider.value)
        let blue = CGFloat(blueSlider.value)
        let colour = UIColor(displayP3Red: red, green: green, blue: blue, alpha: 1.0)
        colourView.backgroundColor = colour
    }
    
    func updateNumberLabels() {
        redNumberLabel.text = numberToDisplay(value: redSlider.value)
        greenNumberLabel.text = numberToDisplay(value: greenSlider.value)
        blueNumberLabel.text = numberToDisplay(value: blueSlider.value)
    }
    
    func numberToDisplay(value: Float) -> String {
        var numberString = String(value)
        while numberString.count > 4 {
            numberString.removeLast()
        }
        return numberString
    }
    
    func updateSliderColour() {
        redSlider.tintColor = UIColor(displayP3Red: 1, green: 0, blue: 0, alpha: CGFloat(redSlider.value))
        greenSlider.tintColor = UIColor(displayP3Red: 0, green: 1, blue: 0, alpha: CGFloat(greenSlider.value))
        blueSlider.tintColor = UIColor(displayP3Red: 0, green: 0, blue: 1, alpha: CGFloat(blueSlider.value))
    }
    
    
    //MARK: IB Actions
    @IBAction func sliderDidChangeValue(_ sender: UISlider) {
        updateUI()
    }

}

