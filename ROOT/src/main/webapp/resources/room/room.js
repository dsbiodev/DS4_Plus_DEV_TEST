var gNameFontSize = '45px', sangjuFontSize = '45px', jangjiFontSize = 0;



//document.addEventListener("DOMContentLoaded", function() {
//  sangjuFontSize = window.getComputedStyle(document.getElementsByClassName("sangjuContainer")[0]).fontSize === "0px" ?
//    (document.getElementsByClassName("sangjuContainer")[0]).currentStyle.fontSize : window.getComputedStyle(document.getElementsByClassName("sangjuContainer")[0]).fontSize;
//});

var SANGJU_MAX_CNT = 20;//상주 최대 라인수.
var LOOP_MAX_CNT = 110; //글자크기 조절 반복분 루프 max 횟수
var JANGJI_MAX_CNT = 2; //장지 최대 라인수.


//유가족 형식 만들기
var createMap = function(_this){
	var list = [];
	$.each(_this, function(){
		var _ = $(this);
		var _name = "";
		
		$.each(_.find($('.chief-mourner-wrap .wrapper-item')), function(){
			_name += $(this).find('span').text()+"^#$%&PB$@!"
		});
		
		if(_name.length > 0){
			if(_name.substr(_name.length-10, 10) == "^#$%&PB$@!"){
				_name = _name.substr(0, _name.length -10);
			}
			var _chiefMournerObj = { 
				RELATION : _.find('.body-text.family').val(),
				NAMES : _name
			};
			list.push(_chiefMournerObj);
		}
	});
	
	return list;
} 

//텍스트형  만들기
var createTxt = function(_list){
	var str = "";
	$.each(_list, function(){
		str += this.RELATION;
		if(this.NAMES){
			var _names = this.NAMES.split('^#$%&PB$@!');
			str += " : ";
			$.each(_names, function(idx, _value) {
				str += _value;
				if(_names.length != (idx+1)) str += ", ";	
			});
			str += "\n";
		}else{
			str += "\n";
		}
	})
	setSangJu(str);
};


