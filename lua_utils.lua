--==============================--
--desc:脚本的一些工具类
--time:2017-06-15 02:08:49
--date:17.06.15
--==============================--
--@desc:寻图后，根据图的坐标进行点击操作
--@params:
--pointsStr:必填，寻图返回点的字符串
--clickTime:必填，点击时间
--isOffset:必填，是否需要偏移
--offsetX:选填，X轴的偏移值，可以为负值
--offsetY:选填，Y轴的偏移值，可以为负值
function findImgAndClick(pointsStr, clickTime, isOffset, offsetX, offsetY)
	local points = split(pointsStr, ",");
	if isOffset then
		points[1] = points[1] + offsetX;
		points[2] = points[2] + offsetY;
	end
	touchClick(points[1], points[2]);
	sleep(clickTime);
end

--@desc:随机数
--@params:必填，随机数范围，[m,n]
--@return:返回m~n之间的随机数,包括m和n
function randomNum(m, n)
	--设置随机数种子
	math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 8)));
	--随机数
	local num = math.random(m, n);
	return num;
end

--@desc:随机英文字符串
--@params:
--length:必填，随机英文字符串长度
--@return:随机生成的英文字符串
function randomStr(length)
	local str = "";
	--随机生成七位英文
	for i = 1, length, 1
	do
		str = str .. string.char(randomNum(97, 122));
		sleep(1000);
	end
	return str;
end

--@desc:多次点击同一个坐标
--@params:
--pointX:必填,X轴坐标
--pointY:必填,Y轴坐标
--clickCount:必填，点击次数
--@return:
function manyClick(pointX, pointY, clickCount)
	for i = 1, clickCount, 1
	do
		touchClick(pointX, pointY);
		sleep(3000);
	end
end

--@desc:点击后输入
--@params:
--pointX:必填,X轴坐标
--pointY:必填,Y轴坐标
--inputStr:必填，输入内容
--@return:
function clickAndInput(pointX, pointY, inputStr)
	--点击输入框
	touchClick(pointX, pointY);
	sleep(3000);
	--输入内容
	input(inputStr);
	sleep(3000);
end

--@desc:随机返回指定数据中的一个
--@params:必填，可变参数，长度不定，用逗号分隔
--@return:随机返回指定数据中的一个
function randomFromDatas(...)
	--将所有参数存入数组
	local arg = {...};
	--得到数组长度
	local length = #arg;
	--随机数组下标
	local num = randomNum(1, length);
	--返回此下标的值
	return arg[num];
end

--@desc:返回桌面
--@params:
--isKill:必填，boolean类型，是否结束应用，true 结束应用 ，false 不结束应用
--packageName:选填，需要结束的应用包名
--@return:
function backToDesktop(isKill, packageName)
	log("backToDesktop");
	if isKill then
		--结束应用
		kill(packageName);
	end
	for i = 1, 10, 1
	do
		keyInput(1, "4", 1);
		sleep(500);
	end
	for j = 1, 5, 1
	do
		keyInput(1, "3", 1);
		sleep(500);
	end
end

