/**
 * Created by Arijit on 2/11/14.
 */

$(function () {
    $('.candidate').hover(
        function () {
            var $this = $(this);
            var $screen = $this.find('.screen');
            $screen.fadeIn(200);
            $screen.animate({
                marginTop: "-" + $this.height() + "px",
                height: $this.height() + "px"
            }, 200, function () {
                $screen.find('.candidateDetails').fadeIn(100);
            });
        },
        function () {
            var $this = $(this);
            var $screen = $this.find('.screen');
            setTimeout(function () {
                $screen.find('.candidateDetails').fadeOut(10, function () {
                    $screen.animate({
                        marginTop: "0",
                        height: "0"
                    }, 500);
                    $screen.fadeOut();
                });
            }, 200);
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

    });

    $('#shopCancel').on('click', function () {
        $('#shop').hide();
        $('#candidateCanvas').slideDown();
    });

    if (gon.candidate != -1) {
        cast_vote(gon.candidate);
    }
    if (gon.antifirst.length > 0) {
        gon.antifirst.forEach(function (entry) {
            buy_campaign(entry, gon.candfirst);
        });
    }
    if (gon.antisecond.length > 0) {
        gon.antisecond.forEach(function (entry) {
            buy_campaign(entry, gon.candsecond);
        });
    }
    if (gon.antithird.length > 0) {
        gon.antithird.forEach(function (entry) {
            buy_campaign(entry, gon.candthird);
        });
    }


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
                $votedSlot.addClass('slotFilled').addClass('col-lg-offset-3');
                $votedSlot.find('.btn').hide();
                $votedSlot.append('<img src="/assets/voted.png" alt="I voted" class="img-responsive" style="margin-bottom: 0.3em"/><a href="#" class="cancelVote btn btn-xs btn-inverse">Cancel</a>')
                $('#voteStatus').val(true);
                $('.voteBtn').addClass('disabled');
                $votedSlot.fadeIn();
                $votedSlot.find('a.cancelVote').on('click', function () {
                    $this = $(this);
                    $.ajax({
                        url: '/uncast/' + data,
                        method: 'post',
                        success: function (cancelData) {
                            var $canceledSlot = $this.parent();
                            $canceledSlot.fadeOut(function () {
                                $canceledSlot.find('.btn').show();
                                $canceledSlot.find('.cancelSlot').remove();
                                $canceledSlot.find('img').remove();
                                $canceledSlot.find('.cancelVote').remove();
                                $canceledSlot.removeClass('slotFilled').removeClass('col-lg-offset-3');
                                $canceledSlot.fadeIn();
                                $('#voteStatus').val(false);
                                $('.voteBtn').removeClass('disabled');
                                $votedSlot.next().fadeIn();
                            });
                        }
                    });
                });
            });
        }
    })
}

function buy_campaign(campaign, candidate) {
    if (candidate == undefined) {
        candidate = $('#attacked').val();
    }
    $.ajax({
        url: '/buy/' + campaign + '/against/' + candidate,
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
            $selectedSlot.parent().find('.voteBtn').addClass('disabled');
            $('#bank').text(databits[0]);
            $('#shop').hide();
            $('#candidateCanvas').slideDown('fast');
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
                        $canceledSlot.fadeOut(function () {
                            $canceledSlot.find('.btn').show();
                            $canceledSlot.removeClass('slotFilled');
                            $canceledSlot.find('.cancelSlot').remove();
                            $canceledSlot.find('.slottedCampaign').html("").hide();
                            $('#bank').text(cancelData);
                            if ($canceledSlot.parent().find('.slotFilled').length == 0 && !$('#voteStatus').val()) {
                                $canceledSlot.parent().find('.voteBtn').removeClass('disabled');
                            }
                            $canceledSlot.unbind('hover');
                            $canceledSlot.fadeIn();
                        });
                    }
                })
            })
        }
    });
}

