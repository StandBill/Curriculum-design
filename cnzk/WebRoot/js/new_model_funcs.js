function Clear(){
	var eles=document.getElementsByTagName("input");
	for(var i=0;i<eles.length;i++){
		if(eles[i].id=="number"||eles[i].id=="college"||eles[i].id=="district"||eles[i].id=="start_date"){
			eles[i].value="";
		}else{
			continue;
		}
	}
}
function setTrBgColor(tableid,color1,color2){
	var tab=document.getElementById(tableid);
	for(var i=0;i<tab.rows.length;i++){
		tab.rows[i].style.backgroundColor=(i%2==0)?color1:color2;
	}
}
window.onload=function(){
	setTrBgColor("tb_content","#f5f5f5","white");

}
function setLiBgColor(Id){
	var before = document.getElementById("select");
	var teacher = document.getElementById("select_teacher");
	if(Id=="select"){

		before.style.background="#232423";
		before.style.opacity="1.0";

		teacher.style.background="#343535";
		teacher.style.opacity="0.8";

	}else if(Id=="select_teacher"){
		teacher.style.background="#232423";
		teacher.style.opacity="1.0";

		before.style.background="#343535";
		before.style.opacity="0.8";
	}
}
function getData(item,obj){
	var xhr;
	if(window.XMLHttpRequest){
		xhr = new XMLHttpRequest();
	}else if(window.ActiveXObject){
		xhr = new ActiveXOject("Microsoft.XMLHTTP");
	}
	xhr.onreadystatechange=function(){
		if(xhr.readyState==4&&xhr.status==200){
			var txt = xhr.responseText.split(",");
			for(var i = 0;i < txt.length;i++){
				$("#"+obj).append("<option value='"+txt[i]+"'>"+txt[i]+"</option>");
			}
		}
	}
	xhr.open("POST","AJServlet",true);
	xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xhr.send("status="+item);
}
