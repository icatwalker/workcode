//创建div标签
var newItem=document.createElement("div")
//添加class属性
newItem.setAttribute("class","ccc");
//div标签插入img
newItem.innerHTML = "<img src='images/goback.png' onclick='window.history.go(-1)' />";
//组合好的div插入body下的第一个子元素之前
document.body.insertBefore(newItem,document.body.childNodes[0]);