//
//  IPManagerPageVC.m
//  IPManagerDemo
//
//  Created by Ted Liu on 2017/3/6.
//  Copyright © 2017年 Ted Liu. All rights reserved.
//  IP管理器主界面

#import "IPManagerPageVC.h"
#import "IPManager.h"
#import "IPManagerPageCell.h"
#import "CoreStatus.h"
#import "WLDecimalKeyboard.h"

static NSString *kTLIPManager = @"kTLIPManager";
static NSString *reuseIdentifier = @"IPManagerListCell";
#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface IPManagerPageVC ()<CoreStatusProtocol,UITableViewDelegate,UITableViewDataSource>
/**
 ip数据源数组
 */
@property (nonatomic, strong) NSMutableArray *listArray;
/**
 确认按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
/**
 当前网络状态
 */
@property (weak, nonatomic) IBOutlet UILabel *currentNetwork;
/**
 当前网络IP
 */
@property (weak, nonatomic) IBOutlet UILabel *currentIP;
/**
 ip输入框集合
 */
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *inputIPs;
/**
 列表父视图
 */
@property (weak, nonatomic) IBOutlet UIView *tableListView;
/**
 当前数据列表
 */
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation IPManagerPageVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupButtonItem];
    [self setupNormalStyle];
    [self updateNetworkData];
    [self setupShowRefresh];
    // 开始监听网络状态
    [CoreStatus beginNotiNetwork:self];
}
- (void) setupShowRefresh
{
    [self setupNormalModel];
    // 初始化列表控件
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.tableListView.frame.size.height) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = rgba(247, 247, 247, 1.0f);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 45.0f;
    
    [self.tableListView addSubview:self.tableView];
    
}

/**
 设置默认数据
 */
- (void) setupNormalModel
{
    // 初始化数据源
    NSMutableDictionary *modelDic = [[NSMutableDictionary alloc] initWithDictionary:[NSKeyedUnarchiver  unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kTLIPManager]]];
    
    if (!modelDic[@"dataArr"] || !modelDic[@"dataDic"]) {
        self.listArray = [[NSMutableArray alloc] init];
        return;
    }
    
    // 对数组进行排序
    NSArray *sortedArray = [modelDic[@"dataArr"] sortedArrayUsingComparator:^NSComparisonResult(IPModel *p1, IPModel *p2){
        return [p2.ipUseTime compare:p1.ipUseTime];
    }];
    self.listArray = [[NSMutableArray alloc] initWithArray:sortedArray];
    
    // 设置默认显示
    IPModel *normalIP = [modelDic objectForKey:@"dataDic"];
    for (int i = 0; i < self.inputIPs.count; i++) {
        UITextField *textField = self.inputIPs[i];
        if (i == 0) {
            textField.text = normalIP.ipInput1;
        }
        else if (i == 1){
            textField.text = normalIP.ipInput2;
        }
        else if (i == 2){
            textField.text = normalIP.ipInput3;
        }
        else if (i == 3){
            textField.text = normalIP.ipInput4;
        }
        else if (i == 4){
            textField.text = normalIP.ipPort;
        }
    }
}
/**
 创建导航栏按钮
 */
- (void) setupButtonItem
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mb_back"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(actionBack)];
    self.navigationItem.leftBarButtonItem  = leftItem;
}
/**
 *  返回事件响应
 */
- (void) actionBack
{
    [CoreStatus endNotiNetwork:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 设置默认样式界面
 */
- (void) setupNormalStyle
{
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationItem setTitle:@"IP地址管理"];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    for (UITextField *textField in self.inputIPs) {
        
        WLDecimalKeyboard *inputView = [[WLDecimalKeyboard alloc] init];
        textField.inputView = inputView;
    }
}

#pragma mark - 获取当前网络状态及名称
- (void) updateNetworkData
{
    // 是否有网络
    if ([CoreStatus isNetworkEnable]) {
        // 是否处于WiFi状态
        if ([CoreStatus isWifiEnable]) {
            self.currentNetwork.text = [NSString stringWithFormat:@"当前网络状态：%@   %@",[CoreStatus currentNetWorkStatusString],[CoreStatus setupGetWifiName]];
            self.currentIP.text = [NSString stringWithFormat:@"当前网络IP地址：%@",[CoreStatus deviceIPAdress]];
        }else{
            self.currentNetwork.text = [NSString stringWithFormat:@"当前网络状态：%@",[CoreStatus currentNetWorkStatusString]];
            self.currentIP.text = [NSString stringWithFormat:@"当前网络IP地址：%@",[CoreStatus deviceWANIPAdress]];
        }
    }else{
        self.currentNetwork.text = [NSString stringWithFormat:@"当前网络状态：%@",[CoreStatus currentNetWorkStatusString]];
        self.currentIP.text = @"当前网络IP地址：0.0.0.0:0000";
    }
}
/** 网络状态变更 */
-(void)coreNetworkChangeNoti:(NSNotification *)noti
{
    [self updateNetworkData];
}
#pragma mark - 按钮响应事件
/**
 清除按钮响应
 */
- (IBAction)actiouTouchClean:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"是否清除所有数据？\n一经删除，将无法恢复，请谨慎操作！"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    [alertView show];
}
/**
 确认按钮响应
 */
