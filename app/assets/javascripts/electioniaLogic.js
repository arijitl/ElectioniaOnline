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
            },200);
        }
    );

    $('.buy').on('click',function(){
        $('#attackedName').text($(this).parent().parent().find('.candidateName').text());
        $('#attacked').val($(this).parent().parent().find('.candidateName').text());
        $('#candidateCanvas').hide();
        $('#shop').slideDown();
        var owl = $("#shopShelf");

        owl.owlCarousel({
            items : 4, //10 items above 1000px browser width
            itemsDesktop : [1000,4], //5 items between 1000px and 901px
            itemsDesktopSmall : [900,3], // betweem 900px and 601px
            itemsTablet: [600,2], //2 items between 600 and 0
            itemsMobile : false, // itemsMobile disabled - inherit from itemsTablet option
            autoHeight: false
        });

    })

    $('#shopCancel').on('click',function(){
        $('#shop').hide();
        $('#candidateCanvas').slideDown();
    })


});

