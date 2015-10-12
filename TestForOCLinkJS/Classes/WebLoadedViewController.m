//
//  WebLoadedViewController.m
//  webDataLoadedDemo
//
//  Created by tony on 10/9/15.
//  Copyright © 2015 noahwm. All rights reserved.
//

#import "WebLoadedViewController.h"

#import "WebViewJavascriptBridge.h"

#import "MJRefresh.h"

@interface WebLoadedViewController ()


@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) WebViewJavascriptBridge *javascriptBradge;

@property (nonatomic, strong) WVJBResponseCallback responseCallback;

@end

@implementation WebLoadedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"webView 加载更多";
    
    [self bradgeCallBack];
    
    [self.webView.scrollView addLegendFooterWithRefreshingBlock:^{
        
    }];
    self.webView.scrollView.footer.backgroundColor = [UIColor clearColor];
    self.webView.scrollView.footer.automaticallyRefresh = FALSE;
    [self.webView.scrollView.footer setTitle:@"上拉加载更多..." forState:MJRefreshFooterStateIdle];
    
    [self.webView.scrollView addLegendHeaderWithRefreshingBlock:^{
        [self bankListInfo:1];
    }];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"bank_list" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    [self webViewHeadbeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)bradgeCallBack{
    [WebViewJavascriptBridge enableLogging];
    
    self.javascriptBradge = [WebViewJavascriptBridge bridgeForWebView:self.webView handler:nil];
    
    [self.javascriptBradge registerHandler:@"loadMore" handler:^(id data, WVJBResponseCallback responseCallback) {
        self.responseCallback = responseCallback;
        [self bankListInfo:[data integerValue]];
        NSLog(@"%@, self.res %@", responseCallback, self.responseCallback);
    }];
}

