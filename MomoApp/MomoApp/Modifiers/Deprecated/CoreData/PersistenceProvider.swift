////
////  PersistenceProvider.swift
////  MomoApp
////
////  Created by Priscilla Ip on 2021-02-08.
////
//
//import Foundation
//import CoreData
//
//final class PersistenceProvider {
//    let persistentContainer: NSPersistentContainer
//    var context: NSManagedObjectContext { persistentContainer.viewContext }
//
//    static let `default`: PersistenceProvider = PersistenceProvider()
//    init() {
//        persistentContainer = NSPersistentContainer(name: "MomoApp")
//        persistentContainer.loadPersistentStores(completionHandler: { _, error in
//            if let error = error {
//                fatalError("An error occurred while insantiating persistentContainer: \(error.localizedDescription)")
//            }
//        })
//    }
//}
