//
//  LingScrollView.h
//  000-tableview滚动遮住顶部按钮
//
//  Created by Tom-Li on 2019/4/29.
//  Copyright © 2019 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

//NS_ASSUME_NONNULL_BEGIN

typedef void(^NavBlock)(CGFloat);

@interface LingScrollView : UIView
- (instancetype)initWithFrame:(CGRect)frame withBlock:(NavBlock)navBlock;
@end

//NS_ASSUME_NONNULL_END