//유가족 뽑아와서 텍스트 만들기 까지 -- 빈소현황판 적용
$.fn.fnBinsoFamily = function(_eventNo, _data, _div) {
	var list = [];
	$.each(_data, function(idx){
		if(_eventNo == this.EVENT_NO){
			list.push(this);
		}
	});

	var str = "";
	$.each(list, function(){
		str += this.RELATION;
		if(this.NAMES){
			var _names = this.NAMES.split('^#$%&PB$@!');
			str += " : ";
			$.each(_names, function(idx, _value) {
				str += _value;
				if(_names.length != (idx+1)) str += ", ";	
			});
			str += "\n";
		}else{
			str += "\n";
		}
	})
	
	setSangJu(str, this);
}

	
//미리보기 화면
function setSangJu(beforeTxt, _ , _mode){  //상주  innerHTML임
	var sangjuTxt = changeSpaceUnicode(getSplitLines(beforeTxt, SANGJU_MAX_CNT));
	var txtArray = sangjuTxt.split('<br>');
	var lineCnt = 0;
	var hasColon = false;

	txtArray.forEach(function(element, index){
	    if(!hasColon && element.indexOf(":") < 0){
	    	txtArray[index] = "<div class='sangJuOrderDiv'><span class='sangJuText'>" + element + "</span></div>";
	    }else{
	    	if(element.indexOf(":")>0){
	    		var _names = "";
	    		var _length = element.substring(element.indexOf(":") + 1).split(',').length;
	    		
	    		$.each(element.substring(element.indexOf(":") + 1).split(','), function(idx, value){
	    			if((idx+1) != _length){
	    				_names += "<div>"+value+",</div>";
	    			}else{
	    				_names += "<div>"+value+"</div>";
	    			}
	    		});
	    		txtArray[index] = "<div class='sangJuOrderDiv'><span class='sangJuOrder'>" + element.substring(0,element.indexOf(":")) +
	    			"<span class='colon'>:</span>&nbsp;</span><span class='sangJuText'>" + _names + "</span></div>";
//	    			"<span class='colon'>:</span>&nbsp;</span><span class='sangJuText'>" + element.substring(element.indexOf(":") + 1) + "</span></div>";
	    		hasColon = true;
	    	}else{
	    		txtArray[index] = "<div class='sangJuOrderDiv'><span class='sangJuOrder'></span><span class='sangJuText'>" + element + "</span></div>";
	    	}
	    }
	    lineCnt ++;
	});
	sangjuTxt = txtArray.join("");
	
	var element = _ ? _.find('.col3') : document.getElementsByClassName("col3")[0];
  	var sangjuContainer = _ ? _.find('.sangjuContainer') : document.getElementsByClassName("sangjuContainer")[0];
  	var sangjuRoot = _ ? _ : document.getElementsByClassName("sangjuRoot")[0];
	
  	if (existElement(element) && existElement(sangjuContainer) && existElement(sangjuRoot)) {
  		$(element).html(sangjuTxt);
		
		//글자공백 스페이스 2개당 한글자씩 변환
  		$.each($(element).find('.sangJuText div'), function(idx, value){
  			var _tmp = $(this).text().replace(',', '');
  			if(_tmp.replace(/^\s+|\s+$/g, '') == ""){
  				var _inTxt = "";
  				
  				for(var i=0;i<_tmp.length-1;i+=2){
  					_inTxt += "아";
  				}
  				$(this).prev().html($(this).prev().text().replace(',', '&nbsp'));
  				$(this).html("&nbsp"+_inTxt+"&nbsp").css('color', 'transparent');
  			}
  		});
  		
  		//sangJu line-height
  		if(SANGJU_MAX_CNT > 5){ $(element).css("line-height", applyLineHeight(lineCnt)) } 
    	$(sangjuContainer).css("font-size", sangjuFontSize);
    	autoFontSize(sangjuContainer, sangjuRoot);
  	}

  	/** sangJuOrder 길이 */
  	var largestWidth = 0;
  	var sangJuOrder = _ ? _.find('.sangJuOrder') : document.getElementsByClassName("sangJuOrder");
  	var sangJuText = _ ? _.find('.sangJuText') : document.getElementsByClassName("sangJuText");

  	if (existElement(sangJuOrder) && existElement(sangjuContainer) && existElement(sangjuRoot)) {
	    if(sangJuOrder.length>0){
	    	for(var k=0; k<sangJuOrder.length; k++){
	    		if(largestWidth < sangJuOrder[k].offsetWidth){
	    			largestWidth = sangJuOrder[k].offsetWidth;
	    		}
	    	}
	    	for(var k=0; k<sangJuOrder.length; k++){
	    		sangJuOrder[k].style.width = (largestWidth + 1) + "px";
	    		sangJuText[k].style.width = $(sangjuRoot).width() - (largestWidth + 1) + "px";
	    	}
	    }
	    /** sangJuOrder 길이 */
	    //상주오더때문에 글자 크기 체크 한번더 해야함.
	    autoFontSize(sangjuContainer, sangjuRoot);
  	}
  	
//  	/////////////////기존코드//////////////
//  	var element = document.getElementsByClassName("col3")[0];
//  	var sangjuContainer = document.getElementsByClassName("sangjuContainer")[0];
//  	var sangjuRoot = document.getElementsByClassName("sangjuRoot")[0];
//  	if (existElement(element) && existElement(sangjuContainer) && existElement(sangjuRoot)) {
//  		element.innerHTML = sangjuTxt;
//  		if(SANGJU_MAX_CNT > 5){ element.style.lineHeight = applyLineHeight(lineCnt); } //sangJu line-height
//    	sangjuContainer.style.fontSize = sangjuFontSize;
//    	autoFontSize(sangjuContainer, sangjuRoot);
//  	}
//
//  	/** sangJuOrder 길이 */
//  	var largestWidth = 0;
//  	var sangJuOrder = document.getElementsByClassName("sangJuOrder");
//  	if (existElement(sangJuOrder) && existElement(sangjuContainer) && existElement(sangjuRoot)) {
//	    if(sangJuOrder.length>0){
//	    	for(var k=0; k<sangJuOrder.length; k++){
//	    		if(largestWidth < sangJuOrder[k].offsetWidth){
//	    			largestWidth = sangJuOrder[k].offsetWidth;
//	    		}
//	    	}
//	    	for(var k=0; k<sangJuOrder.length; k++){
//	    		sangJuOrder[k].style.width = (largestWidth + 1) + "px";
//	    	}
//	    }
//	    /** sangJuOrder 길이 */
//	    //상주오더때문에 글자 크기 체크 한번더 해야함.
//	    autoFontSize(sangjuContainer, sangjuRoot);
//  	}
}

