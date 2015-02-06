//
//  CatalogView.h
//  tuangouproject
//
//  Created by stcui on 14-1-1.
//
//

#import <UIKit/UIKit.h>

@protocol CatalogViewDelegate;

@interface CatalogView : UIView
@property (strong, nonatomic) NSArray *items;
@property (assign, nonatomic) id<CatalogViewDelegate> delegate;
/**
 @para items @[<image>, <title>]
 */
- (void)setItems:(NSArray *)items;
@end


@protocol CatalogViewDelegate <NSObject>
- (void)catalogView:(CatalogView *)view didItem:(NSArray *)item index:(NSInteger)index;
@end