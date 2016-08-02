//
//  Node.m
//  TreeTableView
//
//  Created by yixiang on 15/7/3.
//  Copyright (c) 2015年 yixiang. All rights reserved.
//

#import "Node.h"

@implementation Node

- (instancetype)initWithParentId : (int)parentId nodeId : (int)nodeId name : (NSString *)name depth : (int)depth expand : (BOOL)expand {
    self = [self init];
    if (self) {
        self.parentId = parentId;
        self.nodeId = nodeId;
        self.name = name;
        self.depth = depth;
        self.expand = expand;
    }
    return self;
}
- (instancetype)initWithParentId : (int)parentId nodeId : (int)nodeId name : (NSString *)name depth : (int)depth expand : (BOOL)expand withSuperId:(int)superId withSubId:(int)subId{
    self = [self init];
    if (self) {
        self.parentId = parentId;
        self.nodeId = nodeId;
        self.name = name;
        self.depth = depth;
        self.expand = expand;
        self.superId=superId;
        self.subId=subId;

    }
    return self;
}
@end
