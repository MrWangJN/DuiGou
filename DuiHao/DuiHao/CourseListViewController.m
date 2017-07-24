//
//  CourseListViewController.m
//  DuiHao
//
//  Created by wjn on 2017/5/5.
//  Copyright © 2017年 WJN. All rights reserved.
//

#import "CourseListViewController.h"
#import "TwoTitleButton.h"
#import "DateUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "WeekCourse.h"
#import "CourseButton.h"
#import "WeekChoseView.h"
#import "CourseManagerViewController.h"
#import "TitleMenuButton.h"
#import "CourseManagerViewController.h"

#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
//获取设备的物理宽度
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
//系统的版本号
#define SystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

#define RGBColor(r,g,b,a) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])
#define WEEKDAY_BGCOLOR  ([UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5])
#define WEEKDAY_SELECT_COLOR ([UIColor colorWithRed:32/255.0 green:81/255.0 blue:148/255.0 alpha:0.23])
#define WEEKDAY_FONT_COLOR ([UIColor colorWithRed:32/255.0 green:81/255.0 blue:148/255.0 alpha:1])
#define kWidthGrid  (ScreenWidth/7.5)

//系统的版本号
#define SystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

#define RGBColor(r,g,b,a) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])

// 课程表中
#define WEEKDAY_BGCOLOR  ([UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5])
#define WEEKDAY_SELECT_COLOR ([UIColor colorWithRed:32/255.0 green:81/255.0 blue:148/255.0 alpha:0.23])
#define WEEKDAY_FONT_COLOR ([UIColor colorWithRed:32/255.0 green:81/255.0 blue:148/255.0 alpha:1])
#define kWidthGrid  (ScreenWidth/7.5)   //周课表中一个格子的宽度

//NSUserDefaults 中的Key常量
#define CURRENTYEAR   @"CURRENTYEAR"
#define CURRENTTERM   @"CURRENTTERM"
#define USERNAME      @"USERNAME"
#define CURRENTWEEK   @"CURRENTWEEK"

@interface CourseListViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, WeekChoseViewDelegate> {
    UIView       *weekView; //周课表的视图
    UIScrollView *weekScrollView;  //周课表的滚动视图
    NSArray *horTitles;  //横向的标题，（月份、日期）
    NSDateComponents *todayComp;  //今天的扩展
    NSArray *dataArray;   //日课表中每个cell的数据
    UIScrollView *scrollView; //日课表的滚动视图（里面装了7个tableView）
    int clickTag;  //点击的周tag值
    UIScrollView *weekChoseScrollView; //横向滚动的周选择视图
    int currentWeekTag;
    BOOL         weekChoseViewShow;  //周选择视图的显示与否
}

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *courses;
@property (nonatomic, strong) TitleMenuButton *weekBtu;

@end

@implementation CourseListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //加载网络数据
    [self loadNetDataWithWeek:[NSString stringWithFormat:@"%d",clickTag-250+1]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 初始化导航栏
    [self initNav];
    
    //加载一些基本数据
    [self loadBaseData];
    
    //初始化周的视图
    [self _initWeekView];
    //加载网络数据
    [self loadNetDataWithWeek:[NSString stringWithFormat:@"%d",clickTag-250+1]];
    [self _initWeekChoseView];
}

#pragma mark - 初始化导航栏按钮

- (void)initNav {
    UIBarButtonItem *courseEdit = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"CourseEdit"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(courseEditAction:)];
    [self.navigationItem setRightBarButtonItem:courseEdit];
    
    self.navigationItem.titleView = self.weekBtu;
}

- (void)courseEditAction:(id)sender {
    CourseManagerViewController *courseVC = [[CourseManagerViewController alloc] initWithDataSource:[NSMutableArray arrayWithArray:self.courses]];
    [self.navigationController pushViewController:courseVC animated:YES];
}