function setBinso(_tag){ //빈소 조정
	var _tmp = 0;
	_tag.find('.status').css('font-size', "30px");
	while(true){
		if(_tag.find('.status').height() < _tag.height()){
			var font = _tag.find('.status').css('font-size');
			font = font.substr(0, font.length-2);
			_tag.find('.status').css('font-size', ((font*1) - 1) + "px");
			break;
		}
		var font = _tag.find('.status').css('font-size');
		font = font.substr(0, font.length-2);
		_tag.find('.status').css('font-size', ((font*1) - 1) + "px");
		
		if(_tmp > 30) break;
		_tmp ++;
	}
}


//장지 변경
function setJangJi(jangji){ //장지  innerHTML임
  var element = document.getElementsByClassName("col4")[0];
  var jangjiContainer = document.getElementsByClassName("jangjiContainer")[0], jangjiRoot = document.getElementsByClassName("jangjiRoot")[0];

  if (existElement(element) && jangji !== undefined) {
    element.innerHTML = changeSpaceUnicode(getSplitLines(jangji, JANGJI_MAX_CNT));
  }

  if (existElement(jangjiContainer) && existElement(jangjiRoot)){
    jangjiContainer.style.fontSize = jangjiFontSize;
    autoFontSize(jangjiContainer, jangjiRoot);
  }
}


function setAllFont(value) {  //폰트 변경
    document.getElementById("body").style.fontFamily = value;
}

function setLogo(path){ // 로고 경로 할당
  var element = document.getElementById("logoImg");
  if (existElement(element) && checkTextAndPath(path, true)) {
    element.src = path;
  }
}

function setImage(path){  //메인 이미지 경로 할당
  var element = document.getElementById("mainImg");
  if (existElement(element) && checkTextAndPath(path, true)) {
    element.src = path;
  }
}

function setReligion(path){ //종교 백그라운드 이미지
  var element = document.getElementsByClassName("sangjuRoot")[0];
    if (existElement(element) && checkTextAndPath(path, true)) {
      element.style.background = "url('" + path + "')no-repeat";
      element.style.backgroundSize = "100% 100%";
    }
}

function setName(gName){  //고인 이름
	var element = document.getElementsByClassName("col2")[0];

	if(gName !== undefined && gName !== null && gName.length>0 && existElement(element)){
		element.innerHTML = gName;
	}
	var gNameContainer = document.getElementsByClassName("gNameContainer")[0], gNameRoot = document.getElementsByClassName("gNameRoot")[0];
	gNameContainer.style.fontSize = gNameFontSize;
	
	autoFontSize(gNameContainer, gNameRoot);
}

function setAge(gAge){  //나이
  var element = document.getElementsByClassName("col7")[0];
  if (existElement(element) && gAge !== undefined){
    if(gAge==0 || gAge=="0"){
      element.innerText = "";
    }else {
      element.innerText = " " + gAge+"세";
      var parentheses = document.getElementsByClassName("parentheses");
      
      // 나이에 불필요한 괄호가 나온다.
      // if(existElement(parentheses)){
      //   for(var i=0; i<parentheses.length; i++){
      //     parentheses[i].style.display = "inline";
      //     parentheses[i].style.visibility = "visible";
      //   }
      // }

    }
  }
  var gNameContainer = document.getElementsByClassName("gNameContainer")[0], gNameRoot = document.getElementsByClassName("gNameRoot")[0];
  gNameContainer.style.fontSize = gNameFontSize;
  autoFontSize(gNameContainer, gNameRoot);
}

