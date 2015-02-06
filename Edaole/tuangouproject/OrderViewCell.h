//
//  OrderViewCell.h
//  tuangouproject
//
//  Created by  na on .
//
//

#import <UIKit/UIKit.h>

extern NSString * const kCellIdentifierKey;
extern NSString * const kCellTitleKey;
extern NSString * const kCellContentKey;
extern NSString * const kCellURLKey;

__BEGIN_DECLS
NSDictionary *makeCell(Class klass, NSString *title, id content);
__END_DECLS

@interface OrderViewCell : UITableViewCell

@end

@interface OrderPhoneCell : UITableViewCell
@end

@interface OrderStepperCell : UITableViewCell
@property (readonly, nonatomic) UIButton *incButton;
@property (readonly, nonatomic) UIButton *decButton;
@property (readonly, nonatomic) UITextField *textField;
@end

@interface OrderNextButtonCell : UITableViewCell
@property (readonly, nonatomic) UIButton *button;
@end

@interface OrderConfirmCell : UITableViewCell
@end

@interface OrderOptionCell : UITableViewCell
@property (strong, nonatomic) UIScrollView *scrollView;
@end

@interface ExpressOptionCell : OrderOptionCell
@end

@interface OrderTextFieldCell : UITableViewCell
@property (strong, nonatomic) NSString *key;
@property (readonly, nonatomic) UITextField *textField;
@end

@interface OrderExpressCell : OrderTextFieldCell
@end

@interface OrderPaymentOptionCell : OrderViewCell
@end
