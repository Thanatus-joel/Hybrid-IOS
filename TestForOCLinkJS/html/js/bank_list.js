//是否允许加载更多
var loader = true;

$(function(){
	//判断下拉，上拉对象参数
	var $_banklist = $(".banklist");
	var $_wrapper = $(".wrapper");

	//获得doc对象
	var banklist = $_banklist.get(0);

	//计算各项属性高度
	var list_height = $_banklist.height();
	
	//滑动监听位置定义
	var startPosition, endPosition, deltaX, deltaY, moveLength;

	var winRef = $_wrapper.height(); //参考高度
	var start = 0; //开始位置
	var end = 0; //结束位置
	var page = 1; //起始页码

	//下拉，上拉动作判断
	//滑动开始
	/*banklist.addEventListener("touchstart", function(e){
		var touch = e.targetTouches[0];
		//获得起始坐标
		startPosition = {
			x: touch.pageX,
			y: touch.pageY
		};
		start = $(window).scrollTop();
		end = $_banklist.height()-$(window).scrollTop();
	}, false);

	//滑动中
	banklist.addEventListener("touchmove", function(e){
		var touch = e.targetTouches[0];
		endPosition = {
			x: touch.pageX,
			y: touch.pageY
		};

		//判断位置
		if(startPosition.y < endPosition.y){//下拉
			if(start == 0){
				bridge.callHandler("refresh", "1", function(data){
					if(data == undefined || data == null){
						alert("没有获取到数据！");
					}else{
						setBankList(JSON.parse(data), false);
					}
				});
			}				
		} else if(startPosition.y > endPosition.y){//上拉动作
			console.log("1+" + loader);
			if(end <= winRef && loader){
				loader = false;
				page += 1;
				console.log("2" + loader);
				bridge.callHandler("loadMore", page, function(data){
					if(data == undefined || data == null){
						alert("没有获取到数据！");
					}else{
						setBankList(JSON.parse(data), true);
					}
					loader = true;						
				});
			}
		} else {
			//不显示转菊花
			
		}
	}, false);*/

	window.WebView2JsBridge(function(bridge){
		bridge.init();
		//获取banklist
		//注册一个方法供Native调用,获取证件类型list
		//data 格式 ：json数组 fcode：证件号码 fname：证件名
		bridge.registerHandler("getBankList", function(data) {
			if(data == undefined || data == null){
				alert("没有获取到数据！");
			}else{
				setBankList(JSON.parse(data), false);
			}
			//调用Native方法
			//responseCallback(responseData);
		});

		//选择银行
		//data格式：json 值 bankCode 对应后台的银行编码，bankName 银行名称, bankAmount金额
		$(".banklist").on("tap",".bank_item", function(){
			//获取银行Code Name Amount等数据返回给服务器
			var code = $(this).attr("data-code"); //银行CODE
			var flag = $(this).attr("data-flag"); //银行表示
			var mode = $(this).attr("data-mode"); //银行MODE
			var phone = $(this).attr("data-phone"); //银行电话
			var name = $(this).find(".bank_name").text(); //银行名称
			var amount = $(this).find(".bank_type").text(); //账户类型

			//获取图片名称
			var img = $(this).find(".inner_img").css("background");
			//两次过滤后获得最终图片名称
			img = img.substring(img.lastIndexOf('(')+1, img.lastIndexOf(")"));
			img = "icon_bank/" + img.substring(img.lastIndexOf('/')+1);

			//传输给Native的数据
			var bankData = {
				bankCode: code,
				bankName: name,
				bankAmount: amount,
				bankImg: img,
				tiecardflag: flag,
				capitalmode: mode,
				phone: phone
			};

			//转换为JSON
			var sendData = JSON.stringify(bankData);

			//调用Native方法，传值给Native
			bridge.callHandler("selectedBank", sendData, function(){});
		});

		//下拉，上拉动作判断
		//滑动开始
		banklist.addEventListener("touchstart", function(e){
			var touch = e.targetTouches[0];
			//获得起始坐标
			startPosition = {
				x: touch.pageX,
				y: touch.pageY
			};
		}, false);

		//滑动中
		banklist.addEventListener("touchmove", function(e){
			var touch = e.targetTouches[0];
			endPosition = {
				x: touch.pageX,
				y: touch.pageY
			};
			start = $(window).scrollTop();
			end = $_banklist.height()-$(window).scrollTop();
		}, false);

		//滑动结束
		banklist.addEventListener("touchend", function(e){
			var touch = e.changedTouches[0];
			endPosition = {
				x: touch.pageX,
				y: touch.pageY 
			};

			//判断位置
			if(startPosition.y < endPosition.y){//下拉
				if(start == 0){
					bridge.callHandler("refresh", "1", function(data){
						if(data == undefined || data == null){
							alert("没有获取到数据！");
						}else{
							setBankList(JSON.parse(data), false);
						}
					});
				}				
			} else if(startPosition.y > endPosition.y){//上拉动作
				console.log(end<=winRef);
				if(end <= winRef && loader){
					loader = false;
					page += 1;
					bridge.callHandler("loadMore", page, function(data){						
						if(data == undefined || data == null){
							alert("没有获取到数据！");
						}else{
							setBankList(JSON.parse(data), true);
						}					
					});
				}
			} else {
				//不显示转菊花
				
			}
		}, false);
	});
});

//填充银行列表
function setBankList(datalist, append){
	var list = "";
	var last_li = "";
	$.each(datalist, function(i,v){
		if(i < (datalist.length - 1)){
	    	last_li = "";
	    } else {
	    	last_li = "last_item";
	    }
		list += "<li class='bank_item' data-code="+ v.bankCode +" data-flag="+v.tiecardflag+" data-mode="+v.capitalmode+" data-phone="+v.phone+">";
	    list += "  <div class='bankicon'>";
	    list += "    <div class='icon_wrap'>";
	    list += "		<div class='icon_cell'>";
	    list += "      		<div class='inner_img icon_bank_"+ v.bankCode +"'></div>";
	    list += "		</div>";
	    list += "    </div>";
	    list += "  </div>";
	    list += "  <div class='bank_info " + last_li + "'>";
	    list += "    <div class='bank_info_flex'>";
	    list += "      <div class='bank_name'>"+ v.bankName +"</div>";
	    list += "      <div class='bank_detail'>";
	    list += "        <span class='bank_type'>"+ v.amountlimitdesc +"</span>";
	    list += "      </div>";
	    list += "    </div>";
	    list += "  </div>";
	    list += "</li>";
	});

	//加载更多或刷新
	if(append){
		$(".banklist").append(list);
	} else {
		$(".banklist").html(list);
	}

	//可以再次加载更多
	loader = true;
}