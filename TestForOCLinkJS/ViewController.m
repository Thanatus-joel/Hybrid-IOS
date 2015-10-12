//
//  ViewController.m
//  TestForOCLinkJS
//
//  Created by Horex on 15/6/26.
//  Copyright (c) 2015年 Horex. All rights reserved.
//

#import "ViewController.h"


#import "WebViewJavascriptBridge.h"

@interface ViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;
@property (nonatomic, strong) WebViewJavascriptBridge *javascriptBradge;

@end

@implementation ViewController


/**
 *  JS 和 OC 互调的Demo OC的Log在控制台中打印，JS的Log用Alter打印
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化控件
    UIButton *rightRefreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightRefreshBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightRefreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    [rightRefreshBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightRefreshBtn addTarget:self action:@selector(refreshWebView) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightRefreshBtn];
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(self.view.frame.size.width / 2  +  50, self.view.frame.size.height / 2 + 100, 100, 40);
    [sendBtn setTitle:@"Send" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendBtn];
    
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    callBtn.frame = CGRectMake(50, self.view.frame.size.height / 2 + 100, 100, 40);
    [callBtn setTitle:@"Call" forState:UIControlStateNormal];
    [callBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callBtn];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height / 2)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    // 使用桥接文件
    [WebViewJavascriptBridge enableLogging];
    
    // 创建桥接
    // JS send方法会在block中回调
    self.javascriptBradge = [WebViewJavascriptBridge bridgeForWebView:self.webView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"OC收到了JS的Send数据了: %@",data);

    }];
    
    
    //    js -> oc   这里注意testObjcCallback这个方法的标示。html那边的命名要跟ios这边相同，才能调到这个方法。当然这个名字可以两边商量着自定义。简单明确即可。
    [self.javascriptBradge registerHandler:@"responseSomeString" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"OC收到了JS的Call方法在这里调用:%@",data);
    }];
    
    [self loadExamplePage:self.webView];
}



- (void)loadExamplePage:(UIWebView*)webView {
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:NULL];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
    
}
- (void)refreshWebView{
    
    [self.webView reload];
}

- (void)call{
    //    oc调js方法Call（通过data可以传值 ）
//    [self.javascriptBradge callHandler:@"getMeSomeString" data:@"asdfg"];
    [self.javascriptBradge callHandler:@"getMeSomeString" data:@"123" responseCallback:^(id responseData) {
        NSLog(@"JS收到了该方法--%@",responseData)
        ;
    }];

}

- (void)send
{
    //    oc调js方法Send (send:data)
    [self.javascriptBradge send:@"321" responseCallback:^(id responseData) {
        NSLog(@"JS收到了Send方法--%@",responseData)
        ;
}];
}


@end
