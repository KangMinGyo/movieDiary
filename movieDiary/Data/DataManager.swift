//
//  DataManager.swift
//  movieDiary
//
//  Created by KangMingyo on 2022/07/03.
//

import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
    private init() {
        //Singleton
        
    }
    
    var mainContenxt: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var movieReviewList = [Review]()
    
    func fetchReview() {
        let request: NSFetchRequest<Review> = Review.fetchRequest()
        
        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        do {
            movieReviewList = try mainContenxt.fetch(request)
        } catch {
            print(error)
        }
    }
    
    func addNewReview(_ review: String?, _ title: String?, _ info: String?, _ star: Float?, _ eval: String?) {
        let newReview = Review(context: mainContenxt)
        newReview.content = review
        newReview.insertDate = Date()
        newReview.title = title
        newReview.movieInfo = info
        newReview.star = star ?? 0.0
        newReview.eval = eval
        
        movieReviewList.insert(newReview, at: 0)
        
        saveContext()
    }
    
    func deleteReview(_ review: Review?) {
        if let review = review {
            mainContenxt.delete(review)
            saveContext()
        }
    }
    
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "movieDiary")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
