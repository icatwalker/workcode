<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
response.Charset="utf-8"
Function getHTTPPage(url) 
On Error Resume Next
dim http 
set http=Server.createobject("Microsoft.XMLHTTP") 
Http.open "GET",url,false 
Http.send() 
if Http.readystate<>4 then
exit function 
end if 
getHTTPPage=bytesToBSTR(Http.responseBody,"GB2312")
set http=nothing
If Err.number<>0 then 
Response.Write "<p align='center'><font color='red'><b>服务器获取文件内容出错</b></font></p>" 
Err.Clear
End If  
End Function

Function BytesToBstr(body,Cset)
dim objstream
set objstream = Server.CreateObject("adodb.stream")
objstream.Type = 1
objstream.Mode =3
objstream.Open
objstream.Write body
objstream.Position = 0
objstream.Type = 2
objstream.Charset = Cset
BytesToBstr = objstream.ReadText 
objstream.Close
set objstream = nothing
End Function
dim url,act
act=trim(request("act"))
'链接地址---------------------------------------------------------------------
url="http://10.0.5.36:8080/wpgetsampledata.asp"	
if act="getdata" then
response.Write(getHTTPPage(url))
response.End()
end if
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>PM2.5</title>
<script type="text/javascript" src="js/jquery.min.js"></script>
<script>

var lastdata="";
$(function(){
	var delay=5;     //设置异步获取数据的时间单位秒
	getdata();
	window.setInterval("getdata();",delay*1000);
	nowTime('timediv',24,"time");
});

function getdata(){	//异步数据处理
	var url="data.html?rnd=" + Math.random(9999);
	url="pm2.5.asp";
	//url="http://hostname:8080/wpgetsampledata.asp?gettype=0&sid=&utf8=1&hour=";
	$.ajax({
	data:{gettype:"0",sid:"",utf8:"0",hour:"",act:"getdata"},
	url:url,
	dataType: 'HTML',
	contentType: "application/json; charset=utf-8",
	type: 'GET',		//提交方式
	timeout: 3000,		//失败时间
	error: function(data)
	{
		// 提交失败
		//$("#mainbody").html("数据获取失败");
	},
	success: function(data)
	{
		//提交成功
		if (lastdata!=data)
		{
			var xmldoc=$.parseXML(data);
			var json=$(xmldoc).find("tdi").text();
			json=json.split("|");
			json=json[1];
			json=json.replace(",},","}");
			//alert(json);
   			//$("#mainbody").html(json);
		   lastdata=json;
		   var parsedJson = jQuery.parseJSON(json);		//解析
		   $("#temp").html(parsedJson.temp);
		   $("#humi").html(parsedJson.humi);
		   $("#winddir").html(parsedJson.winddir);
		   $("#windspd").html(parsedJson.windspd);
		   $("#rain").html(parsedJson.rain);
		   $("#rainsum").html(parsedJson.rainsum);
		   $("#press").html(parsedJson.press);
		   $("#PM25").html(parsedJson.PM25);
		   $("#PM10").html(parsedJson.PM10);
		   $("#visual").html(parsedJson.visual);
		   $("#airquality").html(parsedJson.airquality);
		   $("#weather").html(parsedJson.weather);
		 }
	}
	});
}
//日期时间函数
function nowTime(ev,type,strtype){
	/*
	 * ev:显示时间的元素
	 * type:时间显示模式.若传入12则为12小时制,不传入则为24小时制
	 strtype：显示时间的格式
	 */
	//年月日时分秒
	var Y,M,D,W,H,I,S,AMPM;
	AMPM="";
	//月日时分秒为单位时前面补零
	ev=document.getElementById(ev)
	function fillZero(v){
		if(v<10){v='0'+v;}
		return v;
	}
	(function(){
		var d=new Date();
		var Week=['星期天','星期一','星期二','星期三','星期四','星期五','星期六'];
		Y=d.getFullYear();
		M=fillZero(d.getMonth()+1);
		D=fillZero(d.getDate());
		W=Week[d.getDay()];
		H=fillZero(d.getHours());
		I=fillZero(d.getMinutes());
		S=fillZero(d.getSeconds());
		//12小时制显示模式
		if(type && type==12){
			//若要显示更多时间类型诸如中午凌晨可在下面添加判断
			if(H<=12){
				AMPM='AM';
			}else if(H>12 && H<24){
				H-=12;
				H=fillZero(H);
				AMPM='PM';
			}else if(H==24){
				H='00';
				AMPM='PM';
			}
		}
		if(strtype && strtype=="onlytime"){
			ev.innerHTML=H+':'+I+':'+S+' '+AMPM;
		}else if(strtype&&strtype=="time" ){
			ev.innerHTML=Y+'年'+M+'月'+D+'日'+' '+W+' '+H+':'+I+':'+S+' '+AMPM;
		}else if(strtype&&strtype=="date" ){
			ev.innerHTML=Y+'年'+M+'月'+D+'日';
		}else if(strtype&&strtype=="week" ){ 
			ev.innerHTML=W;
		}else{
		//ev.innerHTML=' '+Y+'-'+M+'-'+D+''+''+W+'<br>'+H+':'+I+':'+S+' '+AMPM;
			ev.innerHTML=H+':'+I+':'+S+' '+AMPM+' '+Y+'年'+M+'月'+D+'日'+' '+W;
		}
		//每秒更新时间
		if(strtype&&strtype=="date" ){
			setTimeout(arguments.callee,3600000);
		}else if(strtype&&strtype=="week" ){
			setTimeout(arguments.callee,3600000);
		}else{
			setTimeout(arguments.callee,1000);
		}
	})();
}
</script>

