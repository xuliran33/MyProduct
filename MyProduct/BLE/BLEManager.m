//
//  BLEManager.m
//  MyProduct
//
//  Created by dalong on 2022/10/12.
//

#import "BLEManager.h"
#import <CoreBluetooth/CoreBluetooth.h>
// 作为中心设备时的代理CBCentralManagerDelegate
// CBPeripheralDelegate 对数据进行读写的代理
@interface BLEManager ()<CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate>

// 手机蓝牙作为中心设备
@property (nonatomic, strong) CBCentralManager *cbcManager;
// 当前连接的外设
@property (nonatomic, strong) CBPeripheral *curPeripheral;
// 读数据的特征
@property (nonatomic, strong) CBCharacteristic *readCharacterstic;
// 写数据的特征
@property (nonatomic, strong) CBCharacteristic *writeCharacterstic;

// 手机蓝牙作为外设端
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;

@end


@implementation BLEManager

singleton_implementation(BLEManager)

- (instancetype)init {
    if (self = [super init]) {
        [self createPeripheralManager];
        
    }
    return self;
}

#pragma mark --------------------蓝牙作为中心设备
- (void)createCenterManager {
    // 初始化选项，设置为YES时，如果用户关闭蓝牙，会弹出一个提示框
    NSDictionary *options = @{CBCentralManagerOptionShowPowerAlertKey: @YES};
    self.cbcManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:options];
}

#pragma mark ----------CBCentralManagerDelegate
// 返回蓝牙的状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            // 蓝牙状态未知
            NSLog(@"蓝牙状态未知");
            break;
        case CBCentralManagerStateUnsupported:
            // 模拟器不支持蓝牙调试
            NSLog(@"模拟器不支持蓝牙调试");
            break;
        case CBCentralManagerStateUnauthorized:
            // 蓝牙未授权
            NSLog(@"蓝牙未授权");
            break;
        case CBCentralManagerStateResetting:
            // 蓝牙处于重置状态
            NSLog(@"蓝牙处于重置状态");
            break;
        case CBCentralManagerStatePoweredOn:
            // 蓝牙已开启
            NSLog(@"蓝牙已开启");
            // 可以根据UUID来扫描外设，如果不设置，就扫描所有蓝牙设备
            [self.cbcManager scanForPeripheralsWithServices:nil options:nil];
            // 根据UUID来扫描外设
            //            [self.cbcManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@""]] options:nil];
            break;
        default:
            break;
    }
}

// 获取所有的扫描到的外设
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSString *name = peripheral.name;
    NSLog(@"==============%@", name);
    // 扫描到设备后，根据名字进行连接
    //    [self.cbcManager connectPeripheral:peripheral options:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    if (error) {
        return;
    }
    NSLog(@"蓝牙连接失败");
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"蓝牙连接成功之后的回调");
    self.curPeripheral = peripheral;
    // 蓝牙停止扫描
    [self.cbcManager stopScan];
    
    peripheral.delegate = self;
    // 根据UUID寻找服务，默认所有的服务
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    if (error) {
        return;
    }
    NSLog(@"蓝牙连接断开");
}

#pragma mark ------------- CBPeripheralDelegate
// 连接成功的第一个方法，获取搜索到的服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        return;
    }
    for (CBService *service in peripheral.services) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:@""]]) {
            // 当找到需要的服务时，继续搜索特征
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

// 返回获取的特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if(error) {
        return;
    }
    // 0xFFF3 UUID 和蓝牙开发人员进行约定
    for (CBCharacteristic *cbCharacteristic in service.characteristics) {
        if ([cbCharacteristic.UUID isEqual:[CBUUID UUIDWithString:@"0xFFF3"]]) {
            // 记录读数据的特征
            self.readCharacterstic = cbCharacteristic;
            // 订阅读数据的特征通知
            [self.curPeripheral setNotifyValue:YES forCharacteristic:self.readCharacterstic];
        }
        
        if ([cbCharacteristic.UUID isEqual:[CBUUID UUIDWithString:@"0xFFF4"]]) {
            // 记录写数据的特征
            self.writeCharacterstic = cbCharacteristic;
            // 订阅写数据的特征通知
            [self.curPeripheral setNotifyValue:YES forCharacteristic:self.writeCharacterstic];
        }
    }
    
    if (self.writeCharacterstic && self.readCharacterstic) {
        // 获取设备的相关数据
        [self getDeviceData];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    // 当订阅状态发生变化的通知
    if (error) {
        NSLog(@"订阅失败");
    }
    if (characteristic.isNotifying) {
        NSLog(@"订阅成功");
    } else {
        NSLog(@"取消订阅");
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    // 收到蓝牙传来的数据
    NSData *data = characteristic.value;
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

// 主动读取数据
- (void)getDeviceData {
    [self.curPeripheral readValueForCharacteristic:self.readCharacterstic];
}


// 写数据
- (void)writeData {
    NSString *string = @"指令";
    // 用NSData类型来写入
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 根据之前记录的写数据特征self.writeCharacteristic来写入数据
    [self.curPeripheral writeValue:data forCharacteristic:self.writeCharacterstic type:CBCharacteristicWriteWithResponse];
}

// 写数据的回调
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        return;
    }
    NSLog(@"写入数据成功");
}


