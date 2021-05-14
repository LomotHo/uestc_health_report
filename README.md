# 电子科技大学研究生健康状况自动填报

## 免责说明

注意！！！！！仅做学习使用，禁止用来瞒报打卡，违者后果自负

## selenium 以及 geckodriver

需要 selenium 模块来模拟浏览器操作，需要下载 firefox 浏览器的[geckodriver](https://github.com/mozilla/geckodriver/releases)。

注：经测试 chromedriver 无法满足需求

## for docker

- 构建镜像

```bash
docker build -t uestc-health-report --network host .
```

- 运行

```bash
docker run -itd --restart=always --name=uhr \
    -v /path/xxxx/personal_info.py:/app/server/personal_info.py \
    uestc-health-report
```

- 配置文件

容器需要指定一个配置文件`personal_info.py`, 模板为`personal_info_demo.py`, 修改其中的`webdriver_path`的值为`r"/app/server/geckodriver"`。
然后在命令中指定配置文件路径即可, 即修改`-v /path/xxxx/personal_info.py:/app/server/personal_info.py`中的`/path/xxxx/personal_info.py`

## 配置

配置 python 环境：`pip install -r requirements.txt`

修改 personal_info_demo.py 中的 webdriver_path 的值为你的电脑上 geckodriver 所在位置。

根据 personal_info_demo.py 添加自己的信息

personal_info_demo.py 更名为 personal_info.py

## 运行

### 每日打卡

程序会首先将今天的打卡完成，之后会自动在每日零时登录并打卡

```bash
python main.py
```

![效果图](readme_imgs/2.jpg)

### 一劳永逸

注意：未来体温填报经测试成功，但未来打卡未测试

```bash
python once_for_all.py
```

![效果图](readme_imgs/5.jpg)

## 实现思路

通过 chrome 的 develop tools 的 network 面板在每日打卡填报时候进行抓包，找到进行每日报平安以及体温上报的 api。

- 首先在 postman 中测试直接请求 api 是否可行，发现只需要带个人 cookie 以及报平安以及体温的参数即可。

- 其次还偶然发现并不需要与个人 cookie 进行绑定才能进行打卡，换言之，只要登录上了，如果有别人的学号和姓名就可通过脚本帮他体温打卡，报平安填的个人参数会更多些也更私人。

  > 只要登录上了就可向体温上报和报平安的数据库中写数据，而这个数据只要符合格式就可，是谁的都可以
  > （以上为个人猜测的后端实现）

- 对于体温上报的 api，每日可以多次体温上报，并不只早中晚各一次，而是无限次，只是在前端做了限制。
  > 前端的逻辑是当点击了体温上报按钮后先调用查询体温上报的 api，看当前时段是否打卡过，如果打过则弹窗已经打过结束；
  > 如果没打过，则调用体温打卡的 api，打卡当前次，之后再调用一次查询全部体温打卡记录的 api 刷新整个页面。
- 对于每日报平安的 api，也是可以多次报平安，但页面上只显示最近的一次。故猜测后端有两种可能的实现方式，一是当天重复打卡的会覆盖掉上一次的，二是也是打卡无限次，但前端做了处理，只显示当天最近的一次打卡。

* [x] 每日三次体温上报、每日报平安均支持已打卡检测，避免重复打卡

## 待实现

- [ ] 滑块验证码的破解

## 版本说明

main.py(v1.0) 无浏览器页面打开，绕过验证码自动登录，定时打卡

cv_main.py(未完成) 模拟手动滑动验证码登录
