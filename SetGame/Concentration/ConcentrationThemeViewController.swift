//
//  ConcentrationThemeViewController.swift
//  SetGame
//
//  Created by Felipe Montoya on 3/6/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit

class ConcentrationThemeViewController: UIViewController {

    
    
    @IBAction func themeButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "Choose Theme", sender: sender)
    }
    
    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "Choose Theme" else { return }
            guard let cmvc = segue.destination as? ConcentrationMainViewController, let button = sender as? UIButton, let title = button.titleLabel?.text else { return }
                cmvc.game.reset()
                cmvc.theme = getThemeFor(string: title)
                cmvc.beginUpdates()
    }

}
