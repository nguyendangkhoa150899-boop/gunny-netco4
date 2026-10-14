<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <title>{{$server->ServerName}} - gunny92.com </title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="/assets/game/css/bootstrap.min.css" />
    <link rel="stylesheet" href="/assets/css/fas.css" />
    <link rel="stylesheet" href="/assets/game/css/styles.css?v=20210729014200" />
    <link rel="icon" type="image/png" href="/favicon.png">
    @yield('custom_css')
    <script src="/assets/game/js/bootstrap.min.js"></script>    <script>
        var showLoading = function () {
            $(".overlay-loading").css('display', 'flex').hide().fadeIn();
        }
        var hideLoading = function () {
            $(".overlay-loading").fadeOut();
        }
    </script>
    @yield('custom_js')
</head>
<body>

<div class="page-wrapper chiller-theme toggled">
    <a id="show-sidebar" class="btn btn-sm btn-dark" href="javascript:void(0)">
        <i class="fas fa-bars"></i>

    </a>
    <form name="ctl00" id="ctl00">
        <nav id="sidebar" class="sidebar-wrapper" style="background: rgba(0, 0, 0, 0.61)">
            <div class="sidebar-content">
                <div class="sidebar-brand">
                    <a href="{{route('home')}}" target="_blank" style="color:#ff850a;text-align: center">GunGa</a>
                    <div id="close-sidebar">
                        <i class="far fa-times-circle"></i>
                    </div>
                </div>
                <div class="sidebar-header">
                    <div class="user-info">
                            <span class="user-name">
                                <strong>
                                    <span>{{$member->Email}} </span>
                            </strong>
                            </span>
                        <span class="user-role">
                        <span id="txtCash">Coin: {{number_format($member->Money,0,',','.')}}</span></span>
                        <a href="{{route('member-logout')}}" class="btn-exit">Thoát</a>
                    </div>
                </div>
                <!-- sidebar-header  -->
                <div class="sidebar-search">
                    <div>
                        <div class="input-group">
                            <select name="ListServer" id="ListServer" onchange="selectchange(this)" tabindex="1" class="wrapper-dropdown-5">
                            @foreach($serverList as $server)
                                    @php
                                        $fullPath = Request::path();
                                        $serverID = (int) str_replace('play/','',$fullPath);
                                    @endphp
                                    <option @if($server->ServerID == $serverID) selected  @endif value="{{$server->ServerID}}">{{$server->ServerName}}</option>
                                @endforeach
                            </select>
                        </div>
                        <script language="javascript">
                            function selectchange(obj)
                            {
                                console.log(obj.value);
                                window.location.href = obj.value;
                            }
                        </script>
                    </div>
                </div>
                <!-- sidebar-search  -->
                <div class="sidebar-menu">
                    <ul>
                        <li class="header-menu">
                            <span>Tiện ích</span>
                        </li>
                        <li>
                            <a target="_blank" href="{{route('home')}}">Trang chủ </a>
                        </li>
                        <li>
                            <a target="_blank" href="{{route('view-account')}}">Tài khoản </a>
                        </li>
                        <li>
                            <a target="_blank" href="{{route('view-account').'?type=recharge'}}">Nạp tiền </a>
                        </li>
                        <li>
                            <a target="_blank" href="{{route('view-account').'?type=convertCoin'}}">Chuyển xu </a>
                        </li>
                        <li>
                            <a target="_blank" href="{{$config['fanpage_url']}}">Fanpage </a>
                        </li>
                        <li>
                            <a target="_blank" href="{{$config['group_url']}}">Group </a>
                        </li>
                        <li class="header-menu">
                            <span>Launcher & Trình duyệt</span>
                        </li>
                        <li>
                            <a target="_blank" href="{{$config['launcher_download_url']}}">Tải Launcher</a>
                        </li>
                        <li>
                            <a target="_blank" href="{{$config['uc_download_url']}}">Tải UC</a>
                        </li>
                    </ul>
                </div>
                <!-- sidebar-menu  -->
            </div>
            <!-- sidebar-content  -->
            <div class="sidebar-footer">

                <a>
                    <i>
                        <input type="submit" name="ctl01" id="close-sidebar2" value="Đóng"  class="ButtonClass" style="background-color: #3A3F48; border: none; color: white; text-align: center; text-decoration: none; display: inline-block; font-size: 16px;">
                    </i>
                </a>
            </div>
        </nav>
    </form>
</div>

