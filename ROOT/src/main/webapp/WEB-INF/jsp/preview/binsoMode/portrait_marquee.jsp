<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<style>
html { transform: rotate(90deg); transform-origin: top right; position: absolute; top: 100%; left: calc(100% - 1080px); width: 100vh; height: 100vw; }
body { background:#fff;width:100%; height:100%; margin: 0px; font-family: NanumSquare_acB; }
.background-wrap {background-color:#fafafa; width:100%; height:100%;}
.status-plate-previews > .previews-box { width:100%; height:100%; }
.top-wrap { width:100%; height:37.3%; display: flex; }
.middle-wrap { width:100%; height:41.2%; display: flex; }
.bottom-wrap { width:100%; height:16.5%; display: flex; justify-content: center; align-items: center; }
.backgrond-image-wrap { width:100%; height:100%; }
.previews { width:100%; height:100%; }
.blank { width:100%; height:100%; }
.choomo-wrap {  width:100%; height:4%; display:flex; }
.choomo-title { width:23.2%; justify-content: center; align-items: center; display: flex; font-size: 47px; padding-right:36px; box-sizing: border-box; }
.choomo-contents { width:76.8%; height:100%; }

.hosil { text-align:center; width:100%; display: flex; justify-content: center; align-items: center;  font-size: 90px; flex:9.6; }
.hosil-input { width:100%;display:flex; justify-content: center; align-items: center; }
.goin-name { text-align:center; width:100%; display: flex; justify-content: center; align-items: center;  font-size: 90px; flex: 24.5; padding: 0px 11px 0px 7px; box-sizing: border-box; }
.goin-name-input { width:100%; display:flex; justify-content: center; align-items: center;  }
.goin-name-box { width: 100%; height: 110px; display: flex; justify-content: center; align-items: center; }
.goin-po-box { width: 100%; height: 110px; display: flex; justify-content: center; align-items: center; }
.goin-po-input { display: inline; }
.goin-age-input { }
.photo-div {  height:100%; display:inline-block; flex: 51.2; }
.photo { width:100%; height:100%;vertical-align:initial; padding: 0px 4px 2px 8px; box-sizing: border-box; }
.name-block { display:flex; flex: 48; height: 100%; flex-direction: column; }

.family { width:99%; height:100%; display:flex; padding: 0px 4px 0px 0px; justify-content: center; align-items:center; z-index: 99; }
.fam-relation { text-align:center; width:150px; }
.religion { height: 28%; width: 42%; position: absolute; top: 50.9%; left: 56%; display: inline-block; content: "";border: 0; z-index: 0; opacity: 0.4; }

.date-wrap { width:100%; height:100%; display:inline-block; padding: 0px 4px 0px 8px; }

.enter-date-wrap { width:100%; height:31.5%; display: flex; }
.enter-date-name { width:22.3%; height:100%; font-size: 50px; display: flex; justify-content: center; align-items: center; }
.enter-date { width:77.7%; height:100%; font-size: 50px; display: flex; justify-content: center; align-items: center; }

.carrying-date-wrap { width:100%; height:31.5%; display: flex; }
.carrying-date-name { width:22.3%; height:100%; font-size: 50px; display: flex; justify-content: center; align-items: center; }
.carrying-date { width:77.7%; height:100%; font-size: 50px; display: flex; justify-content: center; align-items: center; }

.burial-plot-wrap { width:100%; height:31.5%; display: flex; }
.burial-plot-name { width:22.3%; height:100%; font-size: 50px; display: flex; justify-content: center; align-items: center; }
.burial-plot { width:77.7%; height:100%; font-size: 50px; display: flex; justify-content: center; align-items: center; white-space: pre-wrap; }
.burial-plot .burial-plot-input { text-align: center; }

.swiper-container { width : 100%; height: 100%; }
.swiper-container .swiper-wrapper { height: 100%; flex-direction: row; }

.swiper-container .swiper-wrapper .swiper-slide-per { display: flex; justify-content: flex-start; align-items: center; font-size: 50px; animation : text-scroll 70s linear infinite;}
.swiper-container .swiper-wrapper .swiper-slide-per img { height: 100%; padding : 8px; box-sizing: border-box; }
.swiper-container .swiper-wrapper .swiper-slide-per .comment {color: #FFF; height: 100%; padding-top: 8px; box-sizing: content-box; width:calc(100%-80px); white-space: nowrap; }

@keyframes text-scroll{
  from{
    transform:translateX(20%);
    -moz-transform:translateX(20%);
    -webkit-transform:translateX(20%);
    -o-transform:translateX(20%);
    -ms-transform:translateX(20%);
  }
  to{
    transform:translateX(-100%);
    -moz-transform:translateX(-100%);
    -webkit-transform:translateX(-100%);
    -o-transform:translateX(-100%);
    -ms-transform:translateX(-100%);
  }
}

</style>
<body>
	<div class="background-wrap">
		<div class="backgrond-image-wrap">
			<div class="previews">
				<div class="blank" style="height:0.4%;"></div>
				<!-- 상단 영역 -->
				<div class="top-wrap"> 
					<div class="photo-div">
						<img class="photo">
					</div>
					<div class="name-block">
						<div class="hosil">
							<div class="hosil-input"></div>
						</div>
						
						<div class="goin-name">
							<div class="goin-name-box">
								<div class="goin-name-input"></div>
							</div>
							<div class="goin-po-box">
								<div class="goin-po-input"></div>
							</div>
							<div class="goin-age-input"></div>
						</div>						
					</div>
					
				</div>
				<div class="blank" style="height:0.3%;"></div>
				<!-- 중앙 영역 -->
				<div class="middle-wrap">
					<div class="blank" style="width:1%;display:inline-block;"></div>
					<img class="religion"></img>
					<div class="family chief-mourner sangjuRoot">
			        	<div class='sangjuContainer' >
			            	<p class="col3"></p>
			        	</div>
					</div>
				</div>
				<div class="blank" style="height:0.2%;"></div>
				<!-- 하단 영역 -->
				<div class="bottom-wrap">
					<!-- 날짜 영역 -->
					<div class="date-wrap">
						<div class="enter-date-wrap">
							<div class="enter-date-name">입관</div>
							<div class="enter-date"></div>
						</div>
						<div class="blank" style="height:2.5%;"></div>
						<div class="carrying-date-wrap">
							<div class="carrying-date-name">발인</div>
							<div class="carrying-date"></div>
						</div>
						<div class="blank" style="height:2.5%;"></div>
							<!-- 장지 영역 -->
						<div class="burial-plot-wrap" >
							<div class="burial-plot-name">장지</div>
							<div class="burial-plot"><div class="burial-plot-input"></div></div>
						</div>
					</div>
				
				</div>
				<!-- 추모 영역 -->
				<div class="blank" style="height:0.4%;"></div>
				<div class="choomo-wrap">
					<div class="choomo-title">추모의 글</div>
					<div class="choomo-contents">
						<div class="condolence swiper-container">
							<div class="swiper-wrapper">
								
							</div>
						</div>
					</div>
				</div>
				<!-- ./추모 영역 -->
			</div>
		</div>
	</div>
</body>

</html>
