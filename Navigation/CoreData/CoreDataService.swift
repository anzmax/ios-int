import CoreData
import UIKit

class CoreDataService {
    
    static let shared = CoreDataService()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: .dataName)
        container.loadPersistentStores { description, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        return container
        
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
                assertionFailure("Saving error")
            }
        }
    }
    
    func addPostToFavorites(post: Post) {
        let context = persistentContainer.viewContext
        let postModel = PostModel(context: context)
        
        postModel.author = post.author
        postModel.descriptionText = post.description
        postModel.imageData = post.image
        postModel.likes = Int32(post.likes)
        postModel.views = Int32(post.views)
        
        saveContext()
    }
    
    func fetchFavoritePosts() -> [Post] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PostModel> = PostModel.fetchRequest()
        
        do {
            let postModels = try context.fetch(fetchRequest)
            return postModels.map { postModel in
                Post(author: postModel.author ?? "",
                     description: postModel.descriptionText ?? "",
                     image: postModel.imageData ?? "",
                     likes: Int(postModel.likes),
                     views: Int(postModel.views))
            }
        } catch {
            print("Ошибка при извлечении избранных постов: \(error)")
            return []
        }
    }
    
    func deleteFavoritePost(post: Post) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<PostModel> = PostModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "author == %@ AND descriptionText == %@", post.author, post.description)
        
        do {
            let postModels = try context.fetch(fetchRequest)
            if let postModelToDelete = postModels.first {
                context.delete(postModelToDelete)
                saveContext()
            }
        } catch {
            print("Ошибка при удалении избранного поста: \(error)")
        }
    }
}

extension String {
    static let dataName = "PostModel"
}