- (TitleMenuButton *)weekBtu {
    if (!_weekBtu) {
        self.weekBtu = [[TitleMenuButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 60, 30)];
        _weekBtu.title.text = @"课程表";
        [_weekBtu addTarget:self action:@selector(titleButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weekBtu;
}

#pragma mark - 右点击事件(周)

- (void)titleButtonDidPress:(UIButton *)sender {
//    [self rotateArrow:0];
    [self weekChooseAction:sender];
}

- (void)rotateArrow:(float)degrees
{
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.weekBtu.arrow.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
    } completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)courses {
    if (!_courses) {
        self.courses = [NSArray array];
    }
    return _courses;
}

//加载一些不需要从服务器请求的数据
- (void)loadBaseData
{
    _colors = [[NSArray alloc] initWithObjects:@"9,155,43",@"251,136,71",@"163,77,140",@"32,81,148",@"255,170,0",@"4,155,151",@"38,101,252",@"234,51,36",@"107,177,39",@"245,51,119", nil];
    
    //如果数据当前周为空，则默认为第一周
    NSUserDefaults  *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString  *currentWeek = [userDefaults objectForKey:@"currentWeek"];
    
    if (![userDefaults integerForKey:@"weekNum"]) {
        [userDefaults setObject:@"1" forKey:@"currentWeek"];
        [userDefaults setInteger:[DateUtils getWeekNum] forKey:@"weekNum"];
        [userDefaults synchronize];
    } else {
        if ([DateUtils getWeekNum] > [userDefaults integerForKey:@"weekNum"]) {
            [userDefaults setObject:[NSString stringWithFormat:@"%ld", [DateUtils getWeekNum] - [userDefaults integerForKey:@"weekNum"] + currentWeek.integerValue] forKey:@"currentWeek"];
            [userDefaults setInteger:[DateUtils getWeekNum] forKey:@"weekNum"];
            [userDefaults synchronize];
            
        }
    }
    currentWeek = [userDefaults objectForKey:@"currentWeek"];
    
    //先加载本周的月份以及日期
    horTitles = [DateUtils getDatesOfCurrence];
    
    //赋值计算今天的日期
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    todayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:today];
    
    clickTag = currentWeek.intValue + 250 - 1;
    currentWeekTag = clickTag;
     self.weekBtu.title.text = [NSString stringWithFormat:@"第%d周", clickTag-250+1];
}

//初始化隐藏的周选择视图
- (void)_initWeekChoseView
{
    weekChoseScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,-60, ScreenWidth, 60)];
    weekChoseScrollView.backgroundColor = WEEKDAY_BGCOLOR;
    weekChoseScrollView.contentSize = CGSizeMake(50*25, 60);
    weekChoseScrollView.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i< 25; i++) {
        WeekChoseView *weekChoseView = [[WeekChoseView alloc] initWithFrame:CGRectMake(50*i, 0, 50, 60)];
        weekChoseView.number = [NSString stringWithFormat:@"%d",i+1];
        weekChoseView.delegate = self;
        weekChoseView.tag = 250+i;
        if (clickTag == (250 +i)) {
            weekChoseView.isCurrentWeek = YES;
            weekChoseView.isChosen = YES;
            [weekChoseView reset];
            if (i > 4) {
                weekChoseScrollView.contentOffset = CGPointMake(50*(i - 3), 0);
                
            }
        }
        [weekChoseScrollView addSubview:weekChoseView];
    }
    
    [self.view addSubview:weekChoseScrollView];
}

//初始化周视图
- (void)_initWeekView
{
    weekView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    //初始化周视图的头
    UIView *weekHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    UIButton *monthButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kWidthGrid*0.5, 30)];
    [monthButton setTitle:[NSString stringWithFormat:@"%@", horTitles[0]] forState:UIControlStateNormal];
    [monthButton setTitleColor:WEEKDAY_FONT_COLOR forState:UIControlStateNormal];
    monthButton.titleLabel.font = [UIFont systemFontOfSize:10];
    monthButton.layer.borderColor = WEEKDAY_SELECT_COLOR.CGColor;
    monthButton.layer.borderWidth = 0.3f;
    monthButton.layer.masksToBounds = YES;
    [weekHeaderView addSubview:monthButton];
    
    NSArray *weekDays = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    for (int i = 0; i< 7; i++) {
        TwoTitleButton *button = [[TwoTitleButton alloc] initWithFrame:CGRectMake((i+0.5)*kWidthGrid, 0, kWidthGrid, 30)];
        NSString *title = [NSString stringWithFormat:@"周%@",weekDays[i]];
        button.tag = 9000+i;
        button.title = horTitles[i+1];
        button.subtitle = title;
        button.textColor = WEEKDAY_FONT_COLOR;
        
        NSString *month = [NSString stringWithFormat:@"%ld月",(long)[todayComp month]];
        NSString *day = [NSString stringWithFormat:@"%ld",(long)[todayComp day]];
        if ([month isEqualToString:horTitles[0]] && [day isEqualToString:horTitles[i+1]]) {
            button.backgroundColor = WEEKDAY_SELECT_COLOR;
        }
        
        [weekHeaderView addSubview:button];
    }
    [weekView addSubview:weekHeaderView];
    
    //主体部分
    weekScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, weekView.frame.size.height -30)];
    weekScrollView.bounces = NO;
    weekScrollView.contentSize = CGSizeMake(ScreenWidth, 50*12);
    for (int i = 0; i<12; i++) {
        for (int j = 0; j< 8; j++) {
            if (j == 0) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(j*kWidthGrid, i*50,kWidthGrid*0.5, 50)];
                label.backgroundColor = [UIColor clearColor];
                label.layer.borderColor = WEEKDAY_SELECT_COLOR.CGColor;
                label.layer.borderWidth = 0.3f;
                label.layer.masksToBounds = YES;
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = WEEKDAY_FONT_COLOR;
                label.text =[NSString stringWithFormat:@"%d",i+1];
                [weekScrollView addSubview:label];
            } else {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((j-0.5)*kWidthGrid-1, i*50, kWidthGrid, 50+1)];
                imageView.image = [UIImage imageNamed:@"course_excel.png"];
                [weekScrollView addSubview:imageView];
            }
            
        }
    }
    [weekView addSubview:weekScrollView];
    
    [self.view addSubview:weekView];
}

