/**
 *  @author Nico, 16-04-07 09:04:44
 *
 *  调用指纹识别
 *
 *  @param describe 需要使用指纹识别的原因描述
 *  @param complete 回调的block
 */
- (void) anthTouchID:(NSString *) describe complete:(void(^)(NSString *backStr)) complete
{
    //检查操作系统是否达到指纹识别要求
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        //检查Touch ID是否可用
        LAContext *anthContext = [[LAContext alloc]init];
        NSError *error = [[NSError alloc]init];
        
        BOOL touchIDAvailable = [anthContext canEvaluatePolicy:kLAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
        
        if (touchIDAvailable) {
            
            //指纹识别可用，获取验证结果
            [anthContext evaluatePolicy:kLAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:describe reply:^(BOOL success, NSError * _Nullable error) {
                
                    //加入主线程中执行
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (success) {
                            
                            //验证通过
                            if (complete) {
                                complete(@"success");
                            }
                            
                        } else {
                            
                            //验证失败
                            if (complete) {
                                complete(error.localizedDescription);
                            }
                        }
                    });
            }];
            
        } else {
            
            //指纹识别不可用
            if (complete) {
                complete(error.localizedDescription);
            }
        }
        
    } else {
        
        //设备操作系统版本过低
        if (complete) {
            complete(@"Device system version too low.");
        }
    }
}