<style type="text/css">
body,td,th {
	font-family: "微软雅黑", "宋体";
	font-size: 14px;
	color: #333;
}
body {
	background-color: #000;
	background: url(images/bg1.jpg);
	background-repeat: no-repeat;
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
#timediv{
	position: absolute;
	top: 36px;
	left: 857px;
	font-size: 22px;
	color: #FFF;
	font-weight: bold;
	width: 357px;
	height: 40px;
}
#mainbody{
	position: absolute;
	top: 95px;
	left: 65px;
	width: 1145px;
	height: 581px;
}
#title{
	font-size:46px;
	font-weight:bold;
}
.datatable td{
	font-size:32px;
	font-weight:bold;
    white-space: nowrap;
　　overflow: hidden;
　　text-overflow: ellipsis;
}
.datastr{
	color:#009;
}

</style> 
</head>

<body background="images/bg1.jpg">
<div id="timediv"></div>
<div id="mainbody">
  <table width="100%" border="0" cellspacing="0" cellpadding="15" class="datatable">
    <tr>
      <td colspan="4" align="center" id="title">大气环境实时监测数据<br />
      <hr width="60%" size="3" color="#333333"/>
      </td>
    </tr>
    <tr>
      <td width="25%" align="right" valign="middle">气&nbsp;&nbsp;&nbsp;&nbsp;温：</td>
      <td width="25%" valign="middle" id="temp" class="datastr">&nbsp;</td>
      <td width="25%" align="right" valign="middle">气&nbsp;&nbsp;&nbsp;&nbsp;压：</td>
      <td width="25%" valign="middle" id="press" class="datastr">&nbsp;</td>
    </tr>
    <tr>
      <td align="right">湿&nbsp;&nbsp;&nbsp;&nbsp;度：</td>
      <td id="humi" class="datastr">&nbsp;</td>
      <td align="right">PM&nbsp;2.5：</td>
      <td id="PM25" class="datastr">&nbsp;</td>
    </tr>
    <tr>
      <td align="right">风&nbsp;&nbsp;&nbsp;&nbsp;向：</td>
      <td id="winddir" class="datastr">&nbsp;</td>
      <td align="right">PM&nbsp;10：</td>
      <td id="PM10" class="datastr">&nbsp;</td>
    </tr>
    <tr>
      <td align="right">风&nbsp;&nbsp;&nbsp;&nbsp;速：</td>
      <td id="windspd" class="datastr">&nbsp;</td>
      <td align="right">能&nbsp;见&nbsp;度：</td>
      <td id="visual" class="datastr">&nbsp;</td>
    </tr>
    <tr>
      <td align="right">降水强度：</td>
      <td id="rain" class="datastr">&nbsp;</td>
      <td align="right">空气质量：</td>
      <td id="airquality" class="datastr">&nbsp;</td>
    </tr>
    <tr>
      <td align="right">日降水量：</td>
      <td id="rainsum" class="datastr">&nbsp;</td>
      <td align="right" >天气现象：</td>
      <td id="weather" class="datastr">&nbsp;</td>
    </tr>
  </table>
</div>
</body>
</html>