//请求网络数据
- (void)loadNetDataWithWeek:(NSString *)week {
    [self performSelector:@selector(loadLoacalData:) withObject:week afterDelay:0];
}

//加载本地的模拟数据
- (void)loadLoacalData:(NSString *)week
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    NSString *coursePath = [NSString stringWithFormat:@"%@/%@", docDir, @"course.json"];

    NSArray *array = [NSArray arrayWithContentsOfFile:coursePath];
    if (array && array.count) {
        [self handleWeek:array week:week];
    }
}

- (void)handleWeek:(NSArray *)array week:(NSString *)week
{
    NSMutableArray *allCourses =[NSMutableArray array];
    NSMutableArray *ownCourses =[NSMutableArray array];
    if (array != nil && array.count > 0) {
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dayDict = array[i];
            NSArray *dayCourses = [dayDict objectForKey:@"data"];
            NSString *weekDay = [dayDict objectForKey:@"weekDay"];
            NSString *weekNum;
            weekNum = weekDay;
            for (int j = 0; j<dayCourses.count; j++) {
                NSMutableDictionary *course = [NSMutableDictionary dictionaryWithDictionary:dayCourses[j]];
                [course setObject:weekNum forKey:@"weekDay"];
                WeekCourse *weekCourse = [[WeekCourse alloc] initWithPropertiesDictionary:course];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *year = [userDefaults objectForKey:CURRENTYEAR];
                NSString *term = [userDefaults objectForKey:CURRENTTERM];
                NSString *stuId = [userDefaults objectForKey:USERNAME];
                NSString *yearRange = [NSString stringWithFormat:@"%@%@",year,term];
                weekCourse.studentId = stuId;
                weekCourse.term = yearRange;
                weekCourse.weeks = week;
                
                [ownCourses addObject:weekCourse];
                
                if ([weekCourse.setWeeks containsObject:weekCourse.weeks]) {
                    [allCourses addObject:weekCourse];
                }
            }
        }
    }
    //对数据解析
    [self handleData:allCourses];
    self.courses = ownCourses;
}

