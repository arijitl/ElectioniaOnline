/**
 * Created by Arijit on 2/11/14.
 */

var which_story;
$(function () {

    console.log("gon.voted_yesterday :- " + gon.voted_yesterday);
    if (gon.voted_yesterday=="false"){
        $('.well').hide();
        $('#home').fadeIn();
    }
    else{
        $('.well').hide();
        $('#yesterday').fadeIn();
    }

    $('.candidate').hover(
        function () {
            var $this = $(this);
            var $screen = $this.find('.screen');
            $screen.css({
                height: $this.height() + "px"
            });
            $screen.fadeIn(200);
        },
        function () {
            $(this).find('.screen').fadeOut();
        }
    );

    $('.buy').on('click', function () {
        $('#attackedName').text($(this).parent().parent().find('.candidateName').text());
        $('#attacked').val($(this).parent().parent().find('.candidateName').attr('id').split('candidateNo')[1]);
        $('#selectedSlot').val($(this).parent().attr("id"));
        $('#candidateCanvas').hide();
        $('#shop').slideDown();
        var owl = $("#shopShelf");

        owl.owlCarousel({
            items: 3, //10 items above 1000px browser width
            itemsDesktop: [1000, 3], //5 items between 1000px and 901px
            itemsDesktopSmall: [900, 3], // betweem 900px and 601px
            itemsTablet: [600, 2], //2 items between 600 and 0
            itemsMobile: false, // itemsMobile disabled - inherit from itemsTablet option
            autoHeight: false
        });

        $(".next").click(function () {
            owl.trigger('owl.next');
        });
        $(".prev").click(function () {
            owl.trigger('owl.prev');
        });

        $('#shopShelf .item').each(function (index, entry) {
            var itemCost = parseInt($(entry).find('a').first().text().split("R.")[1]);
            if (parseInt($('#bank').text()) < itemCost) {
                $(entry).css('opacity', '0.5');
                $(entry).find('a').addClass('disabled');
                $(entry).find('h5').html("Cannot afford this");
            } else {
                $(entry).css('opacity', '1');
                $(entry).find('a').removeClass('disabled')
                $(entry).find('h5').html('R.' + itemCost * 1.5 + ' if the candidate loses');
            }
        });

    });

    $('#shopCancel').on('click', function () {
        $('#shop').hide();
        $('#candidateCanvas').slideDown();
    });

//    Results Section

    var resultsOwl = $("#resultsBrowser");
    resultsOwl.owlCarousel({
        pagination: false,
        rewindNav: false,
        singleItem: true
    });
    resultsOwl.data('owlCarousel').goTo(resultsOwl.find('.item').length);

    $(".nextResult").click(function () {
        resultsOwl.trigger('owl.next');
    });
    $(".prevResult").click(function () {
        resultsOwl.trigger('owl.prev');
    });

//    --------------------------

    if (gon.candidate != -1) {
        cast_vote(gon.candidate);
    }
    gon.anticampaigns.forEach(function (entry) {
        if (entry[1].length > 0) {
            entry[1].forEach(function (elm) {
                buy_campaign("true", elm, entry[0]);
            });
        }
    });

    setTimeout(function () {
        if (gon.submitted == 'true') {
            $('#candidateCanvas').find('.btn').addClass('disabled');
            $('.btn-submit').hide();
            $('.btn-reEdit').css('display', 'block').removeClass('disabled').fadeIn();
        }
        $('#candidateCanvas').hide();
        if (gon.voted_yesterday=="true"){
            $('#yesterday').fadeIn();
        }else{
            $('#home').fadeIn();
        }
        $('#contentPanel').animate({opacity: 1});
    }, 1000);


    $('.datatable').dataTable({
        "sPaginationType": "bootstrap",
        "aaSorting": [
            [ 2, "desc" ]
        ],
        "iDisplayLength": 5,
        sDom: 'ft'
    });


});

function find_empty_slot(candidate) {
    var letter;
    if ($('#slot' + candidate + 'a').hasClass('slotFilled') && $('#slot' + candidate + 'b').hasClass('slotFilled')) {
        letter = 'n'
    } else {
        if ($('#slot' + candidate + 'a').hasClass('slotFilled')) {
            letter = 'b';
        } else {
            letter = 'a';
        }
    }
    return letter;
}

