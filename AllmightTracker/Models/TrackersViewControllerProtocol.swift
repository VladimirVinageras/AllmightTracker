//
//  TrackersViewControllerProtocol.swift
//  AllmightTracker
//
//  Created by Vladimir Vinakheras on 22.05.2024.
//

import Foundation
import UIKit

protocol TrackersViewControllerProtocol{
    func createNewCategory()
    func createNewEvent()
    func createNewSchedule()
    func markEventAsCompleted()
    
    //pensar en como manejar los datos ))
    //crear variables de protocolo en otras clases y acceder a los datos a traves de el 
}
