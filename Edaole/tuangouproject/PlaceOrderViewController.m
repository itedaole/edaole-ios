////
////  PlaceOrderViewController.m
////  tuangouproject
////
////  Created by  na on .
////  Copyright (c) 2013年 liu song. All rights reserved.
////
//
//#import "PlaceOrderViewController.h"
//#import "WebViewController.h"
//#import "NSDictionary+RequestEncoding.h"
//#import "ASIHTTPRequest.h"
//#import "LoginViewController.h"
//#import "SVProgressHUD.h"
//#import "KeyboardEventResizer.h"
////#import "Tenpay.h"
//#import "OrderViewCell.h"
//#import "ConfirmViewController.h"
//#import "BindMobileViewController.h"
//
//static const NSUInteger kButtonTagStart = 10;
//static const NSUInteger kOrderConfirmAlertTag  = 10;
//
//enum {
//    kRecipientTag = 1010,
//    kAddressTag,
//    kPostCodeTag
//    };
//
//@interface PlaceOrderViewController () <UIPickerViewDelegate,
//UIPickerViewDataSource,ASIHTTPRequestDelegate, UIAlertViewDelegate,
//KeyboardEventResizerDelegate>
//{
//    UIView *_pickerWrapper;
//    UIPickerView *_picker;
//    
//    UIView *_pickerWrapperExpress;
//    UIPickerView *_pickerExpress;
//    
//    KeyboardEventResizer *_resizer;
//}
//@property (strong, nonatomic) NSArray *cells;
//@property (strong, nonatomic) NSArray *sectionTitles;
//
//@property (strong, nonatomic) NSArray *info;
//
//@property (strong, nonatomic) NSArray *pickerOptions;
//@property (strong, nonatomic) ASIHTTPRequest *orderReq;
//@property (assign, nonatomic) UIButton *selectedOptionButton;
//@property (nonatomic) NSInteger count;
//@property (strong, nonatomic) NSDictionary *selectedExpress; // id, name, price
//@property (strong, nonatomic) NSArray *expressArray;
//@end
//
//@implementation PlaceOrderViewController
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        self.count = 1;
//        UIButton *bn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
//        [bn setBackgroundImage:[UIImage imageNamed:@"btn_back_normal.png"] forState:UIControlStateNormal];
//        [bn setBackgroundImage:[UIImage imageNamed:@"btn_back_hilight.png"] forState:UIControlStateHighlighted];
//        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:bn];
//        [bn setTitle:@"返回" forState:UIControlStateNormal];
//        bn.titleLabel.font=[UIFont systemFontOfSize:15];
//        [bn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//        [bn addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return self;
//}
//
//- (void)onBack
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)dealloc
//{
//    [self.orderReq cancel];
//}
//- (void)configOptionsView
//{
//    CGFloat x = 10, y = 7;
//    int i = 0;
//    BOOL needsUpdate = YES;
//    for (UIButton *b in self.optionsView.subviews) {
//        if ([b isKindOfClass:[UIButton class]]) {
//            needsUpdate = NO;
//            break;
//        }
//    }
//    if (needsUpdate) {
//        for (NSArray *items in self.option_items) {
//            if ([items count]==0) {
//                return;
//            }
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            [button setBackgroundImage:[[UIImage imageNamed:@"option_bg"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            button.tag = kButtonTagStart + i++;
//            [button setTitle:[items objectAtIndex:0] forState:UIControlStateNormal];
//            button.titleLabel.font = [UIFont systemFontOfSize:12];
//            [button sizeToFit];
//            CGSize size = button.size;
//            size.width += 10;
//            button.size = size;
//            [button addTarget:self action:@selector(onTapOption:) forControlEvents:UIControlEventTouchUpInside];
//            [self.optionsView addSubview:button];
//            button.left = x;
//            button.top = y;
//            x += (button.width + 5);
//        }
//    }
//    self.optionsView.contentSize = CGSizeMake(x, self.optionsView.height);
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds
//                                                 style:UITableViewStyleGrouped];
//    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    self.tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
//    self.tableView.backgroundView = nil;
//    [self.view addSubview:self.tableView];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    
//    
//    _resizer = [[KeyboardEventResizer alloc] initWithContentView:self.tableView];
//    self.headerImageView.image =
//    [[UIImage imageNamed:@"detail_section_header"] stretchableImageWithLeftCapWidth:3 topCapHeight:0];
//    self.detailBgView.image =
//    [[UIImage imageNamed:@"detail_section"] stretchableImageWithLeftCapWidth:3 topCapHeight:37];
//    self.title = @"提交定单";
//    NSArray *expressArray = [self.product valueForKeyPath:@"express_relate"];
//    if ([expressArray isKindOfClass:[NSArray class]] && expressArray.count > 0) {
//        self.expressArray = expressArray;
//        self.selectedExpress = expressArray[0];
//        // load picker
//        _pickerExpress = [[UIPickerView alloc] init];
//        _pickerExpress.dataSource = self;
//        _pickerExpress.delegate   = self;
//        _pickerExpress.showsSelectionIndicator = YES;
//        CGSize pickerS = _pickerExpress.frame.size;
//        
//        _pickerWrapperExpress = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pickerS.width, pickerS.height + 44)];
//        _pickerWrapperExpress.backgroundColor = [UIColor whiteColor];
//        _pickerExpress.top = 44;
//        [_pickerWrapperExpress addSubview:_pickerExpress];
//        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, pickerS.width, 44)];
//        toolbar.items = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleBordered target:self action:@selector(onConfirmPickerExpress:)], nil];
//        [_pickerWrapperExpress addSubview:toolbar];
//    }
//
//    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.nextButton setBackground:@"btn_buy_normal" highlight:@"btn_buy_hilight"];
//    
//    [self.nextButton setTitle:@"提交订单" forState:UIControlStateNormal];
//    BOOL hasOption = NO;
//    NSArray *options = nil;
//    if ([self.product[kBuyOption] isKindOfClass:[NSString class]]) {
//        options = [self.product[kBuyOption] componentsSeparatedByString:@"@"];
//        if (options.count > 0 && [options[0] length] > 0) {
//            hasOption = YES;
//        }
//    }
//    if (hasOption) {
//        self.option_items = [[NSMutableArray alloc] initWithCapacity:options.count];
//        [options enumerateObjectsUsingBlock:^(NSString *option, NSUInteger idx, BOOL *stop) {
//            NSMutableArray *items = [NSMutableArray arrayWithCapacity:5];
//            NSScanner *scanner = [NSScanner scannerWithString:option];
//            NSString *tmpStr;
//            while (![scanner isAtEnd]) {
//                [scanner scanUpToString:@"{" intoString:nil];
//                if ([scanner scanUpToString:@"}" intoString:&tmpStr]) {
//                    if ([tmpStr isKindOfClass:[NSString class]]) {
//                        [items addObject:[tmpStr substringFromIndex:1]];
//                    }
//                }
//            }
//            [self.option_items addObject:items];
//        }];
//        
//        
//        // load picker
//        _picker = [[UIPickerView alloc] init];
//        _picker.dataSource = self;
//        _picker.delegate   = self;
//        _picker.showsSelectionIndicator = YES;
//        CGSize pickerS = _picker.frame.size;
//        
//        _pickerWrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pickerS.width, pickerS.height + 44)];
//        _pickerWrapper.backgroundColor = [UIColor whiteColor];
//        _picker.top = 44;
//        [_pickerWrapper addSubview:_picker];
//        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, pickerS.width, 44)];
////        toolbar.tintColor = [UIColor colorWithRed:0.98f green:0.46f blue:0.59f alpha:1.00f];
//        toolbar.items = [NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleBordered target:self action:@selector(onConfirmPicker:)], nil];
//        [_pickerWrapper addSubview:toolbar];
//    } else {
//        self.optionsView.size = CGSizeZero;
//    }
//    
//    
//    if (![[self.product valueForKeyPath:kDelivery] isEqualToString:@"express"]) {
//        self.addressInfoView.clipsToBounds = YES;
//        self.addressInfoView.size = CGSizeZero;
//    } else {
//        self.addressInfoView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
//        self.addressInfoView.layer.cornerRadius = 5.0f;
//    }
//    
//    self.addressInfoView.top = self.optionsView.bottom + 20;
//    self.nextButton.top = self.addressInfoView.bottom + 20;
//    self.scrollView.contentSize = CGSizeMake(self.view.width, self.nextButton.bottom + 20);
//    [self updateView];
//}
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.view endEditing:NO];
//    [self.tableView reloadData]; //reload mobile
//    //    [self updateView];
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [self updateView];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void)viewDidUnload {
//    _resizer = nil;
//    [self setHeaderImageView:nil];
//    [self setDetailBgView:nil];
//    [self setTitleLabel:nil];
//    [self setNameLabel:nil];
//    [self setTotalPriceLabel:nil];
//    [self setCountField:nil];
//    [self setIncButton:nil];
//    [self setDecButton:nil];
//    [self setTotalPriceLabel:nil];
//    [self setSinglePriceLabel:nil];
//    [self setNextButton:nil];
//    [self setOptionsView:nil];
//    [self setScrollView:nil];
//    [self setAddressInfoView:nil];
//    _picker = nil;
//    _pickerWrapper = nil;
//    [self setPhoneField:nil];
//    [super viewDidUnload];
//}
//
//- (void)updateCountState
//{
//    NSInteger max =[self.product[kPerMax] integerValue];
//    NSInteger min = [self.product[kPerMin] integerValue];
//    
//    if (max == 0) max = NSIntegerMax;
//    
//    if (self.count < min) self.count = min;
//    if (self.count > max) self.count = max;
//    self.incButton.enabled = self.count < max;
//    self.decButton.enabled = self.count > min;
//}
//
//
//- (void)updateViewInfo
//{
//    [self updateCountState];
//    NSInteger total = [self.product[kCurrentPrice] doubleValue] * 100.0 * self.count;
//    self.titleLabel.text = self.product[kTitle];
//    NSMutableArray *firstSection = [ @[makeCell([OrderViewCell class], @"名称", self.product[kProductName]),
//                                    makeCell([OrderViewCell class], @"单价", [NSString stringWithFormat:@"¥%@", self.product[kCurrentPrice]]),
//                                    makeCell([OrderStepperCell class], @"数量", [@(self.count) description]),
//                                    makeCell([OrderViewCell class], @"总价", [NSString stringWithFormat:@"¥ %.2f", total / 100.0])
//                                    ] mutableCopy];
//    if (self.option_items) {
//        [firstSection addObject:makeCell([OrderOptionCell class], @"", self.option_items)];
//    }
//    if ([self needAddress]) {
//        self.cells = @[
//                       firstSection,
//                       @[makeCell([OrderTextFieldCell class], @"收件人", self.recipients ? self.recipients : @""),
//                         makeCell([OrderTextFieldCell class], @"地址", self.address ? self.address : @""),
//                         makeCell([OrderTextFieldCell class], @"邮编", self.postCode ? self.postCode : @""),
//                         makeCell([OrderExpressCell class], @"快递", [NSString stringWithFormat: @"%@ (%@元)", [self.selectedExpress valueForKey:@"name"], [self.selectedExpress valueForKey:@"price"]])],
//                       
//                       @[makeCell([OrderPhoneCell class], [SESSION mobile], @"绑定新号码")],
//                       @[makeCell([OrderNextButtonCell class], nil, nil)]
//                       ];
//        self.sectionTitles = @[@"订单信息", @"物流信息", @"您绑定的电话号码"];
//    } else {
//        self.cells = @[
//                       firstSection,
//                       @[makeCell([OrderPhoneCell class], [SESSION mobile], @"绑定新号码")],
//                       @[makeCell([OrderNextButtonCell class], nil, nil)]
//                       ];
//        self.sectionTitles = @[@"订单信息", @"您绑定的电话号码"];
//    }
//}
//
//- (void)updateView
//{
//    [self updateViewInfo];
////    self.info = @[
////                  @[@"名称", self.product[kProductName]],
////                  @[@"单价", [NSString stringWithFormat:@"¥%@", self.product[kCurrentPrice]]],
////                  @[@"数量", [@(self.count) description]],
////                  @[@"总价", [NSString stringWithFormat:@"¥ %.2f", total / 100.0]]
////                  ];
//    
//    [self.tableView reloadData];
//    [self configOptionsView];
//}
//
//- (IBAction)onDecrease:(id)sender {
//    self.count -= 1;
//    [self updateView];
//}
//
//- (IBAction)onIncrease:(id)sender {
//    self.count += 1;
//    [self updateView];
//}
//
//- (IBAction)next:(id)sender
//{
//    if (![SESSION didLogin]) {
//        [self showLoginView];
//        return;
//    }
//    NSString *requireMobileValue = [SESSION requireMobile];
//    BOOL requireMobile = (!requireMobileValue || [requireMobileValue integerValue]);
//    if (requireMobile && (!([[SESSION mobile] isKindOfClass:[NSString class]]  && [[SESSION mobile] length]))) {
//        [SVProgressHUD showErrorWithStatus:@"请绑定手机"];
//        return;
//    }
//    [self doOrderProduct];
//}
//
//- (void)requestFinished:(ASIHTTPRequest *)request
//{
//    NSDictionary *resp = [request.responseData objectFromJSONData];
//    NSLog(@"resp: %@", [request responseString]);
//    NSInteger status = [[resp valueForKey:@"status"] integerValue];
//    if (status == 1) {
//        [SESSION setMoney:[resp valueForKeyPath:@"result.money"]];
//        
//        ConfirmViewController *controller = [[ConfirmViewController alloc]initWithStyle:UITableViewStyleGrouped];
//        controller.hidesBottomBarWhenPushed=YES;
//        controller.product = self.product;
//        controller.orderID = [resp valueForKeyPath:@"result.pay_id"];
//        controller.count = self.count;
//        controller.total = [resp valueForKeyPath:@"result.origin"];
//        controller.credit = [resp valueForKeyPath:@"result.credit"];
//        NSString *payURL = [resp valueForKeyPath:@"result.pay_url"];
//        NSString *tokenURL = [resp valueForKeyPath:@"result.token_url"];
////        NSString *service = [resp valueForKeyPath:@"result.service"];
//        controller.payURL = payURL;
//        // 财付通
//        NSString *tenpayKey = [resp valueForKeyPath:@"result.tenpayKey"];
//        
//        // 全民捷付
//        NSString *umsPayKey = [resp valueForKeyPath:@"result.umspay_str"];
//        if ([umsPayKey isKindOfClass:[NSString class]] && umsPayKey.length > 0) {
//            controller.umsPayParams = umsPayKey;
//        }
//        
//        // 银联支付
//        NSString *upmpPayParamsJSON = [resp valueForKeyPath:@"result.upmp_pay"];
//        NSDictionary *upmpPayParams = [upmpPayParamsJSON objectFromJSONString];
//        if (upmpPayParams && [upmpPayParams[@"tn"] length] > 0) {
//            controller.unionPayAvailable = YES;
//            controller.unionPayTN = upmpPayParams[@"tn"];
//            controller.unionPayMerID = upmpPayParams[@"mer_id"];
//        }
//        
//        // 支付宝
//        controller.alipayParams = [resp valueForKeyPath:@"result.alipay_str"];
//        if ([tenpayKey isKindOfClass:[NSString class]]&&tenpayKey.length) {
//            controller.bargainorId = tenpayKey;
//        }
//        
//        // 微信
//        NSString *wxpayDataStr=[resp valueForKeyPath:@"result.wx_pay"];
//        NSDictionary *wxData=[wxpayDataStr objectFromJSONString];
//        if ([wxData isKindOfClass:[NSDictionary class]]) {
//            WxPayObj *wxpay = [WxPayObj new];
//            wxpay.AppId=wxData[@"AppId"];
//            wxpay.PartnerId=wxData[@"PartnerId"];
//            wxpay.SignKey=wxData[@"SignKey"];
//            wxpay.AppSecret=wxData[@"AppSecret"];
//            wxpay.package=wxData[@"pakage"];
//            controller.wxpay=wxpay;
//        }
//        
//        if (payURL.length > 0) {
//            [SVProgressHUD dismiss];
//            [self.navigationController pushViewController:controller animated:YES];
//        } else {
//            if (tokenURL.length > 0) {
//                [self getTenpayToken:tokenURL completion:^(NSString *token) {
//                    controller.tenpayToken = token;
//                    [SVProgressHUD dismiss];
//                    [self.navigationController pushViewController:controller animated:YES];
//                }];
//            } else {
//                [SVProgressHUD dismiss];
//                [self.navigationController pushViewController:controller animated:YES];
//            }
//        }
//    } else if (status == -1) {
//        [SVProgressHUD dismiss];
//        [self showLoginView];
//    } else {
//        NSString *error = [resp valueForKeyPath:@"error.text"];
//        [SVProgressHUD showErrorWithStatus:error];
//    }
//}
//
//
//- (void)getTenpayToken:(NSString *)tokenURL completion:(void(^)(NSString *token))completion
//{
//    NSString *token = nil;
//    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:tokenURL]];
//    req.validatesSecureCertificate = NO;
//    [req startSynchronous];
//    NSString *str = [NSString stringWithUTF8String: [req.responseData bytes]];
//    if (str.length > 0) {
//        NSRange startRange = [str rangeOfString:@"<token_id>"];
//        NSRange endRange = [str rangeOfString:@"</token_id>"];
//        NSInteger start = startRange.location + startRange.length;
//        NSInteger end = endRange.location;
//        NSString *errStr = nil;
//        BOOL error = startRange.location == NSNotFound || endRange.location == NSNotFound || end < start;
//        if (error) {
//            NSRange startRange = [str rangeOfString:@"<err_info>"];
//            NSRange endRange = [str rangeOfString:@"</err_info>"];
//            NSInteger start = startRange.location + startRange.length;
//            NSInteger end = endRange.location;
//            BOOL err = startRange.location == NSNotFound || endRange.location == NSNotFound || end < start;
//            if (err) {
//                errStr = @"支付系统忙，请稍后再试";
//            } else {
//                errStr = [str substringWithRange:NSMakeRange(start, end-start)];
//            }
//        } else {
//            token = [str substringWithRange:NSMakeRange(start, end-start)];
//        }
//    }
//    dispatch_async(dispatch_get_main_queue(), ^{
//        completion(token);
//    });
//}
//
//- (void)requestFailed:(ASIHTTPRequest *)request
//{
//    self.orderReq = nil;
//    [SVProgressHUD dismiss];
//}
//
//- (void)showLoginView
//{
//    LoginViewController *detailViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//    
//    [self.view.window.rootViewController presentModalViewController:detailViewController animated:YES];
//}
//
//- (BOOL)needAddress
//{
//    return [[self.product valueForKeyPath:kDelivery] isEqualToString:@"express"];
//}
//
//- (void)doOrderProduct
//{
//    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.product[kProductId], @"id", @(self.count), @"quantity", @"201", @"plat", nil];
//
//    if (self.option_items) {
//        NSMutableArray *optArr = [NSMutableArray arrayWithCapacity:3];
//        for (UIButton *btn in self.optionsView.subviews) {
//            if ([btn isKindOfClass:[UIButton class]] && btn.tag >= kButtonTagStart) {
//                [optArr addObject:[btn titleForState:UIControlStateNormal]];
//            }
//        }
//        if (optArr.count > 0) {
//            [params setValue:[optArr componentsJoinedByString:@"@"] forKey:@"condbuy"];
//        }
//    }
//    
//    if ([self needAddress]) {
//        if (self.recipients.length == 0) {
//            [SVProgressHUD showErrorWithStatus:@"请添写收件人"];
//            return;
//        }
//        if (self.address.length == 0) {
//            [SVProgressHUD showErrorWithStatus:@"请添写地址"];
//            return;
//        }
//        if (self.postCode.length == 0) {
//            [SVProgressHUD showErrorWithStatus:@"请添写邮编"];
//            return;
//        }
//        [params setValue:self.address forKey:@"address"];
//        [params setValue:self.recipients forKey:@"name"];
//        [params setValue:self.postCode forKey:@"zipcode"];
//        [params setValue:[SESSION mobile] forKey:@"tell"];
//    }
//    
//    if (self.selectedExpress) {
//        [params setValue:[self.selectedExpress valueForKey:@"id"] forKey:@"expressid"];
//    }
//
//    NSString *url = TGURL(@"Tuan/buy", params);
//    self.orderReq = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
//    self.orderReq.delegate = self;
//    [SVProgressHUD showWithStatus:@"处理中..."];
//    [self.orderReq startAsynchronous];
//}
//
//- (void)showPaymentView:(NSString *)url
//{
//    WebViewController *webView = [[WebViewController alloc] init];
//    webView.hidesBottomBarWhenPushed=YES;
//    webView.url = url;
//    [self.navigationController pushViewController:webView animated:YES];
//}
//
//- (void)onTapOption:(UIButton *)sender
//{
//    self.selectedOptionButton = sender;
//    self.pickerOptions = [self.option_items objectAtIndex:sender.tag - kButtonTagStart];
//    _pickerWrapper.top = self.view.height;
//    [self.view addSubview:_pickerWrapper];
//    [UIView animateWithDuration:0.2 animations:^{
//        _pickerWrapper.top = self.view.height - _pickerWrapper.height;
//    }];
//    
//    [_picker reloadAllComponents];
//    [_picker selectRow:[self.pickerOptions indexOfObject:[sender titleForState:UIControlStateNormal]] inComponent:0 animated:NO];
//}
//
//- (void)onConfirmPicker:(UIButton *)sender
//{
//    NSString *itemTitle = [self.pickerOptions objectAtIndex:[_picker selectedRowInComponent:0]];
//    [self.selectedOptionButton setTitle:itemTitle forState:UIControlStateNormal];
//    [UIView animateWithDuration:0.2 animations:^{
//        _pickerWrapper.top = self.view.height;
//    } completion:^(BOOL finished) {
//        [_pickerWrapper removeFromSuperview];        
//    }];
//
//}
//
//- (void)onConfirmPickerExpress:(UIButton *)sender
//{
//    self.selectedExpress = self.expressArray[[_pickerExpress selectedRowInComponent:0]];
//    [self updateView];
//    [_pickerWrapperExpress removeFromSuperview];
//}
//
//#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag == kOrderConfirmAlertTag) {
//        if (buttonIndex != alertView.cancelButtonIndex) {
//            [self doOrderProduct];
//        }
//    }
//}
//
//#pragma mark - UIPickerViewDataSource
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 1;
//}
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    if (pickerView == _picker) {
//        return self.pickerOptions.count;
//    }
//    return self.expressArray.count;
//}
//
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (pickerView == _picker) {
//        return [self.pickerOptions objectAtIndex:row];
//    }
//    NSDictionary *exp = self.expressArray[row];
//    return [NSString stringWithFormat: @"%@ (%@元)", [exp valueForKey:@"name"], [exp valueForKey:@"price"]];
//}
//
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if (textField != self.countField) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
//
//        double delayInSeconds = 0.3;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            if (![[self.tableView visibleCells] containsObject:indexPath]) {
//            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop  animated:YES];
//            }
//        });
//    }
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [self.view endEditing:YES];
//    return YES;
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField
//{
//    if (textField == self.countField) {
//        self.count = [textField.text integerValue];
//        [self updateViewInfo];
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
//    } else {
//        NSUInteger row = textField.tag - kRecipientTag;
//        NSString *key = [@[@"recipients", @"address", @"postCode"] objectAtIndex:row];
//        [self setValue:textField.text forKey:key];
//    }
//}
//
////- (void)payWithToken:(NSString *)token_id
////{
////    //    token_id = @"81d8a19d05f83540f3355208387b4d0d";
////    NSString *bargainor_id = @"1900000107";
////    NSString *notifyurl = @"tenpay-1215694801-tuangou://payresult?result=${result}&retcode=${retcode}&retmsg=${retmsg}&sp_data=${sp_data}";
////    SEL didFinishSelector = @selector(tenpayDidFinish:details:);
////    NSValue *didFinishSelectorValue = [NSValue valueWithBytes:&didFinishSelector objCType:@encode(SEL)];
////    
////    NSDictionary *payinfo = [NSDictionary dictionaryWithObjectsAndKeys:
////                             token_id, PayInfoTokenIDKey,
////                             bargainor_id, PayInfoBargainorIDKey,
////                             notifyurl, PayInfoNotifyURLKey,
////                             [[UIApplication sharedApplication] delegate], PayInfoDelegateKey,
////                             didFinishSelectorValue, PayInfoDidFinishSelectorKey,
////                             nil];
////    NSError *error = nil;
////    BOOL ok = [Tenpay payWithDictionary:payinfo error:&error];
////    if (!ok) {
////        NSString *message = [NSString stringWithFormat: @"错误原因：%@",
////                             [error localizedDescription]];
////        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付错误"
////                                                        message:message
////                                                       delegate:self
////                                              cancelButtonTitle:@"确定"
////                                              otherButtonTitles: nil];
////        [alert show];
////    }
////}
//
//#pragma mark -
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return self.cells.count;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [[self.cells objectAtIndex:section] count];
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section >= self.sectionTitles.count) return nil;
//    return self.sectionTitles[section];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary *item = self.cells[indexPath.section][indexPath.row];
//    NSString * identifier = item[kCellIdentifierKey];
//    Class klass = NSClassFromString(identifier);
//    
//    OrderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (nil == cell) {
//        cell = [[klass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        if (klass == [OrderStepperCell class]) {
//            OrderStepperCell *c = (OrderStepperCell *)cell;
//            self.incButton = c.incButton;
//            self.decButton = c.decButton;
//            [c.incButton addTarget:self action:@selector(onIncrease:) forControlEvents:UIControlEventTouchUpInside];
//            [c.decButton addTarget:self action:@selector(onDecrease:) forControlEvents:UIControlEventTouchUpInside];
//            self.countField = c.textField;
//            c.textField.delegate = self;
//            [self updateCountState];
//        } else if (klass == [OrderNextButtonCell class]) {
//            UIButton *btn = [(OrderNextButtonCell*)cell button];
//            [btn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
//            [btn setTitle:@"提交订单" forState:UIControlStateNormal];
//        } else if (klass == [OrderTextFieldCell class]) {
//            [[(OrderTextFieldCell*)cell textField] setDelegate:self];
//        } else if (klass == [OrderOptionCell class]) {
//            self.optionsView = [(OrderOptionCell *)cell scrollView];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    
//    cell.textLabel.text = item[kCellTitleKey];
//    if (klass == [OrderViewCell class]) {
//        cell.detailTextLabel.text = item[kCellContentKey];
//    } else if (klass == [OrderTextFieldCell class] || klass == [OrderStepperCell class]) {
//        UITextField *textField = [(OrderStepperCell *)cell textField];
//        [textField setText:item[kCellContentKey]];
//        if (klass == [OrderStepperCell class]) {
//            self.countField = textField;
//        } else {
//            textField.tag = kRecipientTag + indexPath.row;
//            if (indexPath.row == 2) {
//                textField.keyboardType = UIKeyboardTypeNumberPad;
//            } else {
//                textField.keyboardType = UIKeyboardTypeDefault;
//            }
//        }
//    } else if (klass == [OrderPhoneCell class]) {
//        cell.detailTextLabel.text = item[kCellContentKey];
//    } else if (klass == [OrderExpressCell class]) {
//        cell.detailTextLabel.text = item[kCellContentKey];
//        cell.accessoryType = self.expressArray.count > 1 ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
//
//    }else if(klass == [OrderNextButtonCell class]){
//        cell.backgroundView=nil;
//        cell.backgroundColor=[UIColor clearColor];
//        cell.contentView.backgroundColor=[UIColor clearColor];
//    }
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    id item = self.cells[indexPath.section][indexPath.row];
//    Class klass = NSClassFromString(item[kCellIdentifierKey]);
//    if (klass == [OrderPhoneCell class]) {
//        if (![SESSION didLogin]) {
//            [self showLoginView];
//            return;
//        };
//        BindMobileViewController * c = [[BindMobileViewController alloc]
//                                        initWithNibName:@"BindMobileViewController" bundle:nil];
//        [self.navigationController pushViewController:c animated:YES];
//    } else if (klass == [OrderStepperCell class]) {
//        [self.view endEditing:YES];
//    } else if (klass == [OrderExpressCell class]) {
//        if (self.expressArray.count > 1) {
//            _pickerWrapperExpress.top = self.view.height - _pickerWrapperExpress.height;
//            [self.view addSubview:_pickerWrapperExpress];
//        }
//    }
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.tracking) {
//        [self.view endEditing:YES];
//    }
//}
//
//- (void)resizerDidShrink:(KeyboardEventResizer *)resizer
//{
//
//}
//
//@end
