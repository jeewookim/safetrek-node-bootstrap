//
//  FirstViewController.swift
//  Safetrek
//
//  Created by Daniel Ju on 3/24/18.
//  Copyright © 2018 Daniel Ju. All rights reserved.
//

import UIKit
import CoreMotion

class FirstViewController: UIViewController {

    lazy var motionManager = CMMotionManager()
    var xDir: Double!
    var yDir: Double!
    var zDir: Double!
    
    @IBOutlet weak var xLabel: UILabel!
    @IBOutlet weak var yLabel: UILabel!
    @IBOutlet weak var zLabel: UILabel!
    
    @IBAction func startAccel(_ sender: UIButton) {
        print("hello")
        if motionManager.isAccelerometerAvailable{
            let queue = OperationQueue()
            motionManager.startAccelerometerUpdates(to: queue, withHandler:
                {data, error in
                    
                    guard let data = data else {
                        return
                    }
                    
                    print("X = \(data.acceleration.x)")
                    print("Y = \(data.acceleration.y)")
                    print("Z = \(data.acceleration.z)")
                    self.xDir = data.acceleration.x
                    self.yDir = data.acceleration.y
                    self.zDir = data.acceleration.z
            }
            )
        }
        else {
            print("Accelerometer is not available")
        }
    }
    
    @IBAction func checkDeviceRotation(_ sender: UIButton) {
        // Helper function to update the screen.  No edits needed.
        xLabel.text = "X = " + String(xDir)
        yLabel.text = "Y = " + String(yDir)
        zLabel.text = "Z = " + String(zDir)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
