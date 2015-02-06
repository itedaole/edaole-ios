//
//  SearhKeywordView.h
//  tuangouproject
//
//  Created by stcui on 14-3-26.
//
//

#import <UIKit/UIKit.h>

@protocol SearchKeywordViewDelegate;

@interface SearchKeywordView : UIView
@property (weak, nonatomic) id<SearchKeywordViewDelegate> delegate;
@property (strong, nonatomic) NSArray *keywords;
- (id)initWithFrame:(CGRect)frame edgeInsets:(UIEdgeInsets)insets;
@end

@protocol SearchKeywordViewDelegate <NSObject>
@optional
- (void)searchKeywordView:(SearchKeywordView *)keywordView didSelectKeyword:(NSString *)keyword;
@end
