// $(function(){
	var status = $("#status").val();
	var user = $("#u_user").val();
	var psw = $("#u_psw").val();
	var cc = $("#u_checkcode").val();

	var error = 0;

	function check(){
		if(status=='1'){
			$("#error_status").css("display","inline");
			error++;
		}
		if(empity(user)){
			$("#error_user").css("display","inline");
			error++;
		}
		if(empity($psw)){
			$("#error_psw").css("display","inline");
			error++;
		}
		if(empity($cc)){
			$("#error_checkcode").css("display","inline");
			error++;
		}
		if(error!=0)
			return false;
		else
			return true;
	}

	function empity(s){
		var whitespace = "\t\n\r";
		var i;
		if(s == null || s.length == 0||s=="输入账号"||s=="输入密码"||s=="输入验证码") return true;
		for(i = 0;i < s.length;i++)
		{
			var c = s.charAt(i);
			if(whitespace.indexOf(c) == -1) return false;
		}
		return true;
	}
// });