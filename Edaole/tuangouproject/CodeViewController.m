//
//  ViewController.m
//  QR code
//
//  Created by 斌 on 12-8-2.
//  Copyright (c) 2012年 斌. All rights reserved.
//

#import "CodeViewController.h"
#import "QRCodeGenerator.h"

@interface CodeViewController ()

@end

@implementation CodeViewController
@synthesize imageview;
@synthesize text;
@synthesize label;
@synthesize shopname;
@synthesize imageview_down;
@synthesize shopname_down;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *bn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [bn setBackgroundImage:[UIImage imageNamed:@"btn_back_normal.png"] forState:UIControlStateNormal];
        [bn setBackgroundImage:[UIImage imageNamed:@"btn_back_hilight.png"] forState:UIControlStateHighlighted];
        self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:bn];
        [bn setTitle:@"返回" forState:UIControlStateNormal];
        bn.titleLabel.font=[UIFont systemFontOfSize:15];
        [bn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [bn addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];

    }
    return  self;
    
}


- (void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    text.text = shopname;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self performBlock:^{
        NSString *str = [NSString stringWithFormat:@"%@,%@", shopname, shopname_down];
        imageview.image = [QRCodeGenerator qrImageForString:str imageSize:imageview.bounds.size.width*2];
        up.text = shopname;
        down.text = [NSString stringWithFormat:@"密码:%@",shopname_down];
        imageview_down.hidden = YES;
        /*
         imageview.image = [QRCodeGenerator qrImageForString:shopname imageSize:imageview.bounds.size.width];
         imageview_down.image = [QRCodeGenerator qrImageForString:shopname_down imageSize:imageview.bounds.size.width];
         */
        self.codeBg.image=self.codeBgImage;
    } afterDelay:0.1];
}

- (void)consumed:(BOOL)consumed
{
    if (consumed) {
        self.codeBgImage=[[UIImage imageNamed:@"detail_coupon_usedbg@2x.png"] stretchableImageWithLeftCapWidth:100 topCapHeight:0];
    }else{
        self.codeBgImage=[[UIImage imageNamed:@"detail_coupon_newbg@2x.png"] stretchableImageWithLeftCapWidth:100 topCapHeight:0];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [text resignFirstResponder];
}

- (void)viewDidUnload
{
    [self setLabel:nil];
    [self setImageview:nil];
    [self setText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

/*
- (IBAction)button:(id)sender {
    扫描二维码部分：
    导入ZBarSDK文件并引入一下框架
    AVFoundation.framework
    CoreMedia.framework
    CoreVideo.framework
    QuartzCore.framework
    libiconv.dylib
    引入头文件#import “ZBarSDK.h” 即可使用
    当找到条形码时，会执行代理方法
    
    - (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
    
    最后读取并显示了条形码的图片和内容。
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentModalViewController: reader
                            animated: YES];
}
*/
- (IBAction)button2:(id)sender {
    /*字符转二维码
     导入 libqrencode文件
     引入头文件#import "QRCodeGenerator.h" 即可使用
     */
	imageview.image = [QRCodeGenerator qrImageForString:text.text imageSize:imageview.bounds.size.width];
    
    [text resignFirstResponder];
}

- (IBAction)Responder:(id)sender {
    //键盘释放
    [text resignFirstResponder];

}
/*
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    imageview.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    [reader dismissModalViewControllerAnimated: YES];
    
    //判断是否包含 头'http:'
    NSString *regex = @"http+:[^\\s]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    //判断是否包含 头'ssid:'
    NSString *ssid = @"ssid+:[^\\s]*";;
    NSPredicate *ssidPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",ssid];
    
    label.text =  symbol.data ;
    NSLog(@"---------%@--------",label.text);
    
    if ([predicate evaluateWithObject:label.text]) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil
                                                        message:@"It will use the browser to this URL。"
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:@"Ok", nil];
        alert.delegate = self;
        alert.tag=1;
        [alert show];
        
        
        
    }
    else if([ssidPre evaluateWithObject:label.text]){

        NSArray *arr = [label.text componentsSeparatedByString:@";"];
        
        NSArray * arrInfoHead = [[arr objectAtIndex:0] componentsSeparatedByString:@":"];
        
        NSArray * arrInfoFoot = [[arr objectAtIndex:1] componentsSeparatedByString:@":"];
        
        
        label.text=
        [NSString stringWithFormat:@"ssid: %@ \n password:%@",
         [arrInfoHead objectAtIndex:1],[arrInfoFoot objectAtIndex:1]];
        
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:label.text
                                                        message:@"The password is copied to the clipboard , it will be redirected to the network settings interface"
                                                       delegate:nil
                                              cancelButtonTitle:@"Close"
                                              otherButtonTitles:@"Ok", nil];
        
        
        alert.delegate = self;
        alert.tag=2;
        [alert show];
        
        UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
        //        然后，可以使用如下代码来把一个字符串放置到剪贴板上：
        pasteboard.string = [arrInfoFoot objectAtIndex:1]; 
        
    }
}
*/

@end
