//
//  CPExtend(UIWebView).swift
//  swift-OC
//
//  Created by mac on 2019/4/23.
//  Copyright © 2019年 bo. All rights reserved.
//

import Foundation
import WebKit

struct WebViewJavaScriptElement {
    typealias TagCountType = (String)->String
    let href = "document.location.href";
    let title = "document.title";
    
    var tagCount: TagCountType = { (jsString) in
        return "document.getElementsByTagName('\(jsString)').length";
    }
    var allClickLink: TagCountType = { (jsString) in
        return "document.getElementsByTagName('a')[\(jsString)].getAttribute('onclick')";
    }
    
}

extension WKWebView {
    /// 获取某个标签的结点个数
    public func nodeCount(_ tag: String, completionHandler: @escaping (Any?, Error?) -> Void) {
        let jsString = WebViewJavaScriptElement().tagCount(tag);
        self.evaluateJavaScript(jsString) { (response, error) in
            print("\(tag) 标签的数量 \(String(describing: response!))");
            completionHandler(response, error);
        }
    }
    /// 获取当前页面URL
    public func getCurrentURL(_ completionHandler: @escaping (Any?, Error?) -> Void) {
        let jsString = WebViewJavaScriptElement().href;
        self.evaluateJavaScript(jsString) { (response, error) in
            completionHandler(response, error);
        }
    }
    /// 获取当前页面标题
    public func getTitle(_ completionHandler: @escaping (Any?, Error?) -> Void) {
        let jsString = WebViewJavaScriptElement().title;
        self.evaluateJavaScript(jsString) { (response, error) in
            completionHandler(response, error);
        }
    }
    /// 获取当前页面所有点击链接
    public func getOnClicks(_ completionHandler: @escaping (Array<Any?>?, Error?) -> Void) {
        var allOnClicks: [Any?] = [];
        nodeCount("a") { (count, error) in
            for i in 0..<(count as! Int) {
                let jsString = WebViewJavaScriptElement().allClickLink(String(i));
                self.evaluateJavaScript(jsString) { (response, error) in
                    if !(response is NSNull) {
                        allOnClicks.append(response);
                    }
                    if i >= (count as! Int) {
                        completionHandler(allOnClicks, error);
                    }
                }
            }
        }
    }
}