function cast_vote(candidate) {
    $.ajax({
        url: '/vote/' + candidate,
        method: 'post',
        success: function (data) {
            var $votedSlot = $('#slot' + candidate + 'a');
            $votedSlot.next().fadeOut();
            $votedSlot.fadeOut(function () {
                $votedSlot.addClass('slotFilled').removeClass('col-lg-6').addClass('col-lg-12');
                $votedSlot.find('.btn').hide();
                $votedSlot.append('<img src="/assets/voted.png" alt="I voted" class="img-responsive" style="margin-bottom: 0.3em"/><a href="#" class="cancelVote btn btn-success">Cancel my Vote</a>')
                $('#voteStatus').val(true);
                $('.voteBtn').hide();
                $votedSlot.fadeIn();
                $('.cardSlot').css({
                    height: '8em'
                });
                $('.btn-submit').removeClass('disabled').text("Click here to Submit");
                $votedSlot.find('a.cancelVote').on('click', function () {
                    $this = $(this);
                    $.ajax({
                        url: '/uncast/' + data,
                        method: 'post',
                        success: function (cancelData) {
                            var $canceledSlot = $this.parent();
                            $('.btn-submit').addClass('disabled').text("Cast your Vote to Submit");
                            $canceledSlot.fadeOut(function () {
                                $canceledSlot.find('.btn').show();
                                $canceledSlot.find('.cancelSlot').remove();
                                $canceledSlot.find('img').remove();
                                $canceledSlot.find('.cancelVote').remove();
                                $canceledSlot.removeClass('slotFilled').removeClass('col-lg-12').addClass('col-lg-6');
                                $('.votable').next().css({
                                    height: '100%'
                                });
                                $('.votable').next().next().css({
                                    height: '100%'
                                });
                                $canceledSlot.fadeIn();
                                $('#voteStatus').val(false);
                                $('.voteBtn.votable').fadeIn();
                                $votedSlot.next().fadeIn();
                            });
                        }
                    });
                });
            });
            which_story = "vote";
            //get_fb_login_status();
        }
    })
}

function buy_campaign(init, campaign, candidate) {
    if (candidate == undefined) {
        candidate = $('#attacked').val();
    }
    $.ajax({
        url: '/buy/' + campaign + '/against/' + candidate + '/' + init,
        method: 'post',
        success: function (data) {
            var databits = data.split("||");
            var $selectedSlot;
            if ($('#selectedSlot').val() != "") {
                $selectedSlot = $("#" + $('#selectedSlot').val());
            } else {
                $selectedSlot = $('#slot' + candidate + find_empty_slot(candidate));
            }
            $selectedSlot.addClass('slotFilled');
            $selectedSlot.parent().find('.cardSlot').css({
                height: '8em'
            });
            $selectedSlot.parent().find('.voteBtn').removeClass('votable').hide();
            $('#bank').text(databits[0]);
            $('#shop').hide();
            if (init=='false'){
                $('#candidateCanvas').slideDown('fast');
            }
            var $campaignBlock = $selectedSlot.find('.slottedCampaign');
            $campaignBlock.html($("#campaign" + campaign).html()).fadeIn();
            $selectedSlot.find('.btn').hide();
            $selectedSlot.find('.rollover .btn').show();

            $selectedSlot.hover(
                function () {
                    var $screen = $(this).find('.rollover');
                    $screen.fadeIn(200);
                },
                function () {
                    $(this).find('.rollover').fadeOut(100);
                }
            );


            $selectedSlot.find('a.cancelSlot').on('click', function () {
                $this = $(this);
                $.ajax({
                    url: '/cancel/' + databits[1],
                    method: 'post',
                    success: function (cancelData) {
                        var $canceledSlot = $this.parent().parent().parent();
                        var $voteBtn = $canceledSlot.parent().find('.voteBtn');
                        $canceledSlot.fadeOut(function () {
                            $canceledSlot.find('.btn').show();
                            $canceledSlot.removeClass('slotFilled');
                            $canceledSlot.find('.cancelSlot').remove();
                            $canceledSlot.find('.slottedCampaign').html("").hide();
                            $('#bank').text(cancelData);
                            if ($canceledSlot.parent().find('.slotFilled').length == 0) {
                                $voteBtn.addClass('votable');
                                if ($('#voteStatus').val() == 'false') {
                                    $voteBtn.show();
                                    $selectedSlot.parent().find('.cardSlot').css({
                                        height: '100%'
                                    });
                                }
                            }
                            $canceledSlot.unbind('hover');
                            $canceledSlot.fadeIn();
                        });
                    }
                })
            });
            which_story = "campaign";
            //get_fb_login_status();
        }
    });
}

function submitAll() {
    $('#candidateCanvas').find('.btn').addClass('disabled');
    $('.btn-submit').hide();
    $('.btn-reEdit').css('display', 'block').removeClass('disabled').fadeIn();
    $.ajax({
        url: "/finalize/true",
        method: "post",
        success: function (data) {
            console.log(data)
        }
    })
}

