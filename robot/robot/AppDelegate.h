//
//  AppDelegate.h
//  robot
//
//  Created by 毛韶谦 on 2017/3/16.
//  Copyright © 2017年 毛韶谦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