//col7 - age 나이
//col8 - gender 성별
//col9 - religion 종교
function setGender(gGender){  //성별. 0이면 남자, 1이면 여자
  var element = document.getElementsByClassName("col8")[0];//성별
  var element2 = document.getElementsByClassName("col9")[0];//종교

  if (existElement(element) && gGender !== undefined){
    if(gGender==0 || gGender=="0" || gGender=="" || gGender==""){
        element.innerText = "";
    }if(gGender==1 || gGender=="1" || gGender=="남성" || gGender=="남"){
        element.innerText = "남";
    }if(gGender==2 || gGender=="2" || gGender=="여성" || gGender=="여"){
        element.innerText = "여";
    }if(gGender==3 || gGender=="3" || gGender=="男性" || gGender=="男"){
        element.innerText = "남자";
    }else if(gGender==4 || gGender=="4" || gGender=="女性" || gGender=="女"){
        element.innerText = "여자";
    }

    var parentheses = document.getElementsByClassName("parentheses");
    if (!(gGender==0 || gGender=="0" || gGender=="" || gGender=="")){//성별이 있는 경우
      if(existElement(parentheses)){
        for(var i=0; i<parentheses.length; i++){
          parentheses[i].style.display = "inline";
          parentheses[i].style.visibility = "visible";
        }
      } else {
        for(var i=0; i<parentheses.length; i++){
          parentheses[i].style.display = "none";
        }
      }

      var element2 = document.getElementsByClassName("col9")[0];
      if (existElement(element2) && element2.innerText.length > 0) {
        document.getElementsByClassName("space")[0].style.display = "initial";
      }

      var gNameContainer = document.getElementsByClassName("gNameContainer")[0], gNameRoot = document.getElementsByClassName("gNameRoot")[0];
      gNameContainer.style.fontSize = gNameFontSize;
      autoFontSize(gNameContainer, gNameRoot);
    } else {//성별이 없는 경우
      if (!(existElement(element2) && element2.innerText.length > 0)) {//종교도 없는 경우
        //괄호 없앰
        if(existElement(parentheses)){
          for(var i=0; i<parentheses.length; i++){
            parentheses[i].style.display = "inline";
            parentheses[i].style.visibility = "hidden";
          }
        } 
        
      }
      document.getElementsByClassName("space")[0].style.display = "none";
    }
  }
}

function setReligionPosition(gReligionPosition) { //종교 직위
  var element = document.getElementsByClassName("col9")[0];//종교,
  var element2 = document.getElementsByClassName("col8")[0];//성별
  
  var parentheses = document.getElementsByClassName("parentheses");
  if (existElement(element) && gReligionPosition != undefined && gReligionPosition != null && gReligionPosition.length>0){//종교가 있는 경우
    element.innerHTML = gReligionPosition;
  
    if(existElement(parentheses)){
      for(var i=0; i<parentheses.length; i++){
        parentheses[i].style.display = "inline";
        parentheses[i].style.visibility = "visible";
      }
    } else {
      for(var i=0; i<parentheses.length; i++){
        parentheses[i].style.display = "inline";
        parentheses[i].style.visibility = "hidden";
      }
    }

    if (existElement(element2) && element2.innerText.length > 0) {
      document.getElementsByClassName("space")[0].style.display = "initial";
    }

    var gNameContainer = document.getElementsByClassName("gNameContainer")[0], gNameRoot = document.getElementsByClassName("gNameRoot")[0];
    gNameContainer.style.fontSize = gNameFontSize;
    autoFontSize(gNameContainer, gNameRoot);
  } else {//종교가 없는 경우
    element.innerHTML = "";
    
    if (!(existElement(element2) && element2.innerText.length > 0)) {//성별도 없는 경우
      for(var i=0; i<parentheses.length; i++){
        parentheses[i].style.display = "inline";
        parentheses[i].style.visibility = "hidden";
      }   
    } 
    document.getElementsByClassName("space")[0].style.display = "none";//여백 삭제
  }
}