function reEdit() {
    $('#candidateCanvas').find('.btn').removeClass('disabled');
    if (gon.candidate == '-1') {
        $('.btn-submit').addClass('disabled');
    }
    $('.btn-reEdit').hide();
    $('.btn-submit').fadeIn();
    $.ajax({
        url: "/finalize/false",
        method: "post"
    })
}


//TODO: write only one function to post vote/campaign activity, just pass vote/campaign details as arg
function post_vote_activity_on_fb(user_hash){

    FB.api(
        user_hash.userID+'/electionia:vote',
        'post', {
            candidate: "http://samples.ogp.me/419699874799046"
        }, function(response) {
            // handle the response
            console.log(response);
        }
    );

}

function post_campaign_activity_on_fb(user_hash){

    FB.api(
        user_hash.userID+'/electionia:campaign',
        'post',
        {
            candidate: "http://samples.ogp.me/419699874799046"
        },
        function(response) {
            // handle the response
            console.log(response);
        }
    );

}

function get_fb_login_status(){
    //var at = '';
//    FB.getLoginStatus(function (response) {
//        console.log("response.status :- " + response.status);
//        if (response.status == "connected") {
//            at = response.authResponse.accessToken;
//            console.log("at :- " + at);
//            post_vote_activity_on_fb(response.authResponse)
//        }
//
//    });

    //console.log(which_story);

    FB.login(function(response) {
        if (response.authResponse) {
            console.log(response.authResponse);
            if ( which_story == "vote" ) {
                post_vote_activity_on_fb(response.authResponse);
            }
            else if ( which_story == "campaign" ) {
                post_campaign_activity_on_fb(response.authResponse);
            }

        } else {
            // cancelled
        }
    });
}

function FacebookInviteFriends(){
    FB.ui({ method: 'apprequests',
        message: 'Invite friends...'});
}

function post_photo_on_fb(curr_usr, score){
    var wallPost = {
        message : curr_usr+" scored "+score,
        picture: "http://1.bp.blogspot.com/-l8t6U5iV9Kw/UAhFb9dlktI/AAAAAAAAAKs/mftBOkZgXRY/s1600/Sachin-Tendulkar.jpg"
    };
    FB.api('/me/feed', 'post', wallPost , function(response) {
        if (!response || response.error) {
            console.log('Error occured');
        } else {
            console.log('Post ID: ' + response);
        }
    });
}

function share_score(curr_usr, score){
    var curr_usr_rank;
    $("#leaderboard").find("td").each(function() {
        if ($(this).text() == curr_usr ){
            curr_usr_rank = $(this).prev().text();
            //console.log(curr_usr, curr_usr_rank);
        }
    });

    FB.ui(
        {
            method: 'feed',
            name: 'I am rank '+curr_usr_rank+ ' on Electionia',
            link: 'https://developers.facebook.com/docs/dialogs/',
            picture: 'http://fbrell.com/f8.jpg',
            caption: 'I have earned R.' +score+ ' by playing this online voting game.',
            description: 'Check the game out. Vote for the candidate you like, throw a shoe at a candidate you don\'t and make it to the Leader Board to win exciting prizes. Just remember - Every Vote Counts!'
        },
        function(response) {
            if (response && response.post_id) {
                console.log('Post was published.');
            } else {
                console.log('Post was not published.');
            }
        }
    );
}

function share_result(curr_usr, score){
    $.ajax({
        url: '/my_result',
        method: 'post',
        success: function (data) {

            var balance = data.split("||")[0];
            var contribution = data.split("||")[1];
            var expense = data.split("||")[2];
            var income = data.split("||")[3];
            var votewin = data.split("||")[4];
            var politician = data.split("||")[5];

            //console.log(balance, contribution, expense, income, votewin, politician);

            FB.ui(
                {
                    method: 'feed',
                    name: 'I won R.'+income+' by playing Electionia yesterday',
                    link: 'https://developers.facebook.com/docs/dialogs/',
                    picture: 'http://fbrell.com/f8.jpg',
                    caption: politician+' won yesterday\'s round of voting',
                    description: 'Check the game out. Vote for the candidate you like, throw a shoe at a candidate you don\'t and make it to the Leader Board to win exciting prizes. Just remember - Every Vote Counts!'
                },
                function(response) {
                    if (response && response.post_id) {
                        console.log('Post was published.');
                    } else {
                        console.log('Post was not published.');
                    }
                }
            );
        }
    })

}