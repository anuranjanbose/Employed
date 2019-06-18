//
//  SaveAnnotation.swift
//  Employed
//
//  Created by Anuranjan Bose on 17/06/19.
//  Copyright © 2019 Anuranjan Bose. All rights reserved.
//

import Foundation


import CoreData
import UIKit

protocol SaveAnnotation
{
    //declaration
    func addData(name : String , longitude : Double , latitude : Double)
}

extension SaveAnnotation {
    // defination of addData and saves the data in Database
    func addData(name : String , longitude : Double , latitude : Double) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Annotation", in: context)
        let annotations = NSManagedObject(entity: entity!, insertInto: context)
        annotations.setValue(name , forKey: "name")
        annotations.setValue(longitude , forKey: "longitude")
        annotations.setValue(latitude , forKey: "latitude")
        do
        {
            try context.save()
        }catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}