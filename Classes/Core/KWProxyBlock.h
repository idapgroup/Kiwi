//
//  KWProxyBlock.h
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/18/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import <Foundation/NSObject.h>

@interface KWProxyBlock : NSObject <NSCopying>

+ (id)blockWithBlock:(id)block;

- (id)initWithBlock:(id)block;

@end