#pragma mark --------------------蓝牙作为外围设备

// 创建peripheralManager对象
- (void)createPeripheralManager {
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    
}

#pragma mark ------------CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    switch (peripheral.state) {
        case CBPeripheralManagerStateUnknown:
            // 蓝牙状态未知
            NSLog(@"蓝牙状态未知");
            break;
        case CBPeripheralManagerStateUnsupported:
            // 模拟器不支持蓝牙调试
            NSLog(@"模拟器不支持蓝牙调试");
            break;
        case CBPeripheralManagerStateUnauthorized:
            // 蓝牙未授权
            NSLog(@"蓝牙未授权");
            break;
        case CBPeripheralManagerStateResetting:
            // 蓝牙处于重置状态
            NSLog(@"蓝牙处于重置状态");
            break;
        case CBPeripheralManagerStatePoweredOn:
            // 蓝牙已开启
            [self configServiceAndCharacteristicForPeropheral];
            break;
        default:
            break;
    }
}

// 给蓝牙添加服务和特征后调用
- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
    if (error) {
        return;
    }
    // 服务和特征添加成功，开始广播
    [self.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey: service.UUID}];
//    停止广播
//    [self.peripheralManager stopAdvertising];
}

// 开始广播后回调
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error{
    
}

// 当中央端脸上此设备并订阅了特征时回调
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    // 向中央端写数据
    // 如果数据过多的话，可以转正Data，然后分段发送，如发送结束之后可以穿制定标识符，表示数据发送结束，如“EOM”
    // 也可以想socket一样，传index，totaolCount，根据此来计算
    //    [self.peripheralManager updateValue:[NSData data] forCharacteristic:characteristic onSubscribedCentrals:nil];
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral {
    // 此回调在CBPeripheralManager准备发送下一段数据时发送，这里一般用来实现保证分段数据按顺序发送给中央设备。
}

// 当收到中央端读数据的请求会调用
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    if (request.characteristic.properties & CBCharacteristicPropertyRead) {
        NSData *data = request.characteristic.value;
        [request setValue:data];
        [self.peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
    } else {
        [self.peripheralManager respondToRequest:request withResult:CBATTErrorReadNotPermitted];
    }
}

// 当收到中央端写数据的请求会调用
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests {
    for (CBATTRequest *request in requests) {
        if (request.characteristic.properties & CBCharacteristicPropertyWrite) {
            CBMutableCharacteristic *c = (CBMutableCharacteristic *)request.characteristic;
            c.value = request.value;
            [self.peripheralManager respondToRequest:request withResult:CBATTErrorSuccess];
        } else {
            [self.peripheralManager respondToRequest:request withResult:CBATTErrorWriteNotPermitted];
        }
    }
}

// 给手机蓝牙配置服务和特征
- (void)configServiceAndCharacteristicForPeropheral {
    CBMutableCharacteristic *charateristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:@""] properties:CBCharacteristicPropertyWrite | CBCharacteristicPropertyRead value:nil permissions:CBAttributePermissionsReadEncryptionRequired | CBAttributePermissionsWriteEncryptionRequired];
    
    CBMutableService *service = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:@""] primary:YES];
    [service setCharacteristics:@[charateristic]];
    [self.peripheralManager addService:service];
//    蓝牙移除所有服务
//    [self.peripheralManager removeAllServices];
    
}

// 关闭蓝牙设备
- (void)closeBlueTooth {
    //停止扫描
    [self.cbcManager stopScan];
    if (self.curPeripheral) {
        //断开当前的连接
        [self.cbcManager cancelPeripheralConnection:self.curPeripheral];
    }
    self.cbcManager = nil;
    self.curPeripheral = nil;
    self.readCharacterstic = nil;
    self.writeCharacterstic = nil;
}

