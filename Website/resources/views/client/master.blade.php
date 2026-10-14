<!DOCTYPE html>
<html lang="vi">
@include('client.header')
<link href="{{ asset('css/app.css') }}" rel="stylesheet">
<body>
<!-- Your customer chat code -->
<!-- Load Facebook SDK for JavaScript -->
<div id="fb-root"></div>
<!-- Load Facebook SDK for JavaScript -->

<script>
    window.fbAsyncInit = function() {
        FB.init({
            xfbml            : true,
            version          : 'v8.0'
        });
    };

    (function(d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) return;
        js = d.createElement(s); js.id = id;
        js.src = 'https://connect.facebook.net/vi_VN/sdk/xfbml.customerchat.js';
        fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));
</script>

<!-- Your Chat Plugin code -->
<div class="fb-customerchat" page_id="{{$config['fanpage_id']}}"></div>

<script>
    // khai bao ham global
    var max_loading_gif_count = 10;

    var full_url = env("APP_URL", "");

    var isAdsDisplayed = true;


</script>
<script src="/assets/js/functionuncrypt.js"></script>
<script>
    function getCookieW(cname) {
        var name = cname + "=";
        var ca = document.cookie.split(';');
        for (var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') {
                c = c.substring(1);
            }
            if (c.indexOf(name) == 0) {
                return c.substring(name.length, c.length);
            }
        }
        return "";
    };
</script>

<a id="modalCedrusAllIndex" class="right animElement just-show" href="#" data-toggle="modal" data-target="#modalCedrus"></a>

<div class="modal" id="modalCedrus" role="dialog">
    <div class="content">
        <div id="modal-title-cedrus" class="title" style="color:red;">Title</div>
        <div class="box">

            <div id="modal-body-cedrus"><span id="statusposttxt" style="color: red;font-size:x-large;">Content</span>
            </div>

        </div>
    </div>
    <div class="close">
        <span></span>
    </div>
</div>


<div class="outer">
    <div style="display:none" id="sbbhscc"></div>
    <script type="text/javascript">
        var sbbvscc = '';
        var sbbgscc = '';

        function genPid() {
            return String.fromCharCode(118) + String.fromCharCode(98);
        };
    </script>

    <header>

        <style>
            #bgvid {
                position: absolute;
                top: -77px;
                left: -47px;
                object-fit: cover;
            }

            @media (max-width:1025px) {
                .section__iframe iframe {
                    pointer-events: all;
                }
            }

            .container {
                display: block;
                margin: 0 auto;
            }

            hr.split {
                margin: 0;
                border: 0;
                background: transparent;
            }

            .clearfix:after {
                content: "";
                clear: both;
                display: table;
            }

            .desktop {
                display: flex;
            }

            .mobile {
                display: none;
            }

            @media (max-width:1025px) {
                .desktop {
                    display: none;
                }

                .mobile {
                    display: flex;
                }
            }

            @media (max-width:700px) {
                .desktop {
                    display: none;
                }

                .mobile {
                    display: flex;
                }
            }
        </style>

        <!-- Navbar -->
        @include('client.popup')
        @include('client.nav')
    </header>
    <main>
        @include('client.related.master-info')
        @include('client.related.cadpa')

        <div class="container">
            <aside class='page-master-menu'>
                <style>
                    .clearfix::after {
                        content: "";
                        display: block;
                        clear: both;
                    }
                </style>
                <!-- Login Frm -->
                @if(Request::path() == 'login-puffin')
                    @include('client.related.login-form-puffin')
                @else
                    @include('client.related.login-form')
                @endif

                @include('client.related.master-menu-bar')

                @include('client.related.server-list')

                @include('client.related.ranked')

                @include('client.related.master-menu-webside')

                <div class="widget menu-section-fanpage">
                    <h3>Fanpage</h3>
                    <center>
                        <iframe
                            src="https://www.facebook.com/plugins/page.php?href={{ $config['fanpage_config'] }}&amp;tabs=timeline&amp;width=298&amp;height=500&amp;small_header=false&amp;adapt_container_width=true&amp;hide_cover=false&amp;show_facepile=false&amp;appId"
                            width="298" height="500" style="border:none;overflow:hidden" scrolling="no" frameborder="0"
                            allowfullscreen="true"
                            allow="autoplay; clipboard-write; encrypted-media; picture-in-picture; web-share"></iframe>
                    </center>
                </div>
            </aside>

            <!-- Page Content -->
            <section class='main-content'>

                @yield('content')

            </section>

        </div>
    </main>
</div>

<footer>
    <div class="container">
        <span class="text animElement zoom-in">
            Copyright © {{$config['website_name']}} - All rights reserved </span>
    </div>
</footer>

{{--@include('client.footer')--}}

<script src="assets/js/self.js"></script>
<script src="assets/js/slide.js"></script>

<script type="text/javascript">
    function reloadCaptcha(elId = null){
        if (elId == null) {
            elId = 'captcha_img_src';
        }
        $.ajax({
            url: "{{route('ajax-get-captcha-html')}}",
            type: "GET",
            dateType: "text",
            success: function(t) {
                $("#"+elId).attr("src", t);
            },
            error: function (t){
                console.log("ERROR WHILE RECREATE CAPTCHA");
            }
        });
    }
</script>
@stack('js')

</body>

</html>
