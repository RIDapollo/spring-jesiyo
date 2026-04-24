package com.test.jesiyo.directsale.util;

import java.sql.Date;

public class TimeUtil {
	public static String timeAgo(Date createdAt) {

        long diff = System.currentTimeMillis() - createdAt.getTime();

        long sec = diff / 1000;
        long min = sec / 60;
        long hour = min / 60;
        long day = hour / 24;

        if (sec < 60) return "방금 전";
        if (min < 60) return min + "분 전";
        if (hour < 24) return hour + "시간 전";
        return day + "일 전";
    }
}
