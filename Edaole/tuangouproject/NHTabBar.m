//
//  NHTabBar.m
//  
//
//  Created by stcui on 12-2-8.
//  Copyright (c) 2012年 stcui. All rights reserved.
//

#import "NHTabBar.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>


static NSString * const kTabBg = @"tab_bg";
static NSString * const kTabHighlight = @"tab_bg_h";

static NSString * const fontName = @"STHeitiSC-Medium";
static const CGFloat kTabFontSize = 10.0f;
static const size_t  kHightlightLayerZ = 3;
static const size_t  kTabLayerZ = 5;

@interface _NHTabSelectionLayer : CALayer 
- (CGSize)size;
@end

@interface TabItemLayer : CALayer
@property (nonatomic) BOOL highlighted;
@property (nonatomic) BOOL selected;
@property (nonatomic) BOOL showBadge;
@property (nonatomic, readonly) CALayer *badgeLayer;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlihgtedImage;
@property (nonatomic, strong) NSString *title;

+ (id)layerWithImage:(UIImage *)image title:(NSString *)title;
+ (id)layerWithImage:(UIImage *)image highlightedImage:(UIImage*)highlightedImage title:(NSString *)title;
@end

@interface NHTabBar ()
@property (nonatomic, strong) _NHTabSelectionLayer * selectionLayer;
@property (nonatomic, strong) NSArray *tabLayers;
@end

@implementation NHTabBar {
    CGFloat _tabWidth;
}
@synthesize tabs = _tabs;
@synthesize selectionLayer = _selectionLayer;
@synthesize tabLayers = _tabLayers;
@synthesize selectedIndex = _selectedIndex;

- (void)configView
{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tabbar"]];
    
    _selectedIndex = -1;
    self.clipsToBounds = NO;
    self.selectionLayer = [_NHTabSelectionLayer layer];
    CGSize selectionSize = self.selectionLayer.size;
    CGFloat top = (self.bounds.size.height - selectionSize.height) / 2.0f;
    self.selectionLayer.frame = CGRectMake(2, top, selectionSize.width, selectionSize.height);
    [self.layer addSublayer:self.selectionLayer];
    self.selectionLayer.zPosition = kHightlightLayerZ;
    [self.selectionLayer setNeedsDisplay];

//    self.layer.cornerRadius  = 8.0f;
//    self.layer.shadowPath    = [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:8.0f] CGPath];
    
//    CGPathRef shadowPath = CGPathCreateWithRect(self.bounds, &CGAffineTransformIdentity);
//    self.layer.shadowPath = shadowPath;
//    CFRelease(shadowPath);
//    self.layer.shadowOpacity = 1;
//    self.layer.shadowColor = [UIColor colorWithRed:0.71f green:0.73f blue:0.76f alpha:1.00f].CGColor;
//    self.layer.shadowRadius  = 3.0f;
//    self.layer.shadowOffset  = CGSizeMake(0, 0);
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configView];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    CGSize boundsSize = self.bounds.size;
    NSInteger count = self.tabs.count;
    CGFloat tabWidth = CGRectGetWidth(layer.bounds) / count;
    NSInteger index = 0;
    
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    for (CALayer *tabLayer in self.tabLayers) {
        CGRect frame = CGRectMake(index * tabWidth, 0, tabWidth, boundsSize.height);
        tabLayer.frame = frame;
        ++index;
    }
    [CATransaction commit];
    
    self.selectionLayer.position = CGPointMake(tabWidth * (0.5 + self.selectedIndex), boundsSize.height / 2.0f + 0.5);
    
}

//- (void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    self.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:8.0f] CGPath];
//}

