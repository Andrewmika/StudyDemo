//
//  RuntimeViewController.m
//  StudyDemo
//
//  Created by Andrew Shen on 26/02/2018.
//  Copyright © 2018 小小厨师的厨房. All rights reserved.
//

#import "RuntimeViewController.h"
#import <objc/runtime.h>

/*
struct objc_class {
    Class _Nonnull isa  OBJC_ISA_AVAILABILITY;
    
#if !__OBJC2__
    Class _Nullable super_class;
    const char * _Nonnull name;
    long version;
    long info;
    long instance_size;
    struct objc_ivar_list * _Nullable ivars;
    struct objc_method_list * _Nullable * _Nullable methodLists;
    struct objc_cache * _Nonnull cache;
    struct objc_protocol_list * _Nullable protocols;
#endif
    
}
*/

//下面对应的编码值可以在官方文档里面找到
//编码值     含意
//c     代表char类型
//i     代表int类型
//s     代表short类型
//l     代表long类型，在64位处理器上也是按照32位处理
//q     代表long long类型
//C     代表unsigned char类型
//I     代表unsigned int类型
//S     代表unsigned short类型
//L     代表unsigned long类型
//Q     代表unsigned long long类型
//f     代表float类型
//d     代表double类型
//B     代表C++中的bool或者C99中的_Bool
//v     代表void类型
//*     代表char *类型
//@     代表对象类型
//#     代表类对象 (Class)
//:     代表方法selector (SEL)
//[array type]     代表array
//{name=type…}     代表结构体
//(name=type…)     代表union
//bnum     A bit field of num bits
//^type     A pointer to type
//?     An unknown type (among other things, this code is used for function pointers)

@interface RuntimeViewController ()<UIScrollViewDelegate>
{
    NSString *privateProperty3;
    NSString *_privateProperty4;
}
@property (nonatomic, copy)  NSString  *privateProperty5; // <##>
@property (nonatomic, copy)  NSArray<NSString *>  *dataSource; // <##>

@end

@implementation RuntimeViewController

//get方法
NSString *newPropertyGetter(id classInstance, SEL _cmd) {
    Ivar ivar = class_getInstanceVariable([classInstance class], "newProperty");//获取变量,如果没获取到说明不存在
    return object_getIvar(classInstance, ivar);
}

//set方法
void newPropertySetter(id classInstance, SEL _cmd, NSString *newName) {
    Ivar ivar = class_getInstanceVariable([classInstance class], "newProperty");//获取变量,如果没获取到说明不存在
    id oldName = object_getIvar(classInstance, ivar);
    if (oldName != newName) object_setIvar(classInstance, ivar, [newName copy]);
}

void replaceMethod() {
    NSLog(@"--->replaced~!");
}

