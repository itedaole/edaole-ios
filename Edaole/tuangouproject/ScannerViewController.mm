////
////  ScannerViewController.m
////  tuangouproject
////
////  Created by  na on .
////  Copyright (c) 2013年 liu song. All rights reserved.
////
//
//#import "ScannerViewController.h"
//#import "QRCodeReader.h"
//#import "ASIHTTPRequest.h"
//#import "SVProgressHUD.h"
//
//static const CGFloat kOverlayColor = 0.2;
//
//@interface ScannerViewController () <ASIHTTPRequestDelegate, UIAlertViewDelegate, UITextFieldDelegate>
//@property (strong, nonatomic) ASIHTTPRequest *checkReq;
//@property (strong, nonatomic) ASIHTTPRequest *consumeReq;
//@property (strong, nonatomic) NSString *code;
//@property (strong, nonatomic) NSString *pass;
//@property (strong, nonatomic) UITextField *codeField;
//@property (strong, nonatomic) UITextField *passField;
//@property (strong, nonatomic) UIButton *switchButton;
//@end
//
//@implementation ScannerViewController
//
//- (id)initWithDelegate:(id<ZXingDelegate>)scanDelegate
//            showCancel:(BOOL)shouldShowCancel
//              OneDMode:(BOOL)shouldUseoOneDMode
//           showLicense:(BOOL)shouldShowLicense
//{
//    self = [super initWithDelegate:self showCancel:shouldShowCancel OneDMode:shouldUseoOneDMode showLicense:NO];
//    if (self) {       
//        QRCodeReader* qrcodeReader = [[QRCodeReader alloc] init];
//        self.readers = [NSMutableSet setWithObject:qrcodeReader];
////        self.soundToPlay = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"beep-beep" ofType:@"caf"]];
//    }
//    return self;
//}
//
//- (void)dealloc
//{
//    [self.checkReq cancel];
//    [self.consumeReq cancel];
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//	self.delegate = self;
//    
//    self.overlayView.cancelButtonTitle = @"取消";
//    self.overlayView.displayedMessage = @"";
//    self.overlayView.backgroundColor = [UIColor colorWithWhite:kOverlayColor alpha:1];
//    
//    CGFloat width = (self.view.width - 40);
//
//    self.codeField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, width, 30)];
//    self.codeField.placeholder = @"团购券号";
//    self.codeField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    self.codeField.borderStyle = UITextBorderStyleRoundedRect;
//    self.codeField.keyboardType = UIKeyboardTypeASCIICapable;
//    self.codeField.returnKeyType = UIReturnKeyNext;
//    self.codeField.delegate = self;
//    [self.overlayView addSubview:self.codeField];
//    
//    self.passField = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, width, 30)];
//    self.passField.placeholder = @"团购券密码";
//    self.passField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    self.passField.keyboardType = UIKeyboardTypeASCIICapable;
//    self.passField.borderStyle = UITextBorderStyleRoundedRect;
//    self.passField.returnKeyType = UIReturnKeySend;
//    self.passField.delegate = self;
//    [self.overlayView addSubview:self.passField];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [button setTitle:@"二维码扫描" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(onSwitchQR:) forControlEvents:UIControlEventTouchUpInside];
//    [button sizeToFit];
//    button.origin = CGPointMake(20, CGRectGetMaxY(self.passField.frame) + 20);
//    
//    self.switchButton = button;
//    
//    [self.overlayView addSubview:button];
//    
//    [self stopCapture];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (void)onSwitchQR:(id)sender
//{
//    if (self.running) {
//        [self stopCapture];
//        self.overlayView.backgroundColor = [UIColor colorWithWhite:kOverlayColor alpha:1];
//        self.codeField.hidden = self.passField.hidden = NO;
//        [self.switchButton setTitle:@"二维码扫描" forState:UIControlStateNormal];
//        self.switchButton.transform = CGAffineTransformIdentity;
//    } else {
//        [self startCapture];
//        self.overlayView.backgroundColor = [UIColor clearColor];
//        self.codeField.hidden = self.passField.hidden = YES;
//        [self.switchButton setTitle:@"手动输入" forState:UIControlStateNormal];
//        [self.view bringSubviewToFront:self.overlayView];
//        self.switchButton.transform = CGAffineTransformMakeTranslation(0, - (self.switchButton.origin.y - 20));
//    }
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
//}
//
//- (void)showAlert:(NSString *)format, ...
//{
//    va_list ap;
//    va_start(ap, format);
//    NSString *string = [[NSString alloc]initWithFormat:format arguments:ap];
//    va_end(ap);
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string
//                                                    message:nil
//                                                   delegate:self
//                                          cancelButtonTitle:@"确认"
//                                          otherButtonTitles: nil];
//    [alert show];
//}
//
//- (void)checkCode:(NSString *)code pass:(NSString *)pass
//{
//    self.code = code; self.pass = pass;
//    [SVProgressHUD showWithStatus:@"校验中"];
//    NSString *url = TGURL(@"Partner/verifyCoupon", @{@"code": self.code});
//    [self.checkReq cancel];
//    self.checkReq = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
//    self.checkReq.delegate = self;
//    [self.checkReq startAsynchronous];
//
//}
//
//- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)r
//{
//    r = [r stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    NSArray *parts = [r componentsSeparatedByString:@","];
//    if ([parts count] != 2) {
//        [self showAlert:@"不是有效的团购卷"];
//        return;
//    }
//    self.code = [parts objectAtIndex:0];
//    self.pass = [parts objectAtIndex:1];
//    [self checkCode:self.code pass:self.pass];
//}
//
//- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller
//{
//    [self dismissModalViewControllerAnimated:YES];
//}
//
//- (void)showConsumeTip:(NSDictionary *)productInfo
//{
//    NSString *title = productInfo[@"product"];
//    NSString *summary = productInfo[@"summary"];
//    
//    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"团购卷验证成功, %@", title]
//                                message:[NSString stringWithFormat:@"是否消费团购卷: %@, %@",self.code, summary]
//                               delegate:self
//                      cancelButtonTitle:@"取消"
//                      otherButtonTitles:@"消费", nil] show];
//}
//
//- (void)doConsume
//{
//    NSString *url = [NSString stringWithFormat:TGURLByPath(@"/ajax/coupon.php?action=consume&id=%@&secret=%@"), self.code, self.pass];
//    NSLog(@"url: %@", [NSURL URLWithString:url]);
//    [self.consumeReq cancel];
//    self.consumeReq = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
//    self.consumeReq.delegate = self;
//    [SVProgressHUD showWithStatus:@"消费中"];
//    [self.consumeReq startAsynchronous];
//
//}
//
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex != alertView.cancelButtonIndex) {
//        [self doConsume];
//    } else {
//        [self restartDecode];
//    }
//}
//
//- (void)requestFinished:(id)request
//{
//    if (request == self.checkReq) {
//        self.checkReq = nil;
//        NSDictionary *d = [[request responseData] objectFromJSONData];
//        if ([[d valueForKey:@"status"] integerValue] == 1) {
//            [SVProgressHUD dismiss];
//            [self showConsumeTip:[d valueForKeyPath:@"team"]];
//        } else {
//            NSDictionary *d = [[request responseData] objectFromJSONData];
//            [self showAlert:[d objectForKey:@"result"]?[d objectForKey:@"result"]:@"团购卷验证失败"];
////            [SVProgressHUD showErrorWithStatus:@"团购卷验证失败"];
//            [SVProgressHUD dismiss];
////            [self restartDecode];
//        }
//    } else if (request == self.consumeReq) {
//        [SVProgressHUD dismiss];
//        self.consumeReq = nil;
//        NSDictionary *d = [[request responseData] objectFromJSONData];
//        if ([[d valueForKey:@"error"] integerValue] == 0) {
//            self.code = nil;
//            self.pass = nil;
//            NSString *data = [d valueForKeyPath:@"data.html"];
//            if ([data isKindOfClass:[NSNull class]]) data = nil;
//            self.codeField.text = @"";
//            self.passField.text = @"";
//            [self showAlert:data ? data : @"己消费"];
//        } else {
//            [self showAlert:@"数据异常"];
//        }
//    }
//}
//
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    if (textField == self.passField) {
//        if (self.codeField.text.length > 0 && self.passField.text.length > 0) {
//            [self checkCode:self.codeField.text pass:self.passField.text];
//        }
//    } else {
//        if (self.codeField.text.length == 0) {
//            [textField resignFirstResponder];
//            return NO;
//        } else {
//            [self.passField becomeFirstResponder];
//        }
//    }
//    return YES;
//}
//
//- (void)requestFailed:(id)request
//{
//    [SVProgressHUD dismiss];
//    [self showAlert:@"网络异常"];
//    if (request == self.checkReq) {
//        self.checkReq = nil;
//    } else {
//        self.consumeReq = nil;
//    }
//}
//@end
