//
//  ImageCacheTest.swift
//  SquareEmployeeDirectoryTests
//
//  Created by Angelina Wu on 31/01/2021.
//

import XCTest
@testable import SquareEmployeeDirectory

class ImageCacheTest: XCTestCase {

    let imageCache = ImageCache.shared
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        imageCache.removeAllKey()
    }

    func testWriteToDisk() {
        imageCache.writeCacheToDisk()
        guard let cacheURL = imageCache.getCacheFileNameURL() else {
            XCTFail("URL for cache file is nil")
            return
        }
        XCTAssert(FileManager.default.fileExists(atPath: cacheURL.path), "Cache is not written successfully")
    }
    
    func testReadFromDisk() {
        imageCache["some random key here"] = UIImage()
        imageCache.writeCacheToDisk()
        imageCache.resurrectCache()
        XCTAssertNotNil(imageCache["some random key here"])
    }
    
    func testRemoveCacheFile() {
        imageCache.writeCacheToDisk()
        guard let cacheURL = imageCache.getCacheFileNameURL() else {
            XCTFail("URL for cache file is nil")
            return
        }
        XCTAssert(FileManager.default.fileExists(atPath: cacheURL.path), "Cache is not written successfully")
        imageCache.removeCacheFile()
        XCTAssertFalse(FileManager.default.fileExists(atPath: cacheURL.path), "Cache is not written successfully")
    }
    
    func testFetchFromCache() {
        imageCache["http://www.google.com"] = UIImage()
        guard let url = URL(string: "http://www.google.com") else {
            XCTFail("Fail creating a URL")
            return
        }
        imageCache.fetch(from: url, completionIfExist: { image in
            // success, do nothing, return.
            return
        }, whileFetching: {
            XCTFail("The image is supposed to be already in the cache.")
            return
        }, completionAfterFetch: { image in
            XCTFail("The image is supposed to be already in the cache.")
            return
        }, completionIfFailed: { error in
            XCTFail("The image is supposed to be already in the cache.")
            return
        })
    }
    
    func testFetchFromURL() {
        imageCache.removeAllKey()
        guard let url = URL(string: "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/small.jpg") else {
            XCTFail("Fail creating a URL")
            return
        }
        imageCache.fetch(from: url, completionIfExist: { image in
            XCTFail("The image is not supposed to be already in the cache.")
            return
        }, whileFetching: {
            // great, do nothing
            return
        }, completionAfterFetch: { image in
            // great, do nothing
            return
        }, completionIfFailed: { error in
            // well, not good that it failed, but it is trying to fetch.
            return
        })
    }
    
    func testFetchFromURLFail() {
        imageCache.remove(key: "https://s3.amazonaws.com/sq-mobile-interview123/something.jpg")
        guard let url = URL(string: "https://s3.amazonaws.com/sq-mobile-interview123/something.jpg") else {
            XCTFail("Fail creating a URL")
            return
        }
        imageCache.fetch(from: url, completionIfExist: { image in
            XCTFail("The image is not supposed to be already in the cache.")
            return
        }, whileFetching: {
            // great, do nothing
            return
        }, completionAfterFetch: { image in
            XCTFail("The image shouldn't have existed")
            return
        }, completionIfFailed: { error in
            // well, we do want it to fail.
            return
        })
    }
    
    func testUIImageCreateFromString() {
        let image = UIImage.generate(with: "HELLO")
        XCTAssertNotNil(image)
        XCTAssertEqual(image?.size.height ?? 0.0, 250)
        XCTAssertEqual(image?.size.width ?? 0.0, 250)
    }
}
