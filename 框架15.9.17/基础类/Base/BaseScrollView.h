//
//  BaseScrollView.h
//  Eleven_frame
//
//  Created by 吕君 on 15/4/2.
//  Copyright (c) 2015年 eleven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseScrollView : UIScrollView{
    UIEdgeInsets    _priorInset;
    BOOL            _priorInsetSaved;
    BOOL            _keyboardVisible;
    CGRect          _keyboardRect;
    CGSize          _originalContentSize;
    CGFloat         _currentPointY;
}

- (void)adjustOffsetToIdealIfNeeded;

- (void)keyboardWillShow:(NSNotification*)notification;

- (void)keyboardWillHide:(NSNotification*)notification;
@end