+ (void)p_classMethod {
    NSLog(@"--->Classmethod");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Runtime";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"RuntimeCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Interface Method

- (void)interfaceMethod {
    NSLog(@"--->InterfaceMethod");
}

#pragma mark - Private Method
// 获取类信息
- (void)p_classGet {
    // 获取类名
//    OBJC_EXPORT const char * _Nonnull
//    class_getName(Class _Nullable cls)
//    OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);
    const char *clsName = class_getName(self.class);
    NSLog(@"--->1、获取类名：%@",[NSString stringWithUTF8String:clsName]);
    NSLog(@"\n-------------\n");

    // 获取父类
//    OBJC_EXPORT Class _Nullable
//    class_getSuperclass(Class _Nullable cls)
//    OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);
    Class superCls = class_getSuperclass(self.class);
    NSLog(@"--->2、获取父类：%@",superCls);
    NSLog(@"\n-------------\n");

    // 获取实例大小
//    OBJC_EXPORT size_t
//    class_getInstanceSize(Class _Nullable cls)
//    OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);
    size_t instSize = class_getInstanceSize(self.class);
    NSLog(@"--->3、获取实例大小：%zu", instSize);
    NSLog(@"\n-------------\n");

    // 获取类指定成员变量信息
//    OBJC_EXPORT Ivar _Nullable
//    class_getInstanceVariable(Class _Nullable cls, const char * _Nonnull name)
//    OBJC_AVAILABLE(10.0, 2.0, 9.0, 1.0, 2.0);
    const char *pName = @"tableView".UTF8String;
    Ivar var = class_getInstanceVariable(self.class, pName);
    NSLog(@"--->4、获取类指定成员变量信息：%@",var);
    NSLog(@"\n-------------\n");

    // 获取指定属性
//    OBJC_EXPORT objc_property_t _Nullable
//    class_getProperty(Class _Nullable cls, const char * _Nonnull name)
//    OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);
    objc_property_t existP = class_getProperty(self.class, pName);
    NSLog(@"--->5、获取类指定成员变量信息：exist:%@",[NSString stringWithUTF8String:property_getName(existP)]);
    NSLog(@"\n-------------\n");

    // 获取方法实现
//    OBJC_EXPORT IMP _Nullable
//    class_getMethodImplementation(Class _Nullable cls, SEL _Nonnull name)
//    OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);

//    OBJC_EXPORT IMP _Nullable
//    class_getMethodImplementation_stret(Class _Nullable cls, SEL _Nonnull name)
//    OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0)
//    OBJC_ARM64_UNAVAILABLE;
    SEL sel = @selector(interfaceMethod);
    IMP imp1 = class_getMethodImplementation(self.class, sel);
    IMP imp2 = class_getMethodImplementation_stret(self.class, sel);
    imp1();
    imp2();
    NSLog(@"\n-------------\n");

    // 获取类方法
//    OBJC_EXPORT Method _Nullable
//    class_getClassMethod(Class _Nullable cls, SEL _Nonnull name)
//    OBJC_AVAILABLE(10.0, 2.0, 9.0, 1.0, 2.0);
    Method mtd = class_getClassMethod(self.class, @selector(p_classMethod));
    SEL mtdS = method_getName(mtd);
    NSLog(@"--->6、获取类方法：%@", NSStringFromSelector(mtdS));
    NSLog(@"\n-------------\n");

}

- (void)p_classCopy {
    // 获取变量列表,私有变量+属性
//    OBJC_EXPORT Ivar _Nonnull * _Nullable
//    class_copyIvarList(Class _Nullable cls, unsigned int * _Nullable outCount)
//    OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);
    unsigned int varCount = 0;
    Ivar *varList = class_copyIvarList(self.class, &varCount);
    for (NSInteger i = 0; i < varCount; i ++) {
        Ivar ivar = varList[i];
        NSLog(@"--->1.copyVarList>:%s",ivar_getName(ivar));
    }
    free(varList);
    NSLog(@"\n-------------\n");
    // 获取属性列表
//    OBJC_EXPORT objc_property_t _Nonnull * _Nullable
//    class_copyPropertyList(Class _Nullable cls, unsigned int * _Nullable outCount)
//    OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList(self.class, &propertyCount);
    for (NSInteger i = 0; i < propertyCount; i ++) {
        objc_property_t property = propertyList[i];
        NSLog(@"--->2.copyPropertyList>:%s",property_getName(property));
    }
    free(propertyList);
    NSLog(@"\n-------------\n");

    // 获取方法列表,不获取父类方法,不包含类方法
//    OBJC_EXPORT Method _Nonnull * _Nullable
//    class_copyMethodList(Class _Nullable cls, unsigned int * _Nullable outCount)
//    OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(self.class, &methodCount);
    for (NSInteger i = 0; i < methodCount; i ++) {
        Method method = methodList[i];
        NSLog(@"--->3.copyMethodList>:%@",NSStringFromSelector(method_getName(method)));
    }
    free(methodList);
    NSLog(@"\n-------------\n");
    
    // 获取协议列表
//    OBJC_EXPORT Protocol * __unsafe_unretained _Nonnull * _Nullable
//    objc_copyProtocolList(unsigned int * _Nullable outCount)
//    OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);
    unsigned int protocolCount = 0;
    Protocol * __unsafe_unretained *protocolList = class_copyProtocolList(self.class, &protocolCount);
    for (NSInteger i = 0; i < protocolCount; i ++) {
        Protocol *protocol = protocolList[i];
        NSLog(@"--->4.copyProtocolList>:%s",protocol_getName(protocol));
    }
    free(protocolList);
    NSLog(@"\n-------------\n");
}

- (void)p_classAdd {
    // 添加变量,不支持向已有类添加变量
//    OBJC_EXPORT BOOL
//    class_addIvar(Class _Nullable cls, const char * _Nonnull name, size_t size,
//                  uint8_t alignment, const char * _Nullable types)
//    OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);
    BOOL addExistClsIvarState = class_addIvar(self.class, "_addVar", sizeof(NSString *), log(sizeof(NSString *)), "i");
    NSLog(@"--->1.addExistClsIvarState:%d",addExistClsIvarState);
    
    Class addCls = objc_allocateClassPair([NSObject class], "ANewClass", 0);
    BOOL addNewClsIvarState = class_addIvar(addCls, "_addVar", sizeof(NSString *), log(sizeof(NSString *)), "i");
    NSLog(@"--->1.addNewClsIvarState:%d",addNewClsIvarState);
    objc_registerClassPair(addCls);
    NSLog(@"--->1.addClsName:%s",class_getName(addCls));
    

    
    // 添加属性,添加的属性和变量不能用KVC设置和取值
    objc_property_attribute_t type2 = { "T", "@\"NSString\"" };
    objc_property_attribute_t ownership2 = { "C", "" }; // C = copy
    objc_property_attribute_t backingivar2  = { "V", "newProperty" };
    objc_property_attribute_t attrs2[] = { type2, ownership2, backingivar2 };
    BOOL addExistClsPropertyState = class_addProperty(self.class, "newProperty", attrs2, 3);
    NSLog(@"--->2.addExistClsPropertyState:%d",addExistClsPropertyState);
    objc_property_t p = class_getProperty(self.class, "newProperty");
    NSLog(@"--->2.addProperty:%s",property_getName(p));
    // 添加方法
    SEL getter = NSSelectorFromString(@"newProperty");
    SEL setter = NSSelectorFromString(@"setNewProperty:");
    BOOL addGetterState = class_addMethod(self.class, getter, (IMP)newPropertyGetter, "@@:");
    BOOL addSetterState = class_addMethod(self.class, setter, (IMP)newPropertySetter, "v@:@");
    NSLog(@"--->3.AddMethod:getterState>:%d,setterState>:%d",addGetterState,addSetterState);
    id newSelf = [[RuntimeViewController alloc] init];
    NSLog(@"--->3.propertyInitValue:%@",[newSelf performSelector:getter withObject:nil]);
    [newSelf performSelector:setter withObject:@"设置了一个值"];
    NSLog(@"--->3.propertySettedValue:%@",[newSelf performSelector:getter withObject:nil]);

    // 添加协议
    BOOL addProtocolState = class_addProtocol(self.class, NSProtocolFromString(@"UINavigationBarDelegate"));
    NSLog(@"--->4.addProtocolState:%d",addProtocolState);
    unsigned int protocolCount = 0;
    Protocol * __unsafe_unretained *protocolList = class_copyProtocolList(self.class, &protocolCount);
    for (NSInteger i = 0; i < protocolCount; i ++) {
        Protocol *protocol = protocolList[i];
        NSLog(@"--->4.copyProtocolList>:%s",protocol_getName(protocol));
    }
    free(protocolList);
}

- (void)p_classReplace {

    // 方法替换
    [self interfaceMethod];
    BOOL replaceState = class_replaceMethod(self.class, @selector(interfaceMethod), (IMP)replaceMethod, NULL);
    NSLog(@"--->1.replaceState:%d",replaceState);
    [self interfaceMethod];
}
#pragma mark - Event Response

#pragma mark - Delegate
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RuntimeCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            NSLog(@"++++++++获取类信息--ClassGet++++++++\n");
            [self p_classGet];
            break;
        }
        case 1: {
            NSLog(@"++++++++获取类信息--ClassCopy++++++++\n");
            [self p_classCopy];
            break;
        }
        case 2: {
            NSLog(@"++++++++修改类信息--ClassAdd++++++++\n");
            [self p_classAdd];
            break;
        }
        case 3: {
            NSLog(@"++++++++修改类信息--ClassReplace++++++++\n");
            [self p_classReplace];
            break;
        }
        default:
            break;
    }
}
#pragma mark - Override

#pragma mark - InitView

#pragma mark - Init

- (NSArray<NSString *> *)dataSource {
    if (!_dataSource) {
        _dataSource = @[@"获取类信息ClassGet",@"获取类信息ClassCopy",@"修改类信息ClassAdd",@"修改类信息ClassReplace"];
    }
    return _dataSource;
}
@end
