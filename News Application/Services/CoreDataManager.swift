//
//  CoreDataManager.swift
//  News Application
//
//  Created by Assel Artykbay on 23.11.2024.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "News_Application")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    func likeArticle(link: String) {
        let fetchRequest: NSFetchRequest<Liked> = Liked.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "link == %@", link)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let likedEntity = results.first {
                // Update existing entity
                likedEntity.liked = true
            } else {
                // Create new entity
                let newLiked = Liked(context: context)
                newLiked.link = link
                newLiked.liked = true
            }
            saveContext()  // Ensure the context is saved
            print("Article liked successfully.")
        } catch {
            print("Failed to like article: \(error)")
        }
    }

    func unlikeArticle(link: String) {
        let fetchRequest: NSFetchRequest<Liked> = Liked.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "link == %@", link)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let likedEntity = results.first {
                // Update existing entity
                likedEntity.liked = false
                saveContext()  // Ensure the context is saved
                print("Article unliked successfully.")
            } else {
                print("Article not found to unlike.")
            }
        } catch {
            print("Failed to unlike article: \(error)")
        }
    }

    
    func isArticleLiked(link: String) -> Bool {
        let fetchRequest: NSFetchRequest<Liked> = Liked.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "link == %@", link)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first?.liked ?? false
        } catch {
            print("Failed to fetch article like status: \(error)")
            return false
        }
    }
}