function setRoomName(rName){  //호실
  var element = document.getElementsByClassName("col1")[0];
  if (existElement(element) && rName !== undefined){
	  
    if(rName.indexOf("(") >= 0 && rName.indexOf(")") > 0 && rName.indexOf("(") < rName.indexOf(")")){
        element.innerHTML = rName.substring(0, rName.indexOf("("));
    }else{
        element.innerHTML = rName;
    }
  }
}

function setIpgwanDate(value){  //파라미터 형식 YYYY-MM-DD
  var date = new Date(value);
  var month = date.getMonth()+1, date = date.getDate();
  var ipgwanDate = (month<10 ? "0" + month : month) + "월 " + (date<10 ? "0" + date : date) + "일 ";

  if(isNaN(date)){  //value가 정확하지 않을때
    document.getElementById("ipgwanDate").innerText = "";
  }else{
    document.getElementById("ipgwanDate").innerText = ipgwanDate;
  }
}

function setIpgwanTime(value){  //파라미터 형식 HH:MM
  var ary = value.split(":");
  var ipgwanTime = "";
  if(isNaN(ary[0]) || isNaN(ary[1])){ //value가 정확하지 않을때
    ipgwanTime = "";
  }else{
    var tmp1 = Number(ary[0]), tmp2 = Number(ary[1]);
    var hours = tmp1<10 ? "0" + tmp1 : tmp1, minutes = tmp2<10 ? "0" + tmp2 : tmp2;
    ipgwanTime = hours + "시 " + minutes + "분";
  }

  document.getElementById("ipgwanTime").innerText = ipgwanTime;
}

function setBarinDate(value){ //파라미터 형식 YYYY-MM-DD
  var date = new Date(value);
  var month = date.getMonth()+1, date = date.getDate();
  var barinDate = (month<10 ? "0" + month : month) + "월 " + (date<10 ? "0" + date : date) + "일 ";

  if(isNaN(date)){  //value가 정확하지 않을때
    document.getElementById("barinDate").innerText = "";
  }else{
    document.getElementById("barinDate").innerText = barinDate;
  }
}

function setBarinTime(value){   //파라미터 형식 HH:MM
  var ary = value.split(":");
  var barinTime = "";
  if(isNaN(ary[0]) || isNaN(ary[1])){ //value가 정확하지 않을때
    barinTime = "";
  }else{
    var tmp1 = Number(ary[0]), tmp2 = Number(ary[1]);
    var hours = tmp1<10 ? "0" + tmp1 : tmp1, minutes = tmp2<10 ? "0" + tmp2 : tmp2;
    barinTime = hours + "시 " + minutes + "분";
  }
  document.getElementById("barinTime").innerText = barinTime;
}

function setInfoText(txt){  //정보
  var element = document.getElementById("info_txt");
  if (existElement(element) && txt != undefined && txt != null && txt.length>0){
    element.innerText = txt;
  }
}

/**
여기서부터 모듈 함수
*/

function existElement(element){ //element 존재 여부
	if(typeof(element) != 'undefined' && element != null) {
		return true;
	}else {
		return false;
	}
}

/**
txt : 문자열 , isPath : boolean 타입
txt : 문자열이 존재하고, 길이가 0이상인지 판별.
isPath : 파라미터가 true이면서 첫번째 조건문에서 true를 만족하면 문자열 경로의 끝이 /로 끝나는지 체크.
*/
function checkTextAndPath(txt, isPath){
	if(txt != undefined && txt != null && txt.length>0){
		if(!isPath || (isPath && txt.substr(txt.length-1, txt.length)!="/")){
			return true;
		}
	}
	return false;
}

function changeSpaceUnicode(txt){ //스페이스를 유니코드로 치환.
	return txt.replace(/ /g, "\u00a0");
}

