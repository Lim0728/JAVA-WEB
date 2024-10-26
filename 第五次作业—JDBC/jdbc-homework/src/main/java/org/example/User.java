package org.example;

import java.util.Scanner;

public class User {
    public static void main(String[] args) {
        Scanner input=new Scanner(System.in);
        // 提示用户输入操作选项
        System.out.println("请属于一个数字：\n"+"1代表插入操作\n"+"2代表更新操作\n"+"3代表查询操作\n"+"4代表删除操作\n"+"5代表批量插入\n"+"6代表可滚动结果集\n"+"如果不想测试，输入-1代表退出");
        int times=input.nextInt();
        // 创建 CRUD、批量插入和可滚动结果集对象
        CRUD crud=new CRUD();
        Batchinsert bat=new Batchinsert();
        ScrollableResultSet scroll=new ScrollableResultSet();
        // 当用户输入的编号不为 -1 时，循环执行操作
        while(times!=-1){
            switch (times){
                case 1:
                    crud.insert();
                    break;
                case 2:
                    crud.update();
                    break;
                case 3:
                    crud.find();
                    break;
                case 4:
                    crud.delete();
                    break;
                case 5:
                    bat.batch();
                    break;
                case 6:
                    scroll.moveToNext();
                    break;
                default:
                    break;
            }
            System.out.println("请继续输入一个数字，如果不想测试，输入-1代表退出");
            times=input.nextInt();
        }
    }
}
