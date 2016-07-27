//
//  ViewController.m
//  MutipeerConnectivity
//
//  Created by Allen on 16/7/27.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import "ViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

/*
 1/设置可被发现
 2/扫描设备
 3/储存当前会话
 4/发送和接收数据
 */

#define SER_TYPE @"allen"
@interface ViewController ()<MCBrowserViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MCSessionDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *showimg;
@property (nonatomic,strong)MCSession *session;
@property (nonatomic,strong)MCAdvertiserAssistant *assistant;
@property (nonatomic,strong)MCPeerID *otherId;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MCPeerID *peerId = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
    self.session = [[MCSession alloc]initWithPeer:peerId];
    self.session.delegate = self;
}


- (IBAction)connect:(id)sender {
    
    MCBrowserViewController *bro = [[MCBrowserViewController alloc] initWithServiceType:SER_TYPE session:self.session];
    [self presentViewController:bro animated:YES completion:nil];
    bro.delegate = self;
    
}
- (IBAction)select:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}
- (IBAction)send:(id)sender {
    if(!self.showimg.image) return;
    //send
    [self.session sendData:UIImagePNGRepresentation(self.showimg.image) toPeers:@[self.otherId] withMode:MCSessionSendDataUnreliable error:nil];
    
}
//设置被发现
- (IBAction)found:(id)sender {
    UISwitch *s = (UISwitch *)sender;
   
    if(s.isOn){
        
        self. assistant = [[MCAdvertiserAssistant alloc]initWithServiceType:SER_TYPE discoveryInfo:nil session:self.session];
        [self.assistant start];
    }else
    {
        [self.assistant stop];
    }
}
#pragma Mark - MCBrowserViewControllerDelegate

//连接成功
- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    NSLog(@"%s   %d",__func__,__LINE__);
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

//退出
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    
}

//设备信息
- (BOOL)browserViewController:(MCBrowserViewController *)browserViewController
      shouldPresentNearbyPeer:(MCPeerID *)peerID
            withDiscoveryInfo:(nullable NSDictionary<NSString *, NSString *> *)info
{
    self.otherId = peerID;
     NSLog(@"%s   %d",__func__,__LINE__);
    return YES;
}

#pragma Mark - ImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    self.showimg.image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma Mark - sessionDelegate
//接受
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.showimg.image = [UIImage imageWithData:data];
    });

}
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{

}


- (void)    session:(MCSession *)session
   didReceiveStream:(NSInputStream *)stream
           withName:(NSString *)streamName
           fromPeer:(MCPeerID *)peerID{

}


- (void)                    session:(MCSession *)session
  didStartReceivingResourceWithName:(NSString *)resourceName
                           fromPeer:(MCPeerID *)peerID
                       withProgress:(NSProgress *)progress{

}

- (void)                    session:(MCSession *)session
 didFinishReceivingResourceWithName:(NSString *)resourceName
                           fromPeer:(MCPeerID *)peerID
                              atURL:(NSURL *)localURL
                          withError:(nullable NSError *)error{

}












@end