- (void)setTabs:(NSArray *)tabs
{
    if (_tabs == tabs) return;
    _tabs = tabs;
    
    for (CALayer *l in self.tabLayers) {
        [l removeFromSuperlayer];
    }

    NSMutableArray *tabLayers = [[NSMutableArray alloc] initWithCapacity:tabs.count];
    for (UITabBarItem *item in tabs) {
        NSArray *title_image = [item.title componentsSeparatedByString:@"|"];
        NSString *title = [title_image objectAtIndex:0];
        CALayer *layer = nil;
        if (title_image.count == 2) {
            NSString *imageName = [title_image objectAtIndex:1];
            if (!item.image) item.image = [UIImage imageNamed:imageName];
            layer = [TabItemLayer layerWithImage:item.image highlightedImage:[UIImage imageNamed:imageName] title:title];
        } else {
            layer = [TabItemLayer layerWithImage:item.image title:title];
        }
        layer.zPosition = kTabLayerZ;
        [tabLayers addObject: layer];
        [self.layer addSublayer:layer];
        [layer setNeedsDisplay];
    }
    
    self.tabLayers = tabLayers;
    if (self.tabs.count > 0) {
        _tabWidth = CGRectGetWidth(self.bounds) / self.tabs.count;
        self.selectedIndex = 0;
    }
//    [self.layer setNeedsLayout];
}

- (void)showBadgetAtIndex:(NSInteger)index
{
    [[self.tabLayers objectAtIndex:index] setShowBadge:YES];
}
#pragma mark - UIControl
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:self];
    NSInteger index = floor(location.x / _tabWidth);
    TabItemLayer *layer = (TabItemLayer *)[self.tabLayers objectAtIndex:index];
    layer.highlighted = YES;
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, location)) {
        return YES;
    } else {
        for (TabItemLayer *layer in self.tabLayers) {
            [layer setHighlighted:NO];
        }
        return NO;        
    }
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:self];
    if (_tabWidth > 0) {
        self.selectedIndex  = floor(location.x / _tabWidth);
    } else {
        self.selectedIndex = -1;
    }
    for (TabItemLayer *layer in self.tabLayers) {
        [layer setHighlighted:NO];
    }
}

#pragma mark - Accessors
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (selectedIndex > self.tabLayers.count - 1) return;
    if (_selectedIndex >= 0 && _selectedIndex < self.tabLayers.count) {
        [[self.tabLayers objectAtIndex:_selectedIndex] setSelected:NO];
    }
    _selectedIndex = selectedIndex;
    [[self.tabLayers objectAtIndex:_selectedIndex] setSelected:YES];

    CGPoint center = CGPointMake(_tabWidth * (0.5 + selectedIndex), CGRectGetMidY(self.bounds)+0.5);
    self.selectionLayer.position = center;
}

@end

#pragma mark -  
@implementation _NHTabSelectionLayer {
    UIImage *_bgImage;
}

+ (CALayer *)layer
{
    CALayer *layer = [[self alloc] init];
    layer.contentsScale = [[UIScreen mainScreen] scale];
//    layer.shadowOpacity = 0.8f;
//    layer.shadowRadius = 1.0f;
//    layer.shadowColor   = [UIColor blackColor].CGColor;
//    layer.shadowOffset  = CGSizeMake(0,1);
    
    return layer;
}
- (UIImage *)bgImage
{
    if (nil == _bgImage) {
        _bgImage = [UIImage imageNamed:kTabHighlight];
    }
    return _bgImage;
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    UIImage *bgImage = [self bgImage];
    CGContextConcatCTM(ctx, CGAffineTransformMake(1, 0, 0, -1, 0, self.bounds.size.height));
    CGContextDrawImage(ctx, (CGRect){CGPointZero, bgImage.size}, bgImage.CGImage);
    CGContextRestoreGState(ctx);
}
- (CGSize)size
{
    return [self bgImage].size;
}
@end

#pragma mark
@implementation TabItemLayer {
    UIFont *_font;
    CGSize _imageSize;
    CGSize _titleSize;
    CALayer *_badgeLayer;
}

@synthesize image = _image, title = _title, highlighted = _highlighted, selected = _selected, highlihgtedImage = _highlihgtedImage;
@synthesize showBadge = _showBadge;
@synthesize badgeLayer = _badgeLayer;

+ (id)layerWithImage:(UIImage *)image title:(NSString *)title
{
    TabItemLayer *layer = [[self alloc] init];
    layer.image = image;
    layer.title = title;
    layer.contentsScale = [[UIScreen mainScreen] scale];
    return layer;
}

+ (id)layerWithImage:(UIImage *)image highlightedImage:(UIImage*)highlightedImage title:(NSString *)title
{
    TabItemLayer *layer = [TabItemLayer layerWithImage:image title:title];
    layer.highlihgtedImage = highlightedImage;
    return layer;
}