- (void)bankListInfo:(NSInteger)pageIndex{
    if (pageIndex != 1) {
        [self webViewFooterbeginRefreshing];
    }
    
    NSString *bankJson1 = @"[{\"amountlimitdesc\":\"单笔单日1万\",\"phone\":\"95580\",\"bankName\":\"邮储银行\",\"bankCode\":\"934\",\"tiecardflag\":\"N\",\"capitalmode\":\"r\"},{\"amountlimitdesc\":\"单笔100万（不含100万）,单日500万\",\"phone\":\"95511\",\"bankName\":\"平安银行\",\"bankCode\":\"920\",\"tiecardflag\":\"N\",\"capitalmode\":\"r\"},{\"amountlimitdesc\":\"单笔300万,单日不限\",\"phone\":\"95508\",\"bankName\":\"广发银行\",\"bankCode\":\"016\",\"tiecardflag\":\"N\",\"capitalmode\":\"r\"},{\"amountlimitdesc\":\"单笔300万,单日不限\",\"phone\":\"95558\",\"bankName\":\"中信银行\",\"bankCode\":\"015\",\"tiecardflag\":\"N\",\"capitalmode\":\"r\"},{\"amountlimitdesc\":\"单笔100万,单日不限\",\"phone\":\"95568\",\"bankName\":\"民生银行\",\"bankCode\":\"014\",\"tiecardflag\":\"N\",\"capitalmode\":\"r\"}]";
    NSString *bankJson2 = @"[{\"amountlimitdesc\":\"单笔1万,单日不限\",\"phone\":\"95561\",\"bankName\":\"兴业银行\",\"bankCode\":\"011\",\"tiecardflag\":\"N\",\"capitalmode\":\"r\"},{\"amountlimitdesc\":\"单笔单日5万\",\"phone\":\"95528\",\"bankName\":\"浦发银行\",\"bankCode\":\"010\",\"tiecardflag\":\"N\",\"capitalmode\":\"r\"},{\"amountlimitdesc\":\"单笔300万,单日不限\",\"phone\":\"95595\",\"bankName\":\"光大银行\",\"bankCode\":\"009\",\"tiecardflag\":\"N\",\"capitalmode\":\"r\"},{\"amountlimitdesc\":\"单笔单日1万\",\"phone\":\"95580\",\"bankName\":\"邮储银行\",\"bankCode\":\"934\",\"tiecardflag\":\"N\",\"capitalmode\":\"r\"},{\"amountlimitdesc\":\"单笔100万（不含100万）,单日500万\",\"phone\":\"95511\",\"bankName\":\"平安银行\",\"bankCode\":\"920\",\"tiecardflag\":\"N\",\"capitalmode\":\"r\"},{\"amountlimitdesc\":\"单笔300万,单日不限\",\"phone\":\"95508\",\"bankName\":\"广发银行\",\"bankCode\":\"016\",\"tiecardflag\":\"N\",\"capitalmode\":\"r\"},{\"amountlimitdesc\":\"单笔300万,单日不限\",\"phone\":\"95558\",\"bankName\":\"中信银行\",\"bankCode\":\"015\",\"tiecardflag\":\"N\",\"capitalmode\":\"r\"},{\"amountlimitdesc\":\"单笔100万,单日不限\",\"phone\":\"95568\",\"bankName\":\"民生银行\",\"bankCode\":\"014\",\"tiecardflag\":\"N\",\"capitalmode\":\"r\"},{\"amountlimitdesc\":\"单笔单日1万\",\"phone\":\"95580\",\"bankName\":\"邮储银行\",\"bankCode\":\"934\",\"tiecardflag\":\"N\",\"capitalmode\":\"r\"},{\"amountlimitdesc\":\"单笔100万（不含100万）,单日500万\",\"phone\":\"95511\",\"bankName\":\"平安银行\",\"bankCode\":\"920\",\"tiecardflag\":\"N\",\"capitalmode\":\"r\"},{\"amountlimitdesc\":\"单笔300万,单日不限\",\"phone\":\"95508\",\"bankName\":\"广发银行\",\"bankCode\":\"016\",\"tiecardflag\":\"N\",\"capitalmode\":\"r\"},{\"amountlimitdesc\":\"单笔300万,单日不限\",\"phone\":\"95558\",\"bankName\":\"中信银行\",\"bankCode\":\"015\",\"tiecardflag\":\"N\",\"capitalmode\":\"r\"},{\"amountlimitdesc\":\"单笔100万,单日不限\",\"phone\":\"95568\",\"bankName\":\"民生银行\",\"bankCode\":\"014\",\"tiecardflag\":\"N\",\"capitalmode\":\"r\"}]";
    
    
    NSString *bankJson3 = @"[{\"amountlimitdesc\":\"单笔100万,单日不限\",\"phone\":\"95568\",\"bankName\":\"民生银行\",\"bankCode\":\"014\",\"tiecardflag\":\"N\",\"capitalmode\":\"r\"},{\"amountlimitdesc\":\"单笔1万,单日不限\",\"phone\":\"95561\",\"bankName\":\"兴业银行\",\"bankCode\":\"011\",\"tiecardflag\":\"N\",\"capitalmode\":\"r\"},{\"amountlimitdesc\":\"单笔单日5万\",\"phone\":\"95528\",\"bankName\":\"浦发银行\",\"bankCode\":\"010\",\"tiecardflag\":\"N\",\"capitalmode\":\"r\"},{\"amountlimitdesc\":\"单笔300万,单日不限\",\"phone\":\"95595\",\"bankName\":\"光大银行\",\"bankCode\":\"009\",\"tiecardflag\":\"N\",\"capitalmode\":\"r\"}]";
    NSArray *jsonArr = @[bankJson1, bankJson2, bankJson3];
    NSString *str =   [jsonArr objectAtIndex:pageIndex%3];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (pageIndex == 1) {
            [self.javascriptBradge callHandler:@"getBankList" data:str];
        }else{
            self.responseCallback(str);
        }
         [self webViewEndRefresh];
    });
}

- (void)webViewHeadbeginRefreshing{
    [self.webView.scrollView.header beginRefreshing];
}

- (void)webViewFooterbeginRefreshing{
//    self.webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 40, 0);

    [self.webView.scrollView.footer beginRefreshing];
}

- (void)webViewEndRefresh{
    [self.webView.scrollView.header endRefreshing];
    [self.webView.scrollView.footer endRefreshing];
}

@end