@end

/**
 * 笔记
 * 蓝牙4.0和5.0的区别：5.0传输快，覆盖距离远，推出时间不一样
 * 1、传输速度区别：蓝牙5.0设备的低功耗模式传输速度上限为2Mbps，蓝牙4.0设备低功耗模式传输速度上限为1Mbps。
 * 2、覆盖范围区别：蓝牙5.0设备的最大范围可达300米，蓝牙4.0设备的最大范围仅为100米。
 * 3、推出时间区别：蓝牙5.0是由蓝牙技术联盟在2016年提出的蓝牙技术标准，蓝牙4.0是2012年提出的蓝牙技术标准
 * 一、iOS中蓝牙的实现方案
 * iOS中提供了4个蓝牙框架，用于实现蓝牙连接
 * 1.GameKit.framework 用法简单已过时
 * 只能用于iOS设备之间的链接，多用于游戏（比如五子棋对战），从iOS7开始过期
 * 2、MutipeerConnectivity.framework(用法简单-已过时)
 * 只能用于iOS设备之间的连接，从iOS7开始引入，主要用于文件共享（仅限沙盒文件）
 * 3、ExternalAccessory.framework
 * 用于第三方蓝牙设备交互，但蓝牙设备必须经过苹果MFi认证（国内较少）
 * 4、CoreBluetooth.framework（主流框架）
 * 可用于第三方蓝牙设备交互，必须支持蓝牙4.0
 * 只收是4s，系统至少是iOS6
 * 蓝牙4.0一直以低功耗著称，一般也叫BLE（Bluetooth Low Energy）
 * 目前应用比较多的案例：运动手环、嵌入式设备、智能家居
 *
 * 二、蓝牙基础知识
 * 1、基础知识
 * 每个蓝牙设备都是通过服务（Service）和特征（Characteristic）来展示自己的
 * 一个设备必然包含一个或多个服务，每个服务下面又包含若干个特征
 * 特征是与外界交互的最小单位，比如：一台蓝牙4.0设备，用A特征来描述自己的出厂信息，用B特征来手法数据
 * 服务和特征都是用CBUDID来唯一标识的，用不同的UDID就能区别不同的服务和特征
 * 设备里面各个服务（Service）和特征（Characteristic）的功能，均是由蓝牙设备和硬件厂商提供的，比如哪里是用来交互（读写），哪里可获取模块信息（只读）等
 *
 *
 * 三、蓝牙的开发步骤
 * 1.建立中心设备
 * 2.扫描外设（Discover Peripheral）
 * 3.连接外设（Connect Peripheral）
 * 4.扫描外设中的服务和特征（DiscoverService And Characteristci）
 * 5.利用特征与外设做数据交互（Explore And Interact）
 * 6.断开链接（Disconnect）
 *
 * 四、蓝牙中各种角色的理解
 * 在蓝牙开发中，我们把提供服务的一方称之为周边设备（外围设备），接收服务的一方称之为中央设备
 * 外围设备：通常用于发布服务，生成数据，保存数据。外围设备发布并广播服务，告诉周围的中央设备它的可用服务特征
 * 中心设备：中心设备扫描到外围设备后会试图建立连接，连接成功后，可以使用外围设备的服务和特征
 * 外围设备和中心设备直接交换的桥梁是服务（CBService）和特征（CBCharacteristic），二者都拥有一个唯一的标识（CBUUID）来确定唯一的服务和特征，每个服务可以有多个特征
 * CBPeripheral 外围设备
 * CBPeripheralManager 外围设备管理类
 * CBMutableService 外围设备的服务
 * CBMutableCharacteristic 外围设备的特征
 * CBUUID 外围设备服务特征的唯一标志
 * CBCentral 中心设备
 * CBCentralManager 中心设备管理类
 * CBService 外围设备的服务
 * CBCharacteristic 外围设备的特征
 * CBATTRequest 中心设备读写数据的请求
 * 五、iOS蓝牙开发
 * 1.申请权限
 * iOS10以后，所有的蓝牙开发都要申请蓝牙权限，在项目的info.plist中设置NSBluetoothPeripheralUsageDescription,对应的key为Privacy - Bluetooth Always Usage Description和Privacy - Bluetooth Peripheral Usage Description
 */
