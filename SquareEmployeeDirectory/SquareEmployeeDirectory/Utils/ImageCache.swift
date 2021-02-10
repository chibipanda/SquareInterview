//
//  ImageCache.swift
//  SquareEmployeeDirectory
//
//  Created by Angelina Wu on 30/01/2021.
//

import Foundation
import UIKit

class ImageCache {
    // Pseudocache. I thought, it might be better for
    // testability and such if I put the dictionary into
    // a class, along with the method to write to disk and
    // read from file.
    // Names are hardcoded for now.
    final let CACHE_FILE_NAME = "employeePhotos.cache"
    
    // For now, just use a plain old dictionary. If we want to do something
    // fancy like expiring/deleting things that is no longer relevant,
    // we can put (timestamp, UIImage) as the value, that way, we can do a
    // LRU expiration style.
    private var imageCache = [String: UIImage]()
    
    // And we can make this whole thing singleton, since there should only
    // be one imageCache for the whole lot
    static var shared = ImageCache()
    private init() { }
    
    // And try to make the whole thing written to and read from
    // from the same queue since I did see one crash that I can't
    // reproduce anymore...
    private var queue = DispatchQueue(label: "ImageCacheQueue")
    
    func getCacheFileNameURL() -> URL? {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(CACHE_FILE_NAME)
    }
    
    // MARK: - Disk Operations
    func resurrectCache() {
        if let fileNameURL = getCacheFileNameURL() {
            do {
                let cacheData = try Data(contentsOf: fileNameURL)
                if let resurrected = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(cacheData) as? [String: UIImage] {
                    self.imageCache = resurrected
                }
            } catch {
                debugPrint("There is a problem reading the imageCache from file system. \(error)")
            }
        }
    }
    
    func writeCacheToDisk() {
        if let fileNameURL = getCacheFileNameURL() {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: self.imageCache, requiringSecureCoding: true)
                try data.write(to: fileNameURL, options: .atomic)
            } catch {
                debugPrint("There is a problem writing the image cache into file system. \(error)")
            }
        }
    }
    
    func removeCacheFile() {
        if let fileNameURL = getCacheFileNameURL() {
            do {
                try FileManager.default.removeItem(at: fileNameURL)
            } catch {
                debugPrint("There is a problem removing the image cache from the file system. \(error)")
            }
        }
    }
    
    // MARK: - Download things if needed
    func fetch(from url: URL, completionIfExist: ((UIImage) -> Void)? = nil, whileFetching: (() -> Void)? = nil, completionAfterFetch: ((UIImage)-> Void)? = nil, completionIfFailed: ((Error?)-> Void)? = nil) {
        if let image = imageCache[url.absoluteString] {
            completionIfExist?(image)
            return
        }
        // Otherwise, download, then save to cache
        whileFetching?()
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let downloadedImage = UIImage(data: data) {
                    self.imageCache[url.absoluteString] = downloadedImage
                    DispatchQueue.main.async {
                        completionAfterFetch?(downloadedImage)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completionIfFailed?(error)
                }
            }
        }.resume()
    }
    
    func remove(key: String) {
        queue.sync {
            _ = imageCache.removeValue(forKey: key)
        }
    }
    
    func removeAllKey() {
        queue.sync {
            imageCache.removeAll()
        }
    }
    
    // MARK: - Convenience subscripting
    subscript(index: String) -> UIImage? {
        get {
            queue.sync {
                return imageCache[index]
            }
        }
        set {
            queue.sync {
                imageCache[index] = newValue
            }
        }
    }
}