- (IBAction)actionTouchDone:(id)sender {
    
    NSString *ipAddress = [self validationIPAddressString];
    
    if (!ipAddress.length) {
        return;
    }
    /**
     *  组装数据
     */
    IPModel *ipModel  = [[IPModel alloc] init];
    ipModel.ipAddress = ipAddress;
    ipModel.ipInput1  = ((UITextField *)self.inputIPs[0]).text;
    ipModel.ipInput2  = ((UITextField *)self.inputIPs[1]).text;
    ipModel.ipInput3  = ((UITextField *)self.inputIPs[2]).text;
    ipModel.ipInput4  = ((UITextField *)self.inputIPs[3]).text;
    ipModel.ipPort    = ((UITextField *)self.inputIPs[4]).text;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    ipModel.ipUseTime = dateTime;
    
    NSString *nowIpStr = [NSString stringWithFormat:@"%@:%@",ipModel.ipAddress,ipModel.ipPort];
    /**
     *   保存数据
     */
    if (self.listArray.count) {
        BOOL flag = YES;
        for (int i = 0; i < self.listArray.count; i ++) {
            
            IPModel *tempMod = (IPModel *)self.listArray[i];
            NSString *tempIpStr = [NSString stringWithFormat:@"%@:%@",tempMod.ipAddress,tempMod.ipPort];
            
            if ([tempIpStr isEqualToString:nowIpStr]) {
                flag = NO;
                [self.listArray replaceObjectAtIndex:i withObject:ipModel];
                [self setupCompletionBlockModel:ipModel];
                return;
            }
        }
        
        if (flag) {
            [self saveDatabase:ipModel];
            [self setupCompletionBlockModel:ipModel];
        }
        
    }else{
        [self saveDatabase:ipModel];
        [self setupCompletionBlockModel:ipModel];
    }
}

/**
 把地址数据回调出去
 */
- (void) setupCompletionBlockModel:(IPModel *) model
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"已切换IP地址为：\n\n%@:%@",model.ipAddress,model.ipPort] message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alertView.tag = 1000;
    [alertView show];
    
    if (self.selectedIPResponseSuceesCompletionBlock) {
        // 回调通知外部改变
        self.selectedIPResponseSuceesCompletionBlock(model);
    }
}
/**
 ip数据保存
 */
- (void) updateDatabase:(IPModel *) ipModel withIndexNum:(NSUInteger ) idx
{
    [self.listArray removeObjectAtIndex:idx];
    
    [self.listArray addObject:ipModel];
    [self.tableView reloadData];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.listArray]
                                              forKey:kTLIPManager];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self actionBack];
}
/**
 ip数据保存
 */
- (void) saveDatabase:(IPModel *) ipModel
{
    NSMutableArray *tempList = [[NSMutableArray alloc] initWithArray:self.listArray];
    [tempList addObject:ipModel];
    
    self.listArray = tempList;
    // 初始化数据源
    NSMutableDictionary *modelDic = [[NSMutableDictionary alloc] initWithDictionary:[NSKeyedUnarchiver  unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kTLIPManager]]];
    [modelDic setObject:self.listArray forKey:@"dataArr"];
    [modelDic setObject:ipModel forKey:@"dataDic"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:modelDic]
                                              forKey:kTLIPManager];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/**
 验证是否已经输入了IP地址
 */
