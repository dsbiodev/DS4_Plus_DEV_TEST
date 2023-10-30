/**
 * File : pb-community.js
 * Explanation : 커뮤니티 script
 */

// 내용 '더 보기' 컨트롤
$.fn.contentsMoreView = function() {
	$(this).off().on('click', function() {
		$(this).parent('.more-wrap').hide().prev('.contents-area').css('height', 'auto');
	});
};

//댓글 리스트
var refreshComment = function(_communityNo, _target, _flag) {
	var _commentSearchObj = { 
		communityNo:_communityNo, 
		order:'COMMENT_NO DESC', 
		queryPage:(_flag == 'insert' ? 0:(_flag == 'layer' ? null:_target.data('page'))), 
		display:(_flag == 'insert' ? 1:(_flag == 'layer' ? null:_target.data('display')))
	};
	
	$.pb.ajaxCallHandler('/admin/selectCommunityCommentList.do', _commentSearchObj, function(moreData) {
		if(_target.parents('.community-box').find('.lnc-area > .comment').length) {
			_target.parents('.community-box').find('.lnc-area > .comment').html('댓글 '+moreData.total+'개');
		} else _target.parents('.contents-viewer').find('.lnc-area > .comment').html('댓글 '+moreData.total+'개');
		// 댓글 삭제 및 수정만들어야함
			
		$.each(moreData.list, function() {
			var _comment = $('<div class="comment-box">');
			_comment.append('<img src="'+(this.PROFILE_IMG ? this.PROFILE_IMG:'/resources/playbench/images/basic_profile_img.png')+'" class="profile-image-circle comment"/>');
			_comment.append('<div class="text"><span class="user">'+this.NAME+'</span>'+this.COMMENT+'</div>');
			_comment.append('<div class="time">'+$.pb.returnTimeDiff(this.CREATE_DT)+'</div>');
			
			if(_target.siblings('.comment-box').length && !_flag) _target.siblings('.comment-box:eq(0)').before(_comment);
			else if(_flag == 'insert') {
				if(_target.siblings('.comment-list').length) _target.siblings('.comment-list').find('.more').before(_comment);
				else {
					_target.parents('.contents-viewer').find('.comment-list').append(_comment).show();
					_target.parents('.contents-viewer').find('.scroll-box').scrollTop(9999);
				}
			} else if(_flag == 'layer') _target.prepend(_comment);
			else _target.parent().prepend(_comment);
		});
		
		if(_flag == 'insert') {
			var tm = _target.siblings('.comment-list').find('.more');
			tm.data('page', tm.data('page')+1).data('display', 5).show().parent('.comment-list').show();
		} else if(moreData.list.length) {
			_target.data('page', _target.data('page')+_target.data('display')).data('display', 5).show().parents('.comment-list').show();
		} else _target.hide();
	});
};

// 글쓰기, 수정 시 이미지 박스 컨트롤
var crtImageBox = function(_url, _imagesNo) {
	var _addImageBox = $('<div>');
	_addImageBox.addClass('attach-image');
	_addImageBox.css('background-image', 'url('+_url+')').attr('data-no', (_imagesNo ? _imagesNo:'')).html('<div class="del">이미지삭제</div>');
	_addImageBox.on('mouseenter', function(e) { $(this).find('.del').show(); });
	_addImageBox.on('mouseleave', function(e) { $(this).find('.del').hide(); });
	_addImageBox.find('.del').on('click', function(e) {
		if(_imagesNo) {
			$.pb.ajaxCallHandler('/admin/deleteImages.do', { category:1, imagesNo:_imagesNo }, function(result) {
				
			});
		} else fileList.splice($(this).parent('.attach-image').index(), 1);
		$(this).parent('.attach-image').remove();
	});
	
	return _addImageBox;
};

$.fn.viewerSetting = function(_data) {
	var _ = $(this);
	var _viewerImg = _.find('.viewer-image');
	var _imagesSplit = _data.IMAGE_PATH ? _data.IMAGE_PATH.split(','):null;
	
	_.find('.overlay > .title').html(_data.NAME+'님의 이미지');
	_.css('top', $(window)[0].scrollY ? $(window)[0].scrollY:document.body.parentNode.scrollTop+'px');
	
	_.off().on('click', function(e){
		if($(e.target).hasClass('community-viewer-wrap')) {
			$('body').css('overflow', 'auto');
			$(this).hide();
		}
	});
	
	// Next, Prev Controll
	_.find('.overlay .prev, .overlay .next').off().on('click', function() {
		var _imgIdx = _imagesSplit.indexOf(_viewerImg.attr('src'));
		var _targetImgIdx = null;
		
		if(-1 < _imgIdx && 1 < _imagesSplit.length) {
			if($(this).hasClass('prev')) {
				_targetImgIdx = _imgIdx-1 < 0 ? _imagesSplit.length-1:_imgIdx-1;
			} else if($(this).hasClass('next')) {
				_targetImgIdx = _imgIdx+1 < _imagesSplit.length ? _imgIdx+1:0;
			}
		} else console.log('No images in array');
		
		if(_targetImgIdx != null) {
			_viewerImg.attr('src', _imagesSplit[_targetImgIdx]);
		}
	});
};

$.fn.communityAddComment = function(_data, _userNo) {
	var _ = $(this);
	_.on('keyup', function(e) {
		if(_.val() && e.keyCode == 13) {
			_.attr('disabled', true);
			$.pb.ajaxCallHandler('/admin/insertCommunityComment.do', { communityNo:_data.COMMUNITY_NO, userNo:_userNo, comment:_.val() }, function(result) {
				if(result == 1) {
					refreshComment(_data.COMMUNITY_NO, _, 'insert');
					_.attr('disabled', false).val('');
				}
			});
		}
	});
};

$.fn.communityLike = function(_data, _userNo, done) {
	var _ =  $(this);
	
	_.off().on('click', function() {
		$.pb.ajaxCallHandler('/admin/'+(_.hasClass('ac') ? 'delete':'insert')+'CommunityLink.do', { communityNo:_data.COMMUNITY_NO, userNo:_userNo, flag:1 }, function(insertResult) {
			$.pb.ajaxCallHandler('/admin/selectCommunityLinkList.do', { communityNo:_data.COMMUNITY_NO, flag:1 }, function(likeResult) {
				_.html('좋아요 '+likeResult.total+'개');
				if(_.hasClass('ac')) _.removeClass('ac');
				else _.addClass('ac');
				
				if(done) done();
			});
		});
	}).addClass(_data.USER_LIKE_FLAG ? 'ac':'');
};