//数据解析后，展示在UI上
- (void)handleData:(NSArray *)courses
{
    
    if (dataArray || dataArray.count > 0) {
        dataArray = nil;
    }
    
    for (UIView *view in weekScrollView.subviews) {
        if ([view isKindOfClass:[CourseButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (courses.count > 0) {
        //处理周课表
        for (int i = 0; i<courses.count; i++) {
            WeekCourse *course = courses[i];
            
            int rowNum = course.lesson.intValue - 1;
            int colNum = course.day.intValue;
            int lessonsNum = course.lessonsNum.intValue;
            
            CourseButton *courseButton = [[CourseButton alloc] initWithFrame:CGRectMake((colNum-0.5)*kWidthGrid, 50*rowNum+1, kWidthGrid-2, 50*lessonsNum-2)];
            courseButton.weekCourse = course;
            int index = i%10;
            courseButton.backgroundColor = [self handleRandomColorStr:_colors[index]];
            [courseButton addTarget:self action:@selector(courseClick:) forControlEvents:UIControlEventTouchUpInside];
            [weekScrollView addSubview:courseButton];
        }
    }
}

//处理随机颜色字符串
- (UIColor *)handleRandomColorStr:(NSString *)randomColorStr
{
    NSArray *array = [randomColorStr componentsSeparatedByString:@","];
    if (array.count >2) {
        NSString *red = array[0];
        NSString *green = array[1];
        NSString *blue = array[2];
        return RGBColor(red.floatValue, green.floatValue, blue.floatValue, 0.5);
    }
    return [UIColor lightGrayColor];
}
/**
 *  获取星期几的课程
 *
 *  @param weekDay 星期几，如：星期一是monday
 *  @param courses 服务器返回的课程数组
 *
 *  @return 返回课程 （按照上课顺序 从第一节......到第第十二节）
 */
- (NSMutableArray *)getDayCoursesByWeekDay:(NSString *)weekDay srcArray:(NSArray *)courses
{
    //返回时使用的数组
    NSMutableArray *newCourses = [NSMutableArray array];
    int rowNum = 1;//默认从第一节开始计算
    if (courses == nil) { //如果没有数据时
        for (int j = rowNum; j< 13; j++) {
            WeekCourse *weekCourse = [[WeekCourse alloc] init];
            weekCourse.capter = [NSString stringWithFormat:@"%d",j];
            [newCourses addObject:weekCourse];
        }
        return newCourses;
    }
    //星期几的课程  --- 用到了谓词
    NSString *string = [NSString stringWithFormat:@"day == '%@'",weekDay];
    NSPredicate *pre = [NSPredicate predicateWithFormat:string];
    //应该只有一条记录
    NSArray *coursesOfDay = [courses filteredArrayUsingPredicate:pre]; //筛选出某天的课程信息
    //终于拿到课程了
    for (int i = 0; i < coursesOfDay.count; i++) {
        //每一条记录为一个cell的数据，这里给Model添加capter属性,设置哪几节上课
        WeekCourse *course = [coursesOfDay objectAtIndex:i];
        NSString *lesson = course.lesson;
        NSString *lessonsNum = course.lessonsNum;
        int endCapter = lesson.intValue+lessonsNum.intValue -1;
        //判断是否之前有空着的，如果有插入空节数
        if (rowNum != lesson.intValue) {
            for (int j = rowNum; j<lesson.intValue; j++) {
                WeekCourse *weekCourse = [[WeekCourse alloc] init];
                weekCourse.capter = [NSString stringWithFormat:@"%d",j];
                [newCourses addObject:weekCourse];//把一些只包含节数信息的对象 插入数组
            }
        }
        //组装新的课程信息，其实只修改了从第几节到第几节，还有是否有课的属性
        course.haveLesson = YES;
        //判断是否为只上一节的情况
        if (endCapter == lesson.intValue) {
            course.capter = lesson;
        }else {
            NSString *capter = [NSString stringWithFormat:@"%@-%d",lesson,endCapter];
            course.capter = capter;
        }
        //把重新组装的dict 加入数组
        [newCourses addObject:course];
        rowNum = endCapter +1;
    }
    
    //如果还没计算到第12节，后面的也要插入只包含节数的dict
    if (rowNum < 12) {
        for (int j = rowNum; j< 13; j++) {
            WeekCourse *weekCourse = [[WeekCourse alloc] init];
            weekCourse.capter = [NSString stringWithFormat:@"%d",j];
            [newCourses addObject:weekCourse];
        }
    }
    return newCourses;
}

#pragma mark - 课程点击事件

- (void)courseClick:(UIButton *)sender
{
    //    CourseButton *courseButton = (CourseButton *)sender;
    //    WeekCourse *weekCourse = courseButton.weekCourse;
    //    DetailViewController *detailCtr = [[DetailViewController alloc]init];
    //    detailCtr.weekCourse = weekCourse;
    //    [self.navigationController pushViewController:detailCtr animated:YES];
    
}

#pragma mark - WeekChoseViewDelegate
- (void)tapAction:(int)tag
{
    if (clickTag == 0) {
        clickTag = tag;
    }else {
        WeekChoseView *view = (WeekChoseView *)[weekChoseScrollView viewWithTag:clickTag];
        view.isChosen = NO;
        [view reset];
        clickTag = tag;
    }
    NSString *week = [[NSString alloc] initWithFormat:@"%d",tag-250+1];
    UIButton *weekButton = (UIButton *)[self.navigationItem.titleView viewWithTag:110];
    [weekButton setTitle:[NSString stringWithFormat:@"第%@周",week] forState:UIControlStateNormal];
    [weekButton setImageEdgeInsets:week.length>1?UIEdgeInsetsMake(0, 60, 0, -60):UIEdgeInsetsMake(0, 40, 0, -60)];
    [self bounceTargetView:weekButton];
    
    //重新加载
    [self loadNetDataWithWeek:week];
}

- (void)bounceTargetView:(UIView *)targetView
{
    [UIView animateWithDuration:0.1 animations:^{
        targetView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            targetView.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                targetView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}

- (void)setCurrentWeek:(NSString *)number
{
    NSString *title = [NSString stringWithFormat:@"将第%@周设置为本周？",number];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
#pragma mark - 左点击事件（添加课程）
- (IBAction)dasa:(id)sender {
    CourseManagerViewController *courseVC = [[CourseManagerViewController alloc] initWithDataSource:self.courses];
    [self.navigationController pushViewController:courseVC animated:YES];
}

- (void)weekChooseAction:(id)sender
{
    //本来显示，点击之后要隐藏
    if (weekChoseViewShow) {
        [self rotateArrow:0];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationDuration:0.5f];
        weekChoseScrollView.frame = CGRectMake(0, -60, ScreenWidth, 60);
        [self changeSubViewsFrameByWeek:weekChoseViewShow];
        [UIView commitAnimations];
        weekChoseViewShow = NO;
        if(clickTag!=currentWeekTag){
            WeekChoseView *view = (WeekChoseView *)[weekChoseScrollView viewWithTag:clickTag];
            view.isChosen = NO;
            [view reset];
            clickTag = currentWeekTag;
            NSString *week = [[NSString alloc] initWithFormat:@"%d",clickTag-250+1];
            UIButton *weekButton = (UIButton *)[self.navigationItem.titleView viewWithTag:110];
            [weekButton setTitle:[NSString stringWithFormat:@"第%@周",week] forState:UIControlStateNormal];
            [weekButton setImageEdgeInsets:week.length>1?UIEdgeInsetsMake(0, 60, 0, -60):UIEdgeInsetsMake(0, 40, 0, -60)];
            [self bounceTargetView:weekButton];
            //            backLabel.hidden = YES;
            //数据也重新加载
            [self loadNetDataWithWeek:week];
        }
    }else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationRepeatCount:1];
        [UIView setAnimationDuration:0.5f];
        weekChoseScrollView.frame = CGRectMake(0, 0, ScreenWidth, 60);
        [self changeSubViewsFrameByWeek:weekChoseViewShow];
        [UIView commitAnimations];
        weekChoseViewShow = YES;
        
        if(clickTag == currentWeekTag){
            WeekChoseView *view = (WeekChoseView *)[weekChoseScrollView viewWithTag:currentWeekTag];
            view.isChosen = YES;
            [view reset];
        }
        [self rotateArrow:M_PI];
    }
}

//修改子类的frame
- (void)changeSubViewsFrameByWeek:(BOOL)_weekViewShow
{
    if (_weekViewShow) {
        
        //设置周课表视图以及其子视图的frame
        weekView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
        weekScrollView.frame = CGRectMake(0, 30, ScreenWidth, weekView.frame.size.height -30);
        weekScrollView.contentSize = CGSizeMake(ScreenWidth, 50*12);
    } else {
        //        //设置周课表视图以及其子视图的frame
        weekView.frame = CGRectMake(0, weekChoseScrollView.frame.size.height, ScreenWidth, ScreenHeight - 64 - weekChoseScrollView.frame.size.height);
        
        weekScrollView.frame = CGRectMake(0, 30, ScreenWidth, weekView.frame.size.height -30);
        weekScrollView.contentSize = CGSizeMake(ScreenWidth, 50*12);
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //点击取消
    }else {
        //点击确定按钮
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        //先取消原来本周控件的背景色
        NSString *currentWeek = [userDefaults objectForKey:@"currentWeek"];
        WeekChoseView *weekChoseView = (WeekChoseView *)[weekChoseScrollView viewWithTag:(currentWeek.intValue +250-1)];
        weekChoseView.isCurrentWeek = NO;
        [weekChoseView reset];
        
        WeekChoseView *newView = (WeekChoseView *)[weekChoseScrollView viewWithTag:clickTag];
        newView.isCurrentWeek = YES;
        currentWeekTag = clickTag;
        [newView reset];
        [userDefaults setObject:[NSString stringWithFormat:@"%d",clickTag-250+1] forKey:@"currentWeek"];
        [userDefaults setInteger:[DateUtils getWeekNum] forKey:@"weekNum"];
        [userDefaults synchronize];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        weekChoseScrollView.frame = CGRectMake(0, -60, ScreenWidth, 60);
        [self changeSubViewsFrameByWeek:weekChoseViewShow];
        weekChoseViewShow = NO;
        [UIView commitAnimations];
        [self rotateArrow:0];
        self.weekBtu.title.text = [NSString stringWithFormat:@"第%d周", clickTag-250+1];
    }
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
