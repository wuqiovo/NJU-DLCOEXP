SW[5:0]   ：载入数值 value，范围 0~63
SW[7:6]   ：选择载入对象
            00：秒
            01：分
            10：时
            11：保留

SW[8]     ：载入当前时间 load_time
SW[9]     ：载入闹钟时间 load_alarm

SW[10]    ：时钟暂停 clock_pause
SW[11]    ：显示模式 mode_sel
            0：显示电子时钟
            1：显示秒表

SW[12]    ：秒表运行 sw_run
            0：暂停
            1：运行

SW[13]    ：秒表清零 sw_rst

SW[14]    ：总复位 rst

SW[15]    ：闹钟使能 alarm_en_sw
            0：关闭闹钟
            1：开启闹钟