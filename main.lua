--lua:CPL 封神霸业 注册包
--author：汪奇祺
--2018.5.7
---该脚本主要负责启动游戏
setWhiteList("*kfbtg.keleyx.com;*member.keleyx.com;*www.keleyx.com;*img1.37wanimg.com/www2015/images/;*s1.cqsj.keleyx.com;*s5.yx-s.com/;*s0.qhimg.com;*cdn.cqsj.tanwan.com;*vip.keleyx.com");
include("./lua_utils.lua")
function main()
	--游戏名称
	GAME_NAME = "封神霸业";
	--游戏网址
	GAME_URL = "http://kfbtg.keleyx.com/163/tg/143/?pyx_url=tcpl-cqsj-1";
	log("start main");
	log(getUserAgent());
	setUserAgent(getUserAgent());
	--初始化数据
	initData();	
	--启动游戏
	startGame(GAME_NAME, GAME_URL);
    sleep(30000);
	--判断游戏是否已经打开
	if isRunning(GAME_NAME) then
		log("页面打开");
		sleep(15000);
		--touchClick(400,500)
		for i = 1, 10 do
			local dianxinPic = findImageFuzzy("./zhuce.png", 80, 0, 0, 1400, 835);
			if(dianxinPic ~= "-1") then
				findImgAndClick(dianxinPic, 3000, true, 0, 0);
				log("点击注册");
				sleep(5000);
				--新用户注册登录
				userRegister();
                --是否注册成功
                sleep(5000);
				isRegistSuccess();
				--进入游戏准备开启定时器
				tabLua("./run_game.lua");
				break;
			else
				sleep(1500);
				if i == 10 then
					log("没找到开始游戏");
					screen();
					endLua(- 3);
				end
			end
		end
	else
		log("This game is not running");
		--异常结束 再次执行
		endLua(- 1);
	end
end

function getUserAgent()
	local utab = {
		"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36",
		"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.104 Safari/537.36 Core/1.53.3373.400 QQBrowser/9.6.11864.400",
		"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.108 Safari/537.36 2345Explorer/8.7.0.16013",
		"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36",
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.90 Safari/537.36",
		"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.104 Safari/537.36 Core/1.53.3226.400 QQBrowser/9.6.11681.400",
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:54.0) Gecko/20100101 Firefox/54.0",
		"Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.87 Safari/537.36"
	};
	local uid = getUid();
	local subuid = tonumber(string.sub(uid, string.len(uid) - 2, string.len(uid)));
	if(subuid == nil) then
		subuid = 1; 			--如果取不到 uid 则取第一个
	end
	
	local index = math.floor(subuid % 8 + 1);
	log("" .. index);
	return utab[index];
end

function initData()
	UID = getUid();
	hostheader = getHostHeader();
	str = httpGet(hostheader .. "/cpl_control_2.0/cgi/api/getAccountData?imei=" .. UID);
	log(hostheader);
	--释放全部的数据
	jsonObjectParse(str);
	log(str);
	for i = 1, 10 do
		if(jsonObjectGetNumber("result") == 1) then
			resourceUser = jsonObjectGet("object");
			log(resourceUser);
			jsonObjectParse(resourceUser);
			USERNAME = jsonObjectGet("username");
            PWD = jsonObjectGet("password");
            EMAIL = jsonObjectGet("email");
			break;
		else
			if i == 10 then
				log("获取数据失败");
				endLua(- 2);
				exit();
			else
				sleep(1000);
			end
		end
	end
end

-- 449  310  349  393
function userRegister()
	for i = 1, 10 do
		local zhucePic = findImageFuzzy("./zckuang.png", 90, 0, 0, 1400, 835);
		if zhucePic ~= "-1" then
			log("达到个性注册页" .. zhucePic);
			findImgAndClick(zhucePic,3000,true,0,-139);
			input(USERNAME)
			sleep(1000)
			log("yang"..USERNAME);
			findImgAndClick(zhucePic,3000,true,0,-100);
			sleep(1000)
			input(PWD)
			log("密码"..PWD)
			findImgAndClick(zhucePic,3000,true,0,-56)
			sleep(1000)
			input(PWD)
			log("pwd")
			-- findImgAndClick(zhucePic,3000,true,0,-63)
			-- sleep(1000)
			-- input(EMAIL)	
			-- log("email")
			findImgAndClick(zhucePic,3000,true,10,10)
			sleep(3000);
			screen();
			break;
		else
            local zhucePic2 = findImageFuzzy("./zhuce.png", 90, 0, 0, 1400, 835);
			if zhucePic2 ~= "-1" then
				log("登录页");
				findImgAndClick(zhucePic2, 3000, true, 0, 0);
			end
		end
		if i > 10 then
			endLua(0);
		else
			sleep(3000);
		end
	end
end


--855 550   729 696
function isRegistSuccess()
	runJS("$(\'#regform\').attr(\'target\',\'_self\')");
	runJS("window.alert = function(str){return;}");
	local zhucePic2 = findImageFuzzy("./yizhuce.png", 90, 0, 0, 1400, 835);
	if zhucePic2 ~= "-1" then
		log("已被注册");
		screen();
		httpGet(hostheader .. "/cpl_control_2.0/cgi/api/setAccountData?imei=" .. UID .. "&username=" .. USERNAME .. "&status=" .. 0);
		--去登录
		endLua(- 1);
	else
        screen();
        log("注册成功")
        
        local dengluPic = findImageFuzzy("./chengong.png",90,0,0,1400,800);
        if(dengluPic ~= "-1")then
			log("注册成功");
			httpGet(hostheader .. "/cpl_control_2.0/cgi/api/setAccountData?imei=" .. UID .. "&username=" .. USERNAME .. "&status=" .. 1);
			--findImgAndClick(dengluPic,3000,true,-126,146)
			screen()
			--endLua(1)
		else
			log("没找到创角按钮")
			screen()
			endLua(- 1);
        end
    end	
end

