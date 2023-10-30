<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<style>
body { background:#fff;width:100%; height:100%; margin: 0px; overflow:hidden; font-family: NanumSquare_acB; }
.background-wrap {background-color:#fafafa; width:100%; height:100%;}
.status-plate-previews > .previews-box { width:100%; height:100%; }
.top-wrap { width:1920px; height:116px; display: flex; padding: 10px 0px 10px 0px; box-sizing: border-box; }
.middle-wrap { width:100%; height:66.2%; display: flex; position: relative; }
.bottom-wrap { width:100%; height: 15.6%;; display: inline-block; padding-top: 7px; box-sizing: border-box; }
.backgrond-image-wrap { width:100%; height:100%; }
.previews { width:100%; height:100%; }
.blank { width:100%; height:100%; }

.choomo-wrap {  width:100%; height:7.2%; display:flex; padding-top: 6px; box-sizing: border-box; }
.choomo-title { font-size: 47px; width: 13%; height: 100%; display: flex; justify-content: center; align-items: center; padding-right: 36px; box-sizing: border-box; }
.choomo-contents { width: 87%; height: 100%; display: flex; }

.hosil { display:inline-block; width:560px; height:100%; }
.hosil-input { width:100%; font-size: 86px; display: flex; justify-content: center; align-items: center; }
.goin-name { width:1350px; height:100%; }
.goin-name-input { width:100%; font-size: 86px; display: flex; justify-content: center; align-items: center; }
.photo-div { width:29.2%; height:100%; display:inline-block; padding: 0px 6px 0px 4px; box-sizing: border-box; }
.photo { width:100%; height:100%; ertical-align:initial; }
.family { width:70.3%; height:100%; padding: 0px 4px 0px 0px; position: relative; z-index: 99; display: flex; justify-content: center; align-items: center; }
.date-wrap { width:50%; height:100%; display:inline-block; float: left; }
.burial-plot-wrap { width:50%; height:100%; padding: 0px 8px 0px 4px; display: inline-block; box-sizing: border-box; }
.burial-plot-name { text-align:center; width:25%; height:100%; overflow: hidden; font-size: 50px; float:left; box-sizing: border-box; display: flex; justify-content: center; align-items: center; }
.burial-plot { text-align:center; width:75%; height:100%; display: inline-block; overflow: hidden; font-size: 50px; }
.burial-plot .burial-plot-input { height:100%; display: flex; justify-content: center; align-items: center; white-space: pre-wrap; box-sizing: border-box; padding-left: 8px; }

.burial-plot-w { display:table; width:100%; height:100% }
.burial-plot-c { display:table-cell; vertical-align:middle; }
.enter-date-wrap { width:100%; height:52%; box-sizing: border-box; padding-bottom: 8px; display:flex; }
.enter-date-name { width:25.4%; height:100%; font-size: 50px; display: flex; justify-content: center; align-items: center; padding-left: 9px; box-sizing: border-box; }
.enter-date { width:74%; height:100%; font-size: 50px; display: flex; justify-content: center; align-items: center; padding-left: 9px; box-sizing: border-box; }

.carrying-date-wrap { width:100%; height:49%; box-sizing: border-box; display:flex; }
.carrying-date-name { width:25.4%; height:100%; font-size: 50px; display: flex; justify-content: center; align-items: center; padding-left: 9px; box-sizing: border-box; }
.carrying-date { width:74%; height:100%; font-size: 50px; display: flex; justify-content: center; align-items: center; padding-left: 9px; box-sizing: border-box; }
.fam-relation { text-align:center; width:150px; }
.religion { height: 71%; width: 28%; position: absolute; top: 28.7%; left: 71.5%; display: inline-block; content: "";border: 0; z-index: 0; opacity: 0.4; }
.swiper-container { height: 100%; width: 100%; }
.swiper-container .swiper-wrapper { height: 100%; }
.swiper-container .swiper-wrapper .swiper-slide {  }
.swiper-container .swiper-wrapper .swiper-slide img { height: 100%; float: left; padding: 5px; box-sizing: border-box; }
.swiper-container .swiper-wrapper .swiper-slide .comment { color: #FFF; font-size: 50px; height:100%; display: flex; align-items: center; }
.swiper-container .swiper-wrapper .swiper-slide .comment div { width:100%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; } 
</style>
<body>
	<div class="background-wrap">
		<div class="backgrond-image-wrap">
			<div class="previews">
				<!-- 상단 영역 -->
				<div class="top-wrap"> 
					<div class="hosil">
					<div class="hosil-input"></div>
					</div>
					<div class="goin-name">
					<div class="goin-name-input"></div>
					</div>
				</div>
				<!-- 중앙 영역 -->
				<div class="middle-wrap">
					<div class="photo-div">
						<img class="photo">
					</div>
					<img class="religion"></img>
					<div class="family chief-mourner sangjuRoot">
			        	<div class='sangjuContainer'>
			            	<p class="col3"></p>
			        	</div>
					</div>
				</div>
				<!-- 하단 영역 -->
				<div class="bottom-wrap">
					<!-- 날짜 영역 -->
					<div class="date-wrap">
						<div class="enter-date-wrap">
							<div class="enter-date-name">입관</div>
							<div class="enter-date"></div>
						</div>
						<div class="carrying-date-wrap">
							<div class="carrying-date-name">발인</div>
							<div class="carrying-date"></div>
						</div>
					</div>
					<!-- 장지 영역 -->
					<div class="burial-plot-wrap" >
						<div class="burial-plot-name">장지</div>
						<div class="burial-plot"><div class="burial-plot-input"></div></div>
					</div>
				</div>
				<!-- 추모 영역 -->
				<div class="choomo-wrap">
					<div class="choomo-title">추모의 글</div>
					<div class="choomo-contents">
						<div class="condolence swiper-container">
							<div class="swiper-wrapper">
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>

</html>
