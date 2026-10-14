<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Chọn Máy Chủ</title>
    <link href="/assets/css/select-server/bootstrap.min.css" rel="stylesheet" />
    <link href="/assets/css/select-server/select-server.css" rel="stylesheet" />
</head>
<body>
    <div class="wrapper d-flex justify-content-center align-items-center">
        <div class="frame">
            <div class="frame-top">
                <div class="frame-top-t">
                    <div class="box d-flex">
                        <div class="info info-l d-flex flex-column">
                            <div class="info-l-title font-weight-bold">
                                Chào mừng Gunner
                            </div>
                            <div class="info-username font-weight-bold">
                                {{$user->Email}}
                            </div>
                            <div class="text-right">
                                <a href="{{route('member-logout')}}" class="btn-exit">Thoát</a>
                            </div>
                            <div class="info-l-footer d-flex">
                                <div class="ml-1">
                                    <a href="{{route('home')}}" class="btn-l-footer">
                                        {{--                                    <i class="fas"></i>--}}
                                        Trang chủ
                                    </a>
                                </div>
                                <div class="ml-1">
                                    <a href="{{route('view-account').'?type=convertCoin'}}" class="btn-l-footer">
                                        {{--                                    <i class="fas"></i>--}}
                                        Chuyển xu
                                    </a>
                                </div>
                                <div class="ml-1">
                                    <a href="{{$config['fanpage_url']}}" class="btn-l-footer">
                                        {{--                                    <i class="fas"></i>--}}
                                        Fanpage
                                    </a>
                                </div>

                            </div>
                        </div>
                    </div>
                    <div class="box box-r-link">
                        <a class="r-link" href="{{$config['launcher_download_url']}}">
                            <img src="/assets/img/banner-launcher.png" />
                        </a>
                    </div>
                </div>
                <div class="frame-top-b">
                    @foreach($serverList as $server)
                        @switch($server->Status)
                            @case(0)
                            <div class="box tb-box">
                                <div>
                                    <img src="/assets/img/select-server/baotri.png" />
                                </div>
                                <div>
                                    <a class="btn-select-server btn-select-server-maintenance" href="#">
                                        {{$server->ServerName}}
                                    </a>
                                </div>
                            </div>
                            @break
                            @case(1)
                            <div class="box tb-box">
                                <div>
                                    <img src="/assets/img/select-server/dongnhat.png" />
                                </div>
                                <div>
                                    <a class="btn-select-server btn-select-server-stable" href="{{route('view-play-game-without-login',['serverId' => $server->ServerID, 'token'=> $keyVerify])}}">
                                        {{$server->ServerName}}
                                    </a>
                                </div>
                            </div>
                            @break
                            @case(2)
                            <div class="box tb-box">
                                <div>
                                    <img src="/assets/img/select-server/comingsoon.png" />
                                </div>
                                <div>
                                    <a class="btn-select-server btn-select-server-coming-soon" href="#">
                                        {{$server->ServerName}}
                                    </a>
                                </div>
                            </div>
                            @break
                        @endswitch
                    @endforeach
                </div>
            </div>
            <div class="frame-bot">
                <div class="box p-3">
                    <div class="box-status mb-2">
                        <div class="status-bt status-bt-maintenance m-2">
                            <span class="status-badge status-maintenance"></span>
                            <span class="status-badge-text">Đang bảo trì</span>
                        </div>
                        <div class="status-bt status-bt-stable m-2">
                            <span class="status-badge status-stable"></span>
                            <span class="status-badge-text">Ổn định</span>
                        </div>
                        <div class="status-bt status-bt-coming-soon m-2">
                            <span class="status-badge status-coming-soon"></span>
                            <span class="status-badge-text">Sắp ra mắt</span>
                        </div>
                    </div>
                    <div class="row m-0 p-0">
                        @foreach($serverList as $server)
                            @switch($server->Status)
                                @case(0)
{{--                                <div class="col-sm-6 col-md-6 p-0">--}}
{{--                                    <div class="row">--}}
                                        <div class="col-6 col-sm-3 p-0 tb-box-bottom">
                                            <a href="#" class="btn-select-server btn-select-server-maintenance">
                                                {{$server->ServerName}}
                                            </a>
                                        </div>
{{--                                    </div>--}}
{{--                                </div>--}}
                                @break
                                @case(1)
{{--                                <div class="col-sm-6 col-md-6 p-0">--}}
{{--                                    <div class="row">--}}
                                        <div class="col-6 col-sm-3 p-0 tb-box-bottom">
                                            <a href="{{route('view-play-game-without-login',['serverId' => $server->ServerID, 'token'=> $keyVerify])}}" class="btn-select-server btn-select-server-stable">
                                                {{$server->ServerName}}
                                            </a>
                                        </div>
{{--                                    </div>--}}
{{--                                </div>--}}
                                @break
                                @case(2)
{{--                                <div class="col-sm-6 col-md-6 p-0">--}}
{{--                                    <div class="row">--}}
                                        <div class="col-6 col-sm-3 p-0 tb-box-bottom">
                                            <a href="#" class="btn-select-server btn-select-server-coming-soon">
                                                {{$server->ServerName}}
                                            </a>
                                        </div>
{{--                                    </div>--}}
{{--                                </div>--}}
                                @break
                            @endswitch
                        @endforeach
                    </div>
                </div>
            </div>
        </div>

        <div class="fly-mid fly-mid-left">
            <img src="/assets/img/select-server/1.png" />
        </div>
        <div class="fly-mid fly-mid-right">
            <img src="/assets/img/select-server/2.png" />
        </div>

        <div class="fly-mid fly-seed">
            <img src="/assets/img/select-server/Mam-Xanh.png" />
        </div>

        <div class="fly-img-t fly-l">
            <img src="/assets/img/select-server/lachuoi.png" />
        </div>

        <div class="fly-img-bt">
            <img src="/assets/img/select-server/mntt.png" />
        </div>

        <div class="fly-img fly-l">
            <img src="/assets/img/select-server/Kien-Xanh.png" />
        </div>
    </div>
    <script src="/assets/js/jquery-3.3.1.min.js"></script>
    <script src="/assets/js/select-server/bootstrap.min.js"></script>
    <script src="/assets/js/select-server/select-server.js"></script>
</body>
</html>