- (NSString *) validationIPAddressString
{
    __block BOOL flag = NO;
    [self.inputIPs enumerateObjectsUsingBlock:^(UITextField *textField, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (!textField.text.length) {
            
             *stop = YES;
            flag = NO;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"请输入正确的IP地址数据"
                                                               delegate:nil cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            
        }else{
            flag = YES;
        }
    }];
    
    if (!flag) {
        return @"";
    }
    // 从输入框中取出值，组装IP地址
    NSString *tempIpAddress = @"";
    for (int i = 0; i < self.inputIPs.count - 1; i ++) {
        UITextField *tempText = (UITextField *)self.inputIPs[i];
        if (i == 0) {
            tempIpAddress = tempText.text;
        }else{
            tempIpAddress = [tempIpAddress stringByAppendingString:[NSString stringWithFormat:@".%@",tempText.text]];
        }
    }
    
    if (![self isIPAddress:tempIpAddress]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入正确的IP地址数据"
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
        return @"";
    }else{
        return tempIpAddress;
    }
}
#pragma mark - UIAlertViewDelete
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        [self actionBack];
    }
    else{
        // 清空数组
        [self.listArray removeAllObjects];
        // 刷新当前列表
        [self.tableView reloadData];
        // 保存数据
        NSMutableDictionary *modelDic = [[NSMutableDictionary alloc] initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kTLIPManager]]];
        
        [modelDic setObject:self.listArray forKey:@"dataArr"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:modelDic]
                                                  forKey:kTLIPManager];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger strLength = textField.text.length - range.length + string.length;
    if ([string isEqualToString:@"."]) {
        
        [self.inputIPs enumerateObjectsUsingBlock:^(UITextField *textObj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (textObj == textField) {
                *stop = YES;
                [textField resignFirstResponder];
                if ((idx + 1) < self.inputIPs.count) {
                    UITextField *tempObj = self.inputIPs[idx + 1];
                    tempObj.text = @"";
                    [tempObj becomeFirstResponder];
                }
            }
        }];
    }
    if (textField == self.inputIPs[4]) {
        return [self isJudgeNum:string] && (strLength <= 4);
    }else{
        return [self isJudgeNum:string] && (strLength <= 3);
    }
}


#pragma mark - IP地址校验
- (BOOL)isIPAddress:(NSString *) ipAddress
{
    NSString *regex = [NSString stringWithFormat:@"^(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})$"];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL rc = [pre evaluateWithObject:ipAddress];

    if (rc) {
        NSArray *componds = [ipAddress componentsSeparatedByString:@","];
        BOOL v = YES;
        for (NSString *s in componds) {
            if (s.integerValue > 255) {
                v = NO;
                break;
            }
        }
        return v;
    }
    return NO;
}
#pragma mark - 只允许输入数字
-(BOOL)isJudgeNum:(NSString *) string
{
    //invertedSet方法是去反字符，把所有的除了数字字母的字符都找出来
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL canChange = [string isEqualToString:filtered];
    return canChange;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IPManagerPageCell *listCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!listCell) {
        
        listCell = [[NSBundle bundleForClass:[IPManager class]] loadNibNamed:@"IPManagerPageCell" owner:self options:nil][0];
    }
    listCell.ipModelDic  = _listArray[indexPath.row];
    return listCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.selectedIPResponseSuceesCompletionBlock) {
        // 获取当前点击数据
        IPModel *tempMod = self.listArray[indexPath.row];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSString *dateTime = [formatter stringFromDate:[NSDate date]];
        tempMod.ipUseTime = dateTime;
        
        // 初始化数据源
        NSMutableDictionary *modelDic = [[NSMutableDictionary alloc] initWithDictionary:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kTLIPManager]]];
        
        [modelDic setObject:self.listArray forKey:@"dataArr"];
        [modelDic setObject:tempMod forKey:@"dataDic"];
        
        // 更新保存数据
        [self.listArray replaceObjectAtIndex:indexPath.row withObject:tempMod];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:modelDic]
                                                  forKey:kTLIPManager];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // 返回上一层界面
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"已切换默认IP地址为：%@:%@",tempMod.ipAddress,tempMod.ipPort] message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alertView.tag = 1000;
        alertView.tag = 1000;
        [alertView show];
        // 回调通知外部改变
        self.selectedIPResponseSuceesCompletionBlock(tempMod);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
