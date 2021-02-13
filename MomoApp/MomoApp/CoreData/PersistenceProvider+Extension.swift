////
////  PersistenceProvider+Extension.swift
////  MomoApp
////
////  Created by Priscilla Ip on 2021-02-08.
////
//
//import SwiftUI
//import CoreData
//
//extension PersistenceProvider {
//
//    // let entries = try! context.fetch(entryRequest)
//
//    var entryRequest: NSFetchRequest<Entry> {
//        let request: NSFetchRequest<Entry> = Entry.fetchRequest()
//        request.sortDescriptors = [
//            NSSortDescriptor(keyPath: \Entry.date, ascending: false)
//        ]
//        return request
//    }
//
//    @discardableResult
//    func createEntry(with emotion: String, value: CGFloat) -> Entry {
//        let entry = Entry(context: context)
//        entry.id = UUID()
//        entry.date = Date()
//        entry.emotion = emotion
//        entry.value = Float(value) // TODO: Fix this conversion
//        try? context.save()
//        return entry
//    }
//
//    func updateEntry(_ entry: Entry, emotion: String, value: CGFloat) {
//        entry.emotion = emotion
//        entry.value = Float(value)
//        try? context.save()
//    }
//
//    func deleteEntry(_ entry: Entry) {
//        context.delete(entry)
//        try? context.save()
//    }
//}
