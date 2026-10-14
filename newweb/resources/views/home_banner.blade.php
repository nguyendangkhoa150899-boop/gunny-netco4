<aside id="banner">
    <div class="content-container">
        <div class="khung">
            <div class="top">
                <div class="tai-client">
                    <img src="/images/taiclient.png" />
                </div>
                <div class="tai-web">
                    <img src="/images/taiweb.png" />
                </div>
                <a href="/" class="logo"><img src="/images/Final-Logo.png" width="489" height="190"/></a>
            </div>
            <div class="bottom">
                <div class="slider-container">
                    <div class="slide">
                        <div class="item">
                            <img src="/images/slide1.png" alt="slide1">
                        </div>
                    </div>
                    <div class="slide">
                        <div class="item">
                            <img src="/images/slide2.jpg" alt="slide2">
                        </div>
                    </div>
                    <div class="slide">
                        <div class="item">
                            <img src="/images/slide3.jpg" alt="slide3">
                        </div>
                    </div>
                </div>
                <div class="khungslide">
                </div>
            </div>
            <div class="slidebuttons">
                <div class="slidebutton" data-id="1">
                    <div class="number1">&nbsp;</div>
                </div>
                <div class="slidebutton" data-id="2">
                    <div class="number2">&nbsp;</div>
                </div>
                <div class="slidebutton" data-id="3">
                    <div class="number3">&nbsp;</div>
                </div>
{{--                <div class="slidebutton" data-id="4">--}}
{{--                    <div class="number4">&nbsp;</div>--}}
{{--                </div>--}}
            </div>
        </div>
    </div>
    <div class="line"></div>
</aside>
<script>
	$(document).ready(function() {
		$(".tai-client").click(function () {
			window.location.href = "/GoGunLauncher.rar";
		});
		$(".tai-web").click(function () {
			window.location.href = "/WEB.exe";
		});
	});
    $(document).ready(function() {
        var current_slider = 1;
        var number_of_slider = $(".slider-container .slide").length;
        var width = $(".slider-container").width();
        var slidebuttonHighlight = function () {
            $(".slidebutton").removeClass('active');
            $(".slidebutton:nth-child("+current_slider+")").addClass('active');
        }
        slidebuttonHighlight();
        var slide = function () {
            current_slider++;
            if (current_slider > number_of_slider) {
                $(".slider-container .slide").animate({'left': 0});
                current_slider = 1;
                slidebuttonHighlight();
                return;
            }
            $(".slider-container .slide").animate({'left': -width*(current_slider-1)});
            slidebuttonHighlight();
        }
        setInterval(function () {
            slide();
        }, 4000);
        $(".slidebutton").click(function() {
            var slidestt = $(this).data('id');
            current_slider = slidestt - 1;
            slide();
        });
    });
</script>