--@desc：开启一个或多个定时器
--@params:
--timerCount:定时器的总数量
--...:必填，int 类型，可变参数，用逗号分隔，必须保留的定时器序号（如1,2,3等）
--@return:
function openTimers(timerCount, ...)
	--将第一个之后的所有的参数都放在arr数组中
	local arr = {...};
	for i = 1, timerCount, 1
	do
		for j = 1, #arr, 1
		do
			a = 0;
			if(i == arr[j]) then
				tidStr = startTimer("\"".."timer" .. i .."\"", 1000, 2000);
				setGloable("\"".."timer" .. i .."\"", tidStr);
				log("定时器" .. i .. "已开启!");
				a = a + 1;
				sleep(3000);
				break;
			end
		end
		if(a == #arr) then
			log("执行完毕!");
			break;
		end
	end
end

--@desc：关闭一个或多个定时器，关闭其他定时器
--@params:
--timerCount:定时器的总数量
--...:必填，int 类型，可变参数，用逗号分隔，必须保留的定时器序号（如1,2,3等）
--@return:
function closeTimers(timerCount, ...)
	local arr = {...};
	--i:定时器1到定时器
	for i = 1, timerCount, 1
	do
		--j:定时器1到定时器#arr
		for j = 1, #arr, 1
		do
			if(i == arr[j]) then
				killTimer("timer" .. i);
				sleep(3000);
				log("定时器" .. i .. "关闭");
			end
		end
	end
end

--@desc：关闭指定的一个或多个定时器，【定时器名字可以】
--@params:可变参数，字符串类型，应该填 setGloable 中的名字
--@return:
function killAssignTimer(...)
	local arg = {...};
	for i = 1, #arg, 1
	do
		killTimer(getGloable(arg[i]));
	end
end

--@desc:分割字符串
--@params:
--str:必填，需要分割的字符串
--delim:必填，分割符
--@return:分割后的字符串集合
function split(str, delim)
	if type(delim) ~= "string" or string.len(delim) <= 0 then
		return;
	end
	local start = 1;
	local t = {};
	while true do
		--简单查找
		local pos = string.find(str, delim, start, true)
		if not pos then
			break;
		end
		table.insert(t, string.sub(str, start, pos - 1));
		start = pos + string.len(delim);
	end
	table.insert(t, string.sub(str, start));
	return t;
end

--@desc:多图坐标分割
function imagesAllSplit(picStr)
	if string.len(picStr) <= 0 then
		return
	end
	--要返回的图片坐标数组
	local picArray = {};
	--将字符串按“;”分割
	--字符串断点
	local pos = 1;
	--坐标字符串长度
	local length = string.len(picStr);
	--当断点超过字符串长度时，结束循环
	while pos <= length + 1 do
		--按分号分出来的字符串 f:分号位置 str:分号截出来的字符串
		local f = string.find(picStr, ";", 1);
		if not f then
			f = string.len(picStr) + 1;
		end
		local str = string.sub(picStr, 1, f - 1);
		--按逗号分出来的字符串 d:逗号位置 str:逗号截出来的字符串
		local d = string.find(str, ",", 1);
		local sstr = string.sub(str, 1, d - 1);
		--将坐标x存入table中
		table.insert(picArray, sstr);
		--将坐标y存入table中
		table.insert(picArray, string.sub(str, d + 1, f - 1));
		picStr = string.sub(picStr, f + 1, string.len(picStr));
		pos = pos + f;
	end
	return picArray;
end

--@desc:删除字符串中的特定字符
function strRemove(str, remove)
	local lcSubStrTab = {};
	while true do
		local lcPos = string.find(str, remove);
		if not lcPos then
			lcSubStrTab[#lcSubStrTab + 1] = str;
			break
		end
		local lcSubStr = string.sub(str, 1, lcPos - 1);
		lcSubStrTab[#lcSubStrTab + 1] = lcSubStr;
		str = string.sub(str, lcPos + 1, #str);
	end
	local lcMergeStr = "";
	local lci = 1;
	while true do
		if lcSubStrTab[lci] then
			lcMergeStr = lcMergeStr .. lcSubStrTab[lci];
			lci = lci + 1;
		else
			break;
		end
	end
	return lcMergeStr;
end 

--截取中英混合的UTF8字符串，endIndex可缺省
function SubStringUTF8(str, startIndex, endIndex)
	if startIndex < 0 then
		startIndex = SubStringGetTotalIndex(str) + startIndex + 1;
	end
	
	if endIndex ~= nil and endIndex < 0 then
		endIndex = SubStringGetTotalIndex(str) + endIndex + 1;
	end
	
	if endIndex == nil then
		return string.sub(str, SubStringGetTrueIndex(str, startIndex));
	else
		return string.sub(str, SubStringGetTrueIndex(str, startIndex), SubStringGetTrueIndex(str, endIndex + 1) - 1);
	end
end
--获取中英混合UTF8字符串的真实字符数量
function SubStringGetTotalIndex(str)
	local curIndex = 0;
	local i = 1;
	local lastCount = 1;
	repeat
		lastCount = SubStringGetByteCount(str, i)
		i = i + lastCount;
		curIndex = curIndex + 1;
	until(lastCount == 0);
	return curIndex - 1;
end

function SubStringGetTrueIndex(str, index)
	local curIndex = 0;
	local i = 1;
	local lastCount = 1;
	repeat
		lastCount = SubStringGetByteCount(str, i)
		i = i + lastCount;
		curIndex = curIndex + 1;
	until(curIndex >= index);
	return i - lastCount;
end

--返回当前字符实际占用的字符数
function SubStringGetByteCount(str, index)
	local curByte = string.byte(str, index)
	local byteCount = 1;
	if curByte == nil then
		byteCount = 0
	elseif curByte > 0 and curByte <= 127 then
		byteCount = 1
	elseif curByte >= 192 and curByte <= 223 then
		byteCount = 2
	elseif curByte >= 224 and curByte <= 239 then
		byteCount = 3
	elseif curByte >= 240 and curByte <= 247 then
		byteCount = 4
	end
	return byteCount;
end 

function screen()
	UID = getUid();
	hostheader = getHostHeader();
	local ret, imgname = saveScreen("", 50);
	if ret then
		log(imgname);
		local imageUrl = hostheader .. "/cpl_control_2.0/cgi/api/uploadImage?imei=" .. UID .. "&image=" .. imgname;
		log("url" .. imageUrl);
		local info = httpGet(imageUrl);
		jsonObjectParse(info);
		for i = 1, 3 do
			if(jsonObjectGetNumber("result") == 1) then
				log("上传截图成功");
				break;
			end
			if i == 3 then
				log("上传失败");
			end
		end
	end
end

---截图函数
-- function screen(hostheader,uid,note)
-- 	local ret, imgname = saveScreen("", 50);
-- 	if ret then
-- 		log(imgname);
-- 		local imageUrl = hostheader .. "/cpl_control_2.0/cgi/api/uploadImage?imei=" .. urlEncode(uid) .. "&image=" .. urlEncode(imgname) .. "&imageNote=" .. urlEncode(note);
-- 		log("url" .. imageUrl);
-- 		local info = httpGet(imageUrl);
-- 		jsonObjectParse(info);
-- 		for i = 1, 3 do
-- 			if(jsonObjectGetNumber("result") == 1) then
-- 				log("上传截图成功");
-- 				break;
-- 			end
-- 			if i == 3 then
-- 				log("上传失败");
-- 			end
-- 		end
-- 	end
-- end

--解码函数
-- function urlEncode(s)
-- 	s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
-- 	return string.gsub(s, " ", "+")
-- end
