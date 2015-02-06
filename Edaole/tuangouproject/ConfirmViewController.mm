////
////  ConfirmViewController.m
////  tuangouproject
////
////  Created by  na on .
////
////
//
//#import "ConfirmViewController.h"
//#import "OrderViewCell.h"
//#import "WebViewController.h"
//#import "NSDictionary+RequestEncoding.h"
//#import "ASIHTTPRequest.h"
//#import "LoginViewController.h"
//#import "SVProgressHUD.h"
//#import "KeyboardEventResizer.h"
////#import "Tenpay.h"
//#import "AlixPay.h"
//#import "WXPayUtil.h"
//#import "UIAlertView+Blocks.h"
//#import "WxPayObj.h"
////#import "UPPayPlugin.h"
//#import "CommerceTracking.h"
//
//#if TARGET_IPHONE_SIMULATOR
//    #define OPEN_UMSPay 0
//#else
//    #define OPEN_UMSPay 1
//#endif
//
////    #define OPEN_UMSPay 0
//
//#define DEF_PAY_OPTIONS(n, firstArg, ...) _DEF_OPT_##n(PayOption, firstArg, ##__VA_ARGS__)
//
//#define _DEF_OPT_1(name,opt) static NSString * const k##name##opt = @#opt
//#define _DEF_OPT_2(name,opt, ...) _DEF_OPT_1(name,opt); _DEF_OPT_1(name, ##__VA_ARGS__)
//#define _DEF_OPT_3(name,opt, ...) _DEF_OPT_1(name,opt); _DEF_OPT_2(name, ##__VA_ARGS__)
//#define _DEF_OPT_4(name,opt, ...) _DEF_OPT_1(name,opt); _DEF_OPT_3(name, ##__VA_ARGS__)
//#define _DEF_OPT_5(name,opt, ...) _DEF_OPT_1(name,opt); _DEF_OPT_4(name, ##__VA_ARGS__)
//#define _DEF_OPT_6(name,opt, ...) _DEF_OPT_1(name,opt); _DEF_OPT_5(name, ##__VA_ARGS__)
//
//
//DEF_PAY_OPTIONS(6, Tenpay, Alipay, UmsPay, UnionPay, Wxpay, PhonePay);
//
////static NSString * const kPayOptionUnionPay = @"unionPay";
////让模拟器能成功跑
//#if OPEN_UMSPay
//    #import "UMSPay_QMJF_iPhone.h"
//#else
//    @class UMSPay_QMJF_iPhone;
//    @class UMSPay_QMJF_KaBase64;
//    @protocol UMSPayQMJFIPhoneDelegate <NSObject>
//    @end
//#endif
//
//#import "AppDelegate.h"
//#import "Session.h"
//
//static const NSUInteger kSuccessAlertTag = 11;
//static const NSUInteger kAlipayTag = 123;
//
//@interface ConfirmViewController () <UMSPayQMJFIPhoneDelegate, UPPayPluginDelegate>
//@property (strong, nonatomic) NSArray *info;
//@property (strong, nonatomic) ASIHTTPRequest *creditReq;
//@property (strong, nonatomic) ASIHTTPRequest *weixinReq;
//@property (strong, nonatomic) NSString *paymentMethod;
//@property (strong, nonatomic) UMSPay_QMJF_iPhone *umsPay;
//@property (strong, nonatomic) id cookiesCopy;
//@end
//
//@implementation ConfirmViewController
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.app.tielinghui"]) {
//            _phonePayAvailable = YES;
//        }
//        if([self respondsToSelector:@selector(edgesForExtendedLayout)]){
//            self.edgesForExtendedLayout=UIRectEdgeAll;
//        }
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    self.title = @"支付订单";
//    self.tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
//    self.tableView.backgroundView = nil;
//    self.tableView.delegate = self;
//    UIButton *bn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
//    [bn setBackgroundImage:[UIImage imageNamed:@"btn_back_normal.png"] forState:UIControlStateNormal];
//    [bn setBackgroundImage:[UIImage imageNamed:@"btn_back_hilight.png"] forState:UIControlStateHighlighted];
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:bn];
//    [bn setTitle:@"返回" forState:UIControlStateNormal];
//    bn.titleLabel.font=[UIFont systemFontOfSize:15];
//    [bn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//    [bn addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self updateView];
//}
//
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//- (void)onBack
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//- (void)updateView
//{
////    float total = [self.product[kCurrentPrice] floatValue] * self.count;
//    float left = [self.credit floatValue];// + [[SESSION money] floatValue];
//    float bank = [self.total floatValue] - left;
//    if (bank < 0) bank = 0;
//    
//    NSMutableArray *paymentInfo = [NSMutableArray arrayWithCapacity:2];
//    if (self.tenpayToken) {
//        [paymentInfo addObject:makeCell([OrderPaymentOptionCell class], kPayOptionTenpay, @"财付通支付")];
//    }
//    if (self.alipayParams) {
//        [paymentInfo addObject:makeCell([OrderPaymentOptionCell class], kPayOptionAlipay, @"支付宝快捷支付")];
//    }
//    if (self.umsPayParams) {
//        [paymentInfo addObject:makeCell([OrderPaymentOptionCell class], kPayOptionUmsPay, @"全民捷付")];
//    }
//    if (self.wxpay) {
//        [paymentInfo addObject:makeCell([OrderPaymentOptionCell class], kPayOptionWxpay, @"微信支付")];
//    }
//    if (self.unionPayAvailable) {
//        [paymentInfo addObject:makeCell([OrderPaymentOptionCell class], kPayOptionUnionPay, @"银联支付")];
//    }
//    if (self.phonePayAvailable) {
//        [paymentInfo addObject:makeCell([OrderPaymentOptionCell class], kPayOptionPhonePay, @"货到付款")];
//    }
//
//    self.info = @[
//                  @[
//                      makeCell([OrderViewCell class], @"名称", self.product[kProductName]),
//                      makeCell([OrderViewCell class], @"单价", [NSString stringWithFormat:@"¥%@", self.product[kCurrentPrice]]),
//                      makeCell([OrderViewCell class], @"数量", [@(self.count) description]),
//                      ],
//                  @[
//                      makeCell([OrderViewCell class], @"帐户余额", [NSString stringWithFormat: @"¥ %.2f", left]),
//                      //        makeCell([OrderViewCell class], @"代金券", @"¥10"),
//                      makeCell([OrderViewCell class], @"总价", [NSString stringWithFormat:@"¥ %@", self.total]),
//                      makeCell([OrderViewCell class], @"还需支付", [NSString stringWithFormat:@"¥ %.2f", bank]),
//                      ],
//                  paymentInfo,
//                  @[makeCell([OrderNextButtonCell class], nil, nil)],
//                  ];
//    [self.tableView reloadData];
//    
//    [self performSelector:@selector(setDefaultPayMethodSelect) withObject:nil afterDelay:0.6];
//    
//    
//}
//
//- (void)setDefaultPayMethodSelect
//{
//    if (self.info.count==4&&[self.info[2] count]>0) {
//        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
//    }
//}
//
//#pragma mark - UITableViewDataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return self.info.count;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [self.info[section] count];
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section > 2) return nil;
//    return @[@"订单信息", @"结算信息", self.payURL.length > 0 ? @"余额支付" : @"选择支付方式"][section];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary *info = self.info[indexPath.section][indexPath.row];
//    NSString *identifier = info[kCellIdentifierKey];
//    Class klass = NSClassFromString(identifier);
//    
//    OrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (nil == cell) {
//        cell = [[klass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        if (klass == [OrderNextButtonCell class]) {
//            UIButton *btn = [(OrderNextButtonCell*)cell button];
//            [btn setTitle:@"确定支付" forState:UIControlStateNormal];
//            [btn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    if (klass == [OrderPaymentOptionCell class]) {
//        NSString *paymentMethod = info[kCellTitleKey];
//        NSString *iconName = [paymentMethod stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[paymentMethod substringWithRange:NSMakeRange(0, 1)] lowercaseString]];
//        if ([self.paymentMethod isEqualToString:paymentMethod]) {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        } else {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
//        UIImage *image = [UIImage imageNamed:iconName];
//        cell.imageView.image = image;// [UIImage imageNamed:@"财付通"];
//        cell.detailTextLabel.text = info[kCellContentKey];
//    } else if(klass == [OrderNextButtonCell class]){
//        cell.backgroundView=nil;
//        cell.backgroundColor=[UIColor clearColor];
//        cell.contentView.backgroundColor=[UIColor clearColor];
//    }else{
//        cell.textLabel.text = info[kCellTitleKey];
//        cell.detailTextLabel.text = info[kCellContentKey];
//    }
//    return cell;
//}
//
//#pragma mark - UITableViewDelegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary *info = self.info[indexPath.section][indexPath.row];
//    NSString *identifier = info[kCellIdentifierKey];
//    Class klass = NSClassFromString(identifier);
//    if (klass == [OrderPaymentOptionCell class]) {
//        self.paymentMethod = info[kCellTitleKey];
//        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]
//                 withRowAnimation:UITableViewRowAnimationNone];
//    }
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.view endEditing:YES];
//}
//
//
//- (IBAction)next:(id)sender
//{
//    if (!self.paymentMethod && self.payURL.length == 0) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择支付方式"
//                                                        message:nil
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确认"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
// 
////    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认付款"
////                                                    message:nil
////                                                   delegate:self
////                                          cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
////    [alert showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
////        if (buttonIndex != alertView.cancelButtonIndex) {
//            [self doOrderProduct];
////        }
////    }];
//}
//
//#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag == kSuccessAlertTag) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    } else if (alertView.tag == kAlipayTag) {
//        if (buttonIndex != alertView.cancelButtonIndex) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/kuai-jie-zhi-fu/id535715926?mt=8"]];
//        }
//    }
//}
//
//- (void)doOrderProduct
//{
//    if (self.payURL) {
//        [self payWithCredit];
//    } else if ([self.paymentMethod isEqualToString:kPayOptionAlipay]) {
//        [self payWithAlipay:self.alipayParams];
//    } else if ([self.paymentMethod isEqualToString:kPayOptionUmsPay]) {
//        [self payWithUmsay:self.umsPayParams];
//    } else if ([self.paymentMethod isEqualToString:kPayOptionTenpay]) {
//        [self payWithTenpay:self.tenpayToken];
//    } else if ([self.paymentMethod isEqualToString:kPayOptionWxpay]) {
//        [self payWithWeixin];
//    } else if ([self.paymentMethod isEqualToString:kPayOptionPhonePay]){
//        [self payWithPhone];
//    } else if ([self.paymentMethod isEqualToString:kPayOptionUnionPay]) {
//        [self payWithUnionPay];
//    }
//}
//
//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//    NSDictionary *resp = [request.responseData objectFromJSONData];
//
//    if (request == self.creditReq) {
//        self.creditReq = nil;
//        NSInteger status = [[resp valueForKey:@"status"] integerValue];
//        if (status == 1) {
//            [SVProgressHUD dismiss];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"购买成功!"
//                                        message:nil
//                                       delegate:self
//                              cancelButtonTitle:@"确认"
//                                                  otherButtonTitles:nil];
//            alert.tag = kSuccessAlertTag;
//            [SESSION refreshSessionData];
//            [alert show];
//        } else if (status == 0) {
//            NSString *error=[resp valueForKeyPath:@"error.text"];
//            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"支付失败,%@",error]];
//        } else {
//            [SVProgressHUD dismiss];
//            [self showLoginView];
//        }
//    }
//}
//
//- (void)requestFailed:(ASIHTTPRequest *)request
//{
//    if (request == self.creditReq) {
//        self.creditReq = nil;
//    }
//    
//    [SVProgressHUD dismiss];
//}
//
//- (void)showLoginView
//{
//    LoginViewController *detailViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    [self.view.window.rootViewController presentModalViewController:detailViewController animated:YES];
//}
//
//#pragma mark - Payment Method
//#pragma mark 余额
//- (void)payWithCredit
//{
//    [SVProgressHUD showWithStatus:@"处理中"];
//    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.payURL]];
//    self.creditReq = req;
//    req.delegate = self;
//    [req startAsynchronous];
//}
//
//#pragma mark 财付通
//- (void)payWithTenpay:(NSString *)token_id
//{
//    //    token_id = @"81d8a19d05f83540f3355208387b4d0d";
//    NSString *bargainor_id = self.bargainorId;// @"1215694801";
//    NSString *notifyurl = [NSString stringWithFormat: @"tenpay-%@-tuangou://payresult?result=${result}&retcode=${retcode}&retmsg=${retmsg}&sp_data=${sp_data}", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]];
//    SEL didFinishSelector = @selector(tenpayDidFinish:details:);
//    NSValue *didFinishSelectorValue = [NSValue valueWithBytes:&didFinishSelector objCType:@encode(SEL)];
//    
//    NSDictionary *payinfo = [NSDictionary dictionaryWithObjectsAndKeys:
//                             token_id, PayInfoTokenIDKey,
//                             bargainor_id, PayInfoBargainorIDKey,
//                             notifyurl, PayInfoNotifyURLKey,
//                             [[UIApplication sharedApplication] delegate], PayInfoDelegateKey,
//                             didFinishSelectorValue, PayInfoDidFinishSelectorKey,
//                             nil];
//    NSError *error = nil;
//    BOOL ok = [Tenpay payWithDictionary:payinfo error:&error];
//    if (!ok) {
//        NSString *message = [NSString stringWithFormat: @"错误原因：%@",
//                             [error localizedDescription]];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付错误"
//                                                        message:message
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles: nil];
//        [alert show];
//    }
//}
//
//#pragma mark 全民捷付
//- (void)payWithUmsay:(NSString *)strPayInfo
//{
//#if OPEN_UMSPay
//    self.cookiesCopy = [[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies copy];
//    
//    UMSPay_QMJF_KaBase64 *base64 = [[UMSPay_QMJF_KaBase64 alloc] init];
//    NSData *data=[base64 encode:[strPayInfo dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    UMSPay_QMJF_iPhone *umsPay=[[UMSPay_QMJF_iPhone alloc] init];
//
//    self.umsPay = umsPay;
//    umsPay.delegate = self;
//    
//    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//
//    [appDelegate.window.rootViewController presentModalViewController:umsPay animated:YES];
//
//    @try {
//#ifdef DEBUG
//        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",str);
//#endif
//        [umsPay setXmlData:data];
//        [umsPay.navigationBar setTranslucent:YES];
//        
//    } @catch (NSException *exception) {
//        [SVProgressHUD showErrorWithStatus:@"支付失败"];
//        self.umsPay.delegate = nil;
//        double delayInSeconds = 0.5;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [appDelegate.window.rootViewController dismissModalViewControllerAnimated:YES];
//        });
//        self.umsPay = nil;
//    }
//#endif
//}
//
//#pragma mark 银联
//- (void)payWithUnionPay
//{
//    NSString *mode = @"00";
//    [UPPayPlugin startPay:self.unionPayTN
//                     mode:mode
//           viewController:self
//                 delegate:self];
//}
//
//#pragma mark 支付宝
//- (void)payWithAlipay:(NSString *)paramStr
//{
//    [AlixPay payOrder:paramStr AndScheme:[NSString stringWithFormat:@"alipay-%@-tuangou", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"]] seletor:@selector(alipayResult:) target:self];
//}
//
//-(void)paymentResult:(NSString *)resultd
//{
//    //结果处理
//    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
//	if (result && result.statusCode == 9000) {
//        [self showSuccessView];
//    } else {
//        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"支付失败: %@", result.statusMessage]];
//    }
//}
//
//#pragma mark 微信支付
//- (void)payWithWeixin
//{
//    [SVProgressHUD showWithStatus:@"处理中..."];
//    [[WXPayUtil sharedInstance] payForProductName:self.product[kSellerName]
//                                          orderID:self.orderID
//                                              obj:self.wxpay
//                                       completion:^(NSDictionary *order, NSError *error) {
//                                           if (error) {
//                                               [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"支付失败: %@", error]];
//                                           } else {
//                                               [SVProgressHUD showSuccessWithStatus:@"支付成功"];
//                                           }
//                                       }];
//}
//
//#pragma mark - 打电话支付
//- (void)payWithPhone
//{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://024-74111222"]];
//}
//
//#pragma mark - UMSPay Delegate
//- (void)viewClose:(NSData *)myData;
//{
//#if OPEN_UMSPay
//    for (NSHTTPCookie *cookie in  self.cookiesCopy) {
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//    }
//    self.cookiesCopy = nil;
//    self.umsPay = nil;
//
//    UMSPay_QMJF_KaBase64 *base64 = [[UMSPay_QMJF_KaBase64 alloc] init];
//    myData = [base64 decode:myData];
//    NSString *strReturnXmlData = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
//    NSLog(@"strReturnXmlData:%@",strReturnXmlData);
//
//    NSArray *pairs = [strReturnXmlData componentsSeparatedByString:@"&"];
//    for (NSString *param in pairs) {
//        NSArray *keyValue = [param componentsSeparatedByString:@"="];
//        if (keyValue.count == 2) {
//            NSString *key = keyValue[0];
//            NSString *value = keyValue[1];
//            if ([key isEqualToString:@"respCode"]) {
//                if ([value integerValue] == 0) {
//                    [self onUmsPaySuccess];
//                    return;
//                }
//            }
//        }
//    }
//    [self onUmsPayFail];
//#endif
//}
//
//- (void)showSuccessView
//{
//    [SVProgressHUD showWithStatus:@"支付成功"];
//    NSString *currentPrice = self.product[kCurrentPrice];
//    NSNumber *revenue = @([currentPrice doubleValue]);
//    [CommerceTracking tracePurchaseSuccessWithID:self.product[kProductId]
//                                         revenue:revenue
//                                        shipping:@0];
//}
//
//- (void)onUmsPaySuccess
//{
//    NSLog(@"didLogin: %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"didLogin"]);
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self showSuccessView];
//}
//
//- (void)onUmsPayFail
//{
//    NSLog(@"didLogin: %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"didLogin"]);
//}
//#pragma mark - 银联支付回调 UPPayPluginDelegate
//-(void)UPPayPluginResult:(NSString*)result
//{
//    
//}
//
//@end
