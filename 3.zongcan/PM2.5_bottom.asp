<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
response.charset="utf-8"
Function getHTTPPage(url)
On Error Resume Next
dim http 
set http=Server.createobject("Microsoft.XMLHTTP") 
Http.open "GET",url,false 
Http.send() 
if Http.readystate<>4 then
exit function 
end if 
getHTTPPage=bytesToBSTR(Http.responseBody,"UTF-8")
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
url="http://hostname:8080/wpgetsampledata.asp?gettype=0&sid=&utf8=0&hour="	
url="http://localhost/test.html"
if act="getdata" then
response.Write(trim(getHTTPPage(url)))
response.End()
end if
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>PM2.5</title>
<script type="text/javascript" src="js/jquery-1.11.3.js"></script>
<script>

var lastdata="";
$(function(){
	var delay=5;     //设置异步获取数据的时间单位秒
	getdata();
	window.setInterval("getdata();",delay*1000);
});

function getdata(){	//异步数据处理
	var url="data.html?rnd=" + Math.random(9999);
	url="PM2.5_bottom.asp?rnd=" + Math.random(9999);
	var totalstr="";
	//url="http://hostname:8080/wpgetsampledata.asp?gettype=0&sid=&utf8=1&hour=";
	$.ajax({
	data:{gettype:"0",sid:"",utf8:"0",hour:"",act:"getdata"},
	url:url,
	dataType: 'HTML',
	contentType: "application/json; charset=utf-8",
	type: 'GET',		//提交方式
	timeout: 2000,		//失败时间
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
			//console.log(data);
            var xmldoc=$.parseXML(data);
            var json=$(xmldoc).find("tdi").text();
			json=json.split("|");
			json=json[1];
			json=json.replace(",},","}");
		    lastdata=json;
		   var parsedJson = jQuery.parseJSON(json);		//解析
		   totalstr="<span>气温:"+parsedJson.temp + "℃</span><span>湿度:"+parsedJson.humi+"%</span><span>PM2.5:"+parsedJson.PM25+"微克/立方米</span><span>天气现象:"+parsedJson.weather+"</span>";
		   document.getElementById("marqueediv").innerHTML=totalstr;
//		   $("#marqueediv").append(totalstr);
		 }
	}
	});
}
//日期时间函数
</script>
<style type="text/css">
body,td,th {
	font-family: "仿宋","微软雅黑", "宋体";  /*字体*/
	font-size: 14px;
	color: #333;
}
body {
	background:#09F;
	background:url(images/bg2.jpg);   
	background-repeat:repeat-x;
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}

#mainbody{
	width: 1280px;
	overflow:hidden;
	background:#06F;
}
#marqueediv{
	font-size:40px;		/*文字大小*/
	font-weight:bold;
	padding:20px;    /*文字边距*/
	color:#FFF;		/*文字颜色*/
}
#marqueediv span{
	padding-left:50px;
}

</style> 
</head>
<body bgcolor="#000000">
<marquee direction="left" width="1280" height="100" scrollamount="1" scrolldelay="15" truespeed="truespeed">
<div id="marqueediv">
</div>
</marquee>
</body>
</html>
