//
//  GRSprite.h
//  Gravity
//
//  Created by Daniel Rodríguez Troitiño on 17/04/09.
//  Copyright 2009 Daniel Rodríguez Troitiño. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Texture2D;

@interface GRSprite : NSObject {
 @protected
  Texture2D *texture_;
}

@property(nonatomic, assign) float posx;
@property(nonatomic, assign) float posy;

- (id)initWithFile:(NSString *)fileName;

- (void)draw;

@end
