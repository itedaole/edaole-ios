//
//  OrderViewCell.m
//  tuangouproject
//
//  Created by  na on .
//
//

#import "OrderViewCell.h"
#import "UIView+Sizes.h"

NSString * const kCellIdentifierKey = @"CellIdentifier";
NSString * const kCellContentKey    = @"CellContent";
NSString * const kCellURLKey        = @"CellURL";
NSString * const kCellTitleKey      = @"CellTitle";

NSDictionary *makeCell(Class klass, NSString *title, id content)
{
    return @{kCellIdentifierKey : NSStringFromClass(klass),
             kCellTitleKey: title ? title : @"",
             kCellContentKey : content ? content : @""
             };
}


@implementation OrderViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.detailTextLabel.font = [UIFont systemFontOfSize:15];
        self.detailTextLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        self.detailTextLabel.textAlignment = UITextAlignmentCenter;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.centerY = CGRectGetMidY(self.contentView.bounds);
    self.detailTextLabel.left = 80;
    self.detailTextLabel.width = self.contentView.width - 80 - 20;
    self.detailTextLabel.centerY = self.textLabel.centerY;
}

@end

@implementation OrderPhoneCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont boldSystemFontOfSize:15];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.centerY = CGRectGetMidY(self.contentView.bounds);
    self.detailTextLabel.centerY = self.textLabel.centerY;
    self.detailTextLabel.right = self.contentView.width - 20;
}

@end

@implementation OrderStepperCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.detailTextLabel.textColor = self.textLabel.textColor;
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.textAlignment = UITextAlignmentCenter;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        
        [self.contentView addSubview:_textField];
        
        _decButton = [self buttonWithNormal:@"reduce_button_normal" highlight:@"reduce_button_hilight" disabled:@"reduce_button_disable"];
        _incButton = [self buttonWithNormal:@"btn_add_normal" highlight:@"btn_add_hilight" disabled:@"add_button_disable"];
        
        [self.contentView addSubview:_incButton];
        [self.contentView addSubview:_decButton];
    }
    return self;
}

- (UIButton *)buttonWithNormal:(NSString *)n highlight:(NSString *)h disabled:(NSString *)d
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

    [btn setBackgroundImage:[UIImage imageNamed:n] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:h] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageNamed:d] forState:UIControlStateDisabled];
    [btn sizeToFit];
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.centerY = CGRectGetMidY(self.contentView.bounds);

    self.decButton.left = 120;
    self.incButton.left = self.contentView.width - 40 - self.incButton.width;
    
    self.textField.width = self.incButton.left - self.decButton.right - 20;
    self.textField.left = self.decButton.right + 10;
    self.textField.height = 30;
    self.incButton.centerY = self.decButton.centerY = self.textField.centerY = self.textLabel.centerY;

}

@end

@implementation OrderNextButtonCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:reuseIdentifier];
    if (self) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setBackground:@"btn_buy_normal" highlight:@"btn_buy_hilight"];

        if ([self respondsToSelector:@selector(separatorInset)]) {
            self.backgroundColor = [UIColor clearColor];
        }
        [_button setTitle:@"去支付" forState:UIControlStateNormal];
        [self.contentView addSubview:_button];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _button.frame = CGRectInset(self.contentView.bounds, 0, 0);
    if ([self respondsToSelector:@selector(separatorInset)]) {
        UIView *v = self.subviews[0];
        NSMutableSet *seps = [[NSMutableSet alloc] initWithCapacity:2];
        for (UIView *sv in v.subviews) {
            if ([sv isKindOfClass:NSClassFromString(@"_UITableViewCellSeparatorView")]) {
                [seps addObject:sv];
            }
        }
        [seps makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}
@end

@implementation OrderConfirmCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.detailTextLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    }
    return self;
}

@end

@implementation OrderOptionCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:reuseIdentifier];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_scrollView];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.detailTextLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _scrollView.frame = self.contentView.bounds;
}
@end

@implementation OrderTextFieldCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.textAlignment = UITextAlignmentRight;
        self.textLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1];

        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_textField];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.width = 60;
    CGFloat height = _textField.font.lineHeight + 8;
    _textField.frame = CGRectMake(100, (CGRectGetHeight(self.contentView.frame) - height) / 2 + 2,CGRectGetWidth(self.contentView.frame) - 110, height);
}
@end

@implementation OrderExpressCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detailTextLabel.font = self.textField.font;
        self.detailTextLabel.textColor = self.textField.textColor;
        [self.textField removeFromSuperview];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.top = (CGRectGetHeight(self.contentView.frame) - self.textLabel.height) / 2 ;
    self.detailTextLabel.frame = self.textField.frame;
}
@end

@implementation ExpressOptionCell
@end

@implementation OrderPaymentOptionCell
@end
