package com.bjpowernode.settings.test;

import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.MD5Util;

public class LoginTest {
    public static void main(String[] args) {
        // 验证失效时间
        // 失效时间
        String expireTime = "2020-10-12 12:12:12";
        // 当前系统时间
        String currentTime = DateTimeUtil.getSysTime();
        System.out.println(currentTime);
        // 比较字符串的大小，返回一个整数
        int res = expireTime.compareTo(currentTime);
        System.out.println(res);
        if (res < 0){
            System.out.println("账户已失效！");
        }

        // 验证锁定状态
        // 锁定状态
        String lockDate = "0";
        if("0".equals(lockDate)){
            System.out.println("账户已锁定！");
        }

        // 验证ip地址
        // 浏览器端的ip地址
        String ip = "192.168.1.1";
        // 允许访问系统的ip地址群
        String allowIps = "192.168.1.1,192.168.1.2";
        // 判断一个字符串是否包含另一个字符串
        if(allowIps.contains(ip)){
            System.out.println("有效的ip地址，允许访问系统！");
        } else {
            System.out.println("ip地址受限，请联系管理员！");
        }

        // MD5算法：密码明文变密文，不可逆
        String pwd = "chen22186695";
        pwd = MD5Util.getMD5(pwd);
        System.out.println(pwd);
    }
}
