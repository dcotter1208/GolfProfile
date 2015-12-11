//
//  DataManager.swift
//  TopApps
//
//  Created by Dani Arnaout on 9/2/14.
//  Edited by Eric Cerney on 9/27/14.
//  Copyright (c) 2014 Ray Wenderlich All rights reserved.
//

import Foundation

class DataManager {
  
  class func getGolfCoursesFromFileWithSuccess(success: ((data: NSData) -> Void)) {
    //1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
      //2
      let filePath = NSBundle.mainBundle().pathForResource("golfCourseData",ofType:"json")
   
      var readError:NSError?
      do {
        let data = try NSData(contentsOfFile:filePath!,
          options: NSDataReadingOptions.DataReadingUncached)
        success(data: data)
      } catch let error as NSError {
        readError = error
      } catch {
        fatalError()
      }
    })
  }

}