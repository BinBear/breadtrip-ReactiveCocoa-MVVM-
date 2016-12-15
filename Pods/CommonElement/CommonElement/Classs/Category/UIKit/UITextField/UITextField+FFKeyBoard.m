

#import "UITextField+FFKeyBoard.h"

@implementation UITextField (FFKeyBoard)

/**
 *  适配屏幕
 */
-(void)autoAdaptationKeyBoard{
    
    //开始编辑
    [self addTarget:self action:@selector(editingBegin) forControlEvents:UIControlEventEditingDidBegin];
    //结束编辑
    [self addTarget:self action:@selector(editingEnd) forControlEvents:UIControlEventEditingDidEnd];
}

-(void)editingBegin{
    
    //NSLog(@"%s",__FUNCTION__);
    
    //适配键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
}

-(void)editingEnd{
    
    //NSLog(@"%s",__FUNCTION__);
    
    //移除观察
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    
}

-(void)keyBoardWillHide:(NSNotification *)not{
    
    self.window.frame = [UIScreen mainScreen].bounds;
    
}

-(void)keyBoardWillShow:(NSNotification *)not{
    
    //获得键盘的frame
    CGRect keyboadRect = [not.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    //是否被键盘遮挡CGRectGetMaxY(self.frame)
    
    CGRect tfRect=[self.window convertRect:self.frame fromView:self.superview];
    
    NSInteger distance = tfRect.origin.y- keyboadRect.origin.y+tfRect.size.height;

    if (distance > 0) {
        
        self.window.frame = CGRectMake(0, -distance, self.window.frame.size.width, self.window.frame.size.height);
        
    }
    
    
    
}

#pragma mark- 废弃方法
#if 1
/*=================废弃方法===============*/
/**
 *  获得UITextField所在的控制器对象
 *
 *  @return UITextField所在的控制器对象
 */
-(UIViewController *)getViewController{
    
    for (UIView *view = self.superview; view; view = view.superview) {
        
        UIResponder *responder = [view nextResponder];
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        
    }
    
    return nil;
}
#endif



@end