- (id)init
{
    self = [super init];
    if (self) {
        _font = [UIFont fontWithName:@"STHeitiSC-Medium" size: kTabFontSize];
    }
    return self;
}

- (CALayer *)badgeLayer
{
    if (nil == _badgeLayer) {
        _badgeLayer = [CALayer layer];
        UIImage *badge = [UIImage imageNamed:@"new_notice_badge"];
        _badgeLayer.contents = (id)[badge CGImage];
        _badgeLayer.frame = CGRectMake(CGRectGetWidth(self.bounds) - badge.size.width, -8, badge.size.width, badge.size.height);
        [self addSublayer:_badgeLayer];
    }
    return _badgeLayer;
}

- (void)setImage:(UIImage*)image
{
    if (_image == image) return;
    _image = image;
    if (_image) {
        _imageSize = image.size;
    } else {
        _imageSize = CGSizeZero;
    }
}

- (void)setTitle:(NSString *)title
{
    if ([_title isEqualToString:title]) return;
    _title = title;
    if (_title)
        _titleSize = [_title sizeWithFont:_font];
    else
        _titleSize = CGSizeZero;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (_highlighted == highlighted) return;
    _highlighted = highlighted;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    if (_selected == selected) return;
    _selected = selected;
    [self setNeedsDisplay];
}

- (void)setShowBadge:(BOOL)showBadge
{
    if (_showBadge == showBadge) return;
    _showBadge = showBadge;
    self.badgeLayer.hidden = !showBadge;
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    CGContextConcatCTM(ctx, CGAffineTransformMake(1, 0, 0, -1, 0, self.bounds.size.height));
    CGFloat width = _imageSize.width + _titleSize.width;
    
    if (width < 0.0001) {
        return;
    }
    
    CGFloat midX    = CGRectGetMidX(self.bounds);
//    CGFloat spacing = 0.0f;
    
    CGFloat vSpacing = 1.0f;
    CGFloat height = _titleSize.height + _imageSize.height + vSpacing;
    CGFloat minY   = (CGRectGetHeight(self.bounds) - height) / 2.0f;
    UIImage *imageToDraw = (self.highlighted || self.selected) ? self.highlihgtedImage : self.image;
    if (_imageSize.width > 0) {
        CGRect imageFrame = (CGRect){{midX - _imageSize.width / 2.0f, minY + _titleSize.height + vSpacing}, _imageSize}; // minus shadow size
        CGContextDrawImage(ctx, imageFrame, imageToDraw.CGImage);
    }
    
    if (_titleSize.width > 0) {
        if (self.highlighted || self.selected) {
            CGContextSetRGBFillColor(ctx, 0.18f, 0.57f, 0.75f, 1);
            CGContextSetRGBStrokeColor(ctx, 0.18f, 0.57f, 0.75f, 1);
        } else {
            CGContextSetRGBFillColor(ctx, 0.4, 0.4, 0.4, 1);
            CGContextSetRGBStrokeColor(ctx, 0.4, 0.4, 0.4, 1);
        }
       
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)fontName, kTabFontSize, &CGAffineTransformIdentity);
        CGContextSelectFont(ctx, [fontName UTF8String] , kTabFontSize, kCGEncodingMacRoman);
        CGGlyph textGlyphs[[self.title length]];
        UniChar textChars[[self.title length]];
        for (int i = 0; i < [self.title length]; ++i) {
            textChars[i] = [self.title characterAtIndex:i];
        }
        CTFontGetGlyphsForCharacters(font, textChars, textGlyphs, [self.title length]);
        /*
        if (self.highlighted || self.selected) {
            CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 1.0f, [UIColor colorWithWhite:0.f alpha:0.5f].CGColor);
        } else {
            CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 1.0f, [UIColor colorWithWhite:0.f alpha:1.f].CGColor);
        }
         */

        CGPoint textOrigin = CGPointMake(midX - _titleSize.width / 2, minY + _font.xHeight - 5);
        CGContextShowGlyphsAtPoint(ctx, textOrigin.x, textOrigin.y, textGlyphs, [self.title length]);                
    }

    
    CGContextRestoreGState(ctx);

}

@end