//
//  SWKeyboardEventResizer.h
//
//  Created by  na on .
//
//

#import <Foundation/Foundation.h>

@protocol KeyboardEventResizerDelegate;

@interface KeyboardEventResizer : NSObject
@property (unsafe_unretained, nonatomic) UIView *contentView;
- (id)initWithContentView:(UIView *)contentView;
@end

@protocol KeyboardEventResizerDelegate <NSObject>
- (void)resizerDidShrink:(KeyboardEventResizer *)resizer;
@end