<div id="play">
    <!--<div class="lachuoi"></div>
    <div class="nv1"></div>
    <div class="nv2"></div>
    <div class="mamxanh"></div>
    <div class="kien"></div>
    <div class="mntt"></div>-->
    <aside id="content">
        <!-- <div class="goc20"></div>
        <div class="goc30"></div>
        <div class="goc50"></div>
        <div class="goc65"></div> -->
        <div class="swf-area" style="
    margin-left: -54px;">
            <script src="/assets/game/js/swfobject.js"></script>
            <script>
                var swfPath = "/flash/Loading.swf";
                var flashvars = {
                    user: "{{$member->Email}}",
                    key: "{{$keyrand}}",
                    v: "104",
                    rand: "92386938",
                    config: "{{$configLink}}"
                };
                var params = {
                    menu: "false",
                    scale: "noScale",
                    //allowFullscreen: "true",
                    allowScriptAccess: "always",
                    //bgcolor: "",
                    wmode: "direct" // can cause issues with FP settings & webcam
                };
                var attributes = {
                    id:"gameContent",
                    name:"Gunny 1",
                    style:"margin: 0 auto;position: relative;display:block !important;"
                };
                swfobject.embedSWF(
                    swfPath,
                    "gameContent", "1000", "600", "11.8.0",
                    "expressInstall.swf",
                    flashvars, params, attributes);
            </script>
            <center><div id="gameContent">
                    <p><a href="{{$config['launcher_download_url']}}"><b>Click vào đây để tải Launcher chơi game.</b></a></p>
                </div></center>
        </div>
    </aside>
</div>

{{--<footer>--}}
{{--    <p>Copyright 2021 &copy; {{$config['website_name']}}</p>--}}
{{--</footer>--}}
<script src="/assets/js/jquery-3.3.1.min.js"></script>
<script>
    $(".sidebar-dropdown > a").click(function() {
        $(".sidebar-submenu").slideUp(200);
        if (
            $(this)
                .parent()
                .hasClass("active")
        ) {
            $(".sidebar-dropdown").removeClass("active");
            $(this)
                .parent()
                .removeClass("active");
        } else {
            $(".sidebar-dropdown").removeClass("active");
            $(this)
                .next(".sidebar-submenu")
                .slideDown(200);
            $(this)
                .parent()
                .addClass("active");
        }
    });

    $("#close-sidebar").click(function() {
        $(".page-wrapper").removeClass("toggled");
    });
    $("#close-sidebar2").click(function() {
        $(".page-wrapper").removeClass("toggled");
    });
    $("#show-sidebar").click(function() {
        $(".page-wrapper").addClass("toggled");
    });
    function loadpage(id){
        if(id==0)
        {
            var link = 'huongdan.php';
        }
        else if(id==1)
        {
            var link = '/doimatkhau1';
        }
        else if(id==2)
        {
            var link = '/doimatkhau2';
        }
        else if(id==3)
        {
            var link = '/quicklogin';
        }
        else if(id==4)
        {
            var link = '/napthecao';
        }
        else if(id==5)
        {
            var link = '/napmomo';
        }
        else if(id==6)
        {
            var link = '/napatm';
        }
        else if(id==7)
        {
            var link = '/napthecao';
        }
        else if(id==8)
        {
            var link = '/giftcode';
        }
        else if(id==9)
        {
            var link = '/trinhduyet';
        }
        else if(id==10)
        {
            var link = '/client';
        }
        else if(id==11)
        {
            var link = '/rename';
        }
        else if(id==12)
        {
            var link = '/banitem';
        }
        else if(id==13)
        {
            var link = '/changeitem';
        }
        else
        {
            var link = 'huongdan.php';
        }

    }
    loadpage(0);
    //init_reload();
    function init_reload(){
        setInterval( function() {
            $.post("/ajax/load-tong-online.php",
                function(result) {
                    $('#online').html(result['tongonline']);
                    $('#txtCash').html(result['cash']);
                    $('#txtXuweb').html(result['xuweb']);
                }, 'json');
        },60000);
    }
    function DangXuat() {
        if (confirm("Bạn có thật sự muốn đăng xuất chứ?", "Thông báo") == true)
            return true;
        else
            return false;
    }

    function DropDown(el) {
        this.dd = el;
        this.initEvents();
    }
    DropDown.prototype = {
        initEvents: function() {
            var obj = this;

            obj.dd.on('click', function(event) {
                $(this).toggleClass('active');
                event.stopPropagation();
            });
        }
    }
    $(function() {

        var dd = new DropDown($('#dd'));

        $(document).click(function() {
            // all dropdowns
            $('.wrapper-dropdown-5').removeClass('active');
        });

    });
</script>
</body>
</html>
