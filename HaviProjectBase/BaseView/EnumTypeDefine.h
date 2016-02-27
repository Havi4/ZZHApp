//
//  EnumTypeDefine.h
//  HaviProjectBase
//
//  Created by Havi on 16/2/25.
//  Copyright © 2016年 Havi. All rights reserved.
//

typedef enum {
    DeleteCell = 0,
    RenameCell,
    ReactiveCell,
}CellSelectType;

typedef enum {
    MessageAccept = 0,
    MessageRefuse,
} MessageType;

typedef enum {
    SleepSettingStartTime = 0,
    SleepSettingEndTime,
    SleepSettingAlertTime,
    SleepSettingLongTime,
    SleepSettingLeaveBedTime,
    SleepSettingSwitchAlertTime,
    SleepSettingSwitchLongTime,
    SleepSettingSwitchLeaveBedTime,
} SleepSettingButtonType;

typedef enum {
    SensorDataHeart = 0,
    SensorDataBreath,
    SensorDataTurn,
    SensorDataLeave,
} SensorDataType;

typedef enum {
    ReportViewWeek = 0,
    ReportViewMonth,
    ReportViewQuater,
} ReportViewType;