function getSplitLines(lines, lineCnt){ //여러 라인의 문자열을 받아서, lineCnt 갯수의 라인수가 넘으면 자르기.
	if(lines === undefined ||lines === null || lines.length <= 0){
		return "";
	}
	var replaceLines = lines.replace(/\n|\r\n|\r|\<br\/\>/g, '<br>');
	var splitLines = replaceLines.split('<br>');
	if(splitLines.length > lineCnt){
		return splitLines.slice(0, lineCnt).join("<br>");
	}else{
		return replaceLines;
	}
}

/**
element : 텍스트가 들어간 요소.
container : element를 감싸는 크기가 고정된 요소.
자동으로 폰트 사이즈 조절.
*/
function autoFontSize(container, root){
	var loopCnt = 0;
	while(true){
		if($(container).height() <= $(root).height() || loopCnt > LOOP_MAX_CNT){ break; }
		var font = $(container).css('font-size');
		if(font) font = font.substr(0, font.length-2);
		$(container).css('font-size', ((font*1) - 1) + "px");
		loopCnt ++;
	};
}

function applyLineHeight(line){ //1줄이면 250%, 10줄이상이면 130%로 반환.
	if(line > 10) { 
		return 130 + "%"; 
	}
//	else if(line > 4 && line < 7) {
//		return 160 + "%";
//	}
	var X = -5, Y = 180;
	return (line * X + Y).toFixed(3) + "%";
}

function test(){
	setLogo(/*"img/img.jpg"*/"");//로고
	setImage("img/user.jpg");//사진
	setReligion("../religion/etc/d_3.jpg");//종교 백그라운드
	setName("김길동 이길동");//이름
	setGender("1");//성별
	setAge("222");//나이
	setReligionPosition("종교이름 정 베드로");//종교이름
	setJangJi("경기도   ㅁㄴㅇㅁㄴ<br>asdas<br>asdasd<br>asdasd ");//장지
	setSangJu("가가갹:<br/>가나다라:<br/>딸:아들:<br/>딸:아들:<br/>딸:아들:가가갹:<br/>가나다라:<br/>딸:아들:<br/>딸:아들:<br/>딸:아들:");//상주
	setRoomName("102호 (2층)");//방번호
	setIpgwanDate("6-2");//입관날짜
	setIpgwanTime("09:30:00");//입관시간
	setBarinDate("12-31");//발인날짜
	setBarinTime("16:30:00");//발인시간
	setInfoText("정보입니다");
	setAllFont("Nanum Gothic");
}



// 심의보 편집 부분 //
// 2020-08-25  //

//단말기 출력 전용 변수 //
var previewGNameFontSize = 0, previewJangjiFontSize = 0;

// 유가족 영역
$.fn.previewFnBinsoFamily = function(_eventNo, _data, _div) {
	var list = [];
	var str = "";
	$.each(_data, function(idx){
		if(_eventNo == this.EVENT_NO){list.push(this);}
	});
	$.each(list, function(){
		str += this.RELATION;
		if(this.NAMES){
			var _names = this.NAMES.split('^#$%&PB$@!');
			str += " : ";
			$.each(_names, function(idx, _value) {
				str += _value;
				if(_names.length != (idx+1)) str += ", ";	
			});
			str += "\n";
		}else{
			str += "\n";
		}
	})
	previewSetSangJu(str, this, '100px');
} 

//유가족 영역 - 종합 공통
$.fn.previewFnJonghapFamily = function(_data, maxFont) {
	try{
		var rsList = _data.split('!/');
		var str = "";
		$.each(rsList, function(i){
			var lineArr = rsList[i].split('!:');
			if(lineArr[0]!='' && lineArr[1]!=''){
				str += lineArr[0]+" : ";
				str += lineArr[1].replace( /,/gi, ", " );
				str += "\n";	
			}
		});
		previewSetSangJu(str, this, maxFont);
	}catch(e){
	}
}

// 미리보기 화면 //
function previewSetSangJu(beforeTxt, _ , previewSangjuFontSize){  //상주  innerHTML임
	var sangjuTxt = changeSpaceUnicode(getSplitLines(beforeTxt, SANGJU_MAX_CNT));
	var txtArray = sangjuTxt.split('<br>');
	var lineCnt = 0;
	var hasColon = false;
	txtArray.forEach(function(element, index){
	    if(!hasColon && element.indexOf(":") < 0){
	    	txtArray[index] = "<div class='sangJuOrderDiv'><span class='sangJuText'>" + element + "</span></div>";
	    }else{
	    	if(element.indexOf(":")>0){
	    		var _names = "";
	    		var _length = element.substring(element.indexOf(":") + 1).split(',').length;
	    		
	    		$.each(element.substring(element.indexOf(":") + 1).split(','), function(idx, value){
	    			if((idx+1) != _length){
	    				_names += "<div>"+value+",</div>";
	    			}else{
	    				_names += "<div>"+value+"</div>";
	    			}
	    		});
	    		txtArray[index] = "<div class='sangJuOrderDiv'><span class='sangJuOrder'>" + element.substring(0,element.indexOf(":")) +
	    			"<span class='colon'>:</span>&nbsp;</span><span class='sangJuText'>" + _names + "</span></div>";
	    		hasColon = true;
	    	}else{
	    		txtArray[index] = "<div class='sangJuOrderDiv'><span class='sangJuOrder'></span><span class='sangJuText'>" + element + "</span></div>";
	    	}
	    }
	    lineCnt ++;
	});
	sangjuTxt = txtArray.join("");
	
	var element = _ ? _.find('.col3') : document.getElementsByClassName("col3")[0];
	var sangjuContainer = _ ? _.find('.sangjuContainer') : document.getElementsByClassName("sangjuContainer")[0];
	var sangjuRoot = _ ? _ : document.getElementsByClassName("sangjuRoot")[0];
	
	if (existElement(element) && existElement(sangjuContainer) && existElement(sangjuRoot)) {
		$(element).html(sangjuTxt);
		//글자공백 스페이스 2개당 한글자씩 변환
		$.each($(element).find('.sangJuText div'), function(idx, value){
			var _tmp = $(this).text().replace(',', '');
			if(_tmp.replace(/^\s+|\s+$/g, '') == ""){
				var _inTxt = "";
				
				for(var i=0;i<_tmp.length-1;i+=2){
					_inTxt += "아";
				}
				$(this).prev().html($(this).prev().text().replace(',', '&nbsp'));
				$(this).html("&nbsp"+_inTxt+"&nbsp").css('color', 'transparent');
			}
		});
		//sangJu line-height
		
		if(SANGJU_MAX_CNT > 5){ $(element).css("line-height", applyLineHeight(lineCnt)) }
	  	$(sangjuContainer).css("font-size", previewSangjuFontSize);
	  	autoFontSize(sangjuContainer, sangjuRoot);
	}

	/** sangJuOrder 길이 */
	var largestWidth = 0;
	var sangJuOrder = _ ? _.find('.sangJuOrder') : document.getElementsByClassName("sangJuOrder");
	var sangJuText = _ ? _.find('.sangJuText') : document.getElementsByClassName("sangJuText");

	if (existElement(sangJuOrder) && existElement(sangjuContainer) && existElement(sangjuRoot)) {
	    if(sangJuOrder.length>0){
	    	for(var k=0; k<sangJuOrder.length; k++){
	    		if(largestWidth < sangJuOrder[k].offsetWidth) {
	    			largestWidth = sangJuOrder[k].offsetWidth;
	    		}
	    	}
	    	for(var k=0; k<sangJuOrder.length; k++){
	    		sangJuOrder[k].style.width = (largestWidth + 1) + "px";
	    		sangJuText[k].style.width = $(sangjuRoot).width() - (largestWidth + 1) + "px";
	    	}
	    }
	    /** sangJuOrder 길이 */
	    //상주오더때문에 글자 크기 체크 한번더 해야함.
	    autoFontSize(sangjuContainer, sangjuRoot);
	}
}