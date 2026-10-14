@extends('client.master')

@section('content')

    <section>

        <div class="banner">
            <img src="/assets/img/ban01.png">
        </div>

        <div class="box list">
            <ul>
                <li class="title">Chọn máy chủ</li>
            </ul>
            <div class="game-content-wrapper container-fluid no-padding">
                <div class="game-server-wrapper" style="margin-top: 15px;">
                    <div class="row">
                        <a class=" animElement just-show" href="{{$config['launcher_download_url']}}"> <img
                                src="https://likegunny.com/assets/img/banner-launcher.png" alt="banner_launcher" border="0" width="100%"> </a>
                        <div class="game-server-wrapper" style="margin-top: 15px;">
                        @foreach($serverList as $server)
                            @switch($server->Status)
                                @case(0)
                                <div class="col-md-6  animElement slide-left">
                                    <div class="game_container">
                                        <div class="frame ddt-game-border">
                                            <a onclick="" href="#">
                                                <img src="/assets/img/baotri.png"><span
                                                    class="top_title"></span>
                                                <div class="game-button game-button-bg ddt-game-border pull-right text-center"
                                                     data-game-server="ddt_s44">
                                                    <div class="game_status  pull-left">
                                                        <div class="status s3"></div>
                                                    </div><span class="server_font">{{$server->ServerName}}</span>
                                                </div>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                @break
                                @case(1)
                                <div class="col-md-6  animElement slide-left">
                                    <div class="game_container">
                                        <div class="frame ddt-game-border">
                                            <a onclick="" href="{{route('view-play-game', $server->ServerID)}}">
                                                <img src="/assets/img/dongnhat.png"><span
                                                    class="top_title"></span>

                                                <div class="game-button game-button-bg ddt-game-border pull-right text-center"
                                                     data-game-server="ddt_s44">
                                                    <div class="game_status  pull-left">
                                                        <div class="status s1"></div>
                                                    </div><span class="server_font">{{$server->ServerName}}</span>
                                                </div>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                @break
                                @case(2)
                                <div class="col-md-6  animElement slide-left">
                                    <div class="game_container">
                                        <div class="frame ddt-game-border">
                                            <a onclick="" href="#">
                                                <img src="/assets/img/comingsoon.png"><span
                                                    class="top_title"></span>

                                                <div class="game-button game-button-bg ddt-game-border pull-right text-center"
                                                     data-game-server="ddt_s44">
                                                    <div class="game_status  pull-left">
                                                        <div class="status s4"></div>
                                                    </div><span class="server_font">{{$server->ServerName}}</span>
                                                </div>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                                @break
                            @endswitch
                        @endforeach
                        <!-- <div class="col-md-6  animElement slide-right">
                                <div class="game_container">
                                    <div class="frame ddt-game-border">
                                        <a onclick="" href="../play/1001">
                                            <img src="/assets/img/dongnhat.png"><span
                                                class="top_title"></span>

                                            <div class="game-button game-button-bg ddt-game-border pull-right text-center"
                                                data-game-server="ddt_s44">
                                                <div class="game_status  pull-left">
                                                    <div class="status s1"></div>
                                                </div><span class="server_font">Gà Vip</span>
                                            </div>
                                        </a>
                                    </div>
                                </div>
                            </div>  -->

                            <div class="col-md-12 animElement zoom-in">
                                <div class="game_container">
                                    <div class="inner-frame ddt-game-border">
                                        <div class="row">
                                            <div class=" margin-center mb-15 mt-15" style="display:table">
                                                <div class=" cl-3 text-center">
                                                    <div class="switch-button text-center margin-center">
                                                        <div class="game_status pull-left">
                                                            <div class="status s1"></div>
                                                        </div><span class="pull-left text-bold">Ổn định</span>
                                                    </div>
                                                </div>
                                                <div class=" cl-3 text-center">
                                                    <div class="switch-button text-center margin-center">
                                                        <div class="game_status pull-left">
                                                            <div class="status s2"></div>
                                                        </div><span class="pull-left text-bold">Quá Tải</span>
                                                    </div>
                                                </div>
                                                <div class="cl-3 text-center">
                                                    <div class="switch-button text-center margin-center">
                                                        <div class="game_status pull-left">
                                                            <div class="status s3"></div>
                                                        </div><span class="pull-left text-bold">Bảo Trì</span>
                                                    </div>
                                                </div>
                                                <div class=" cl-3  text-center">
                                                    <div class="switch-button text-center margin-center">
                                                        <div class="game_status pull-left">
                                                            <div class="status s4"></div>
                                                        </div><span class="pull-left text-bold">Sắp ra mắt</span>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="cl-12 text-center ">
                                                @foreach($serverList as $server)
                                                    @switch($server->Status)
                                                        @case(0)
                                                        <div class="col-md-3 mb-10">
                                                            <div class="game-button ddt-game-border margin-center text-center "
                                                                 data-game-server="ddt_s45">
                                                                <div class="game_status  pull-left">
                                                                    <div class="status s3"></div>
                                                                </div><span class="server_font"><a onclick="" href="#">{{$server->ServerName}}</a></span>
                                                            </div>
                                                        </div>
                                                        @break
                                                        @case(1)
                                                        <div class="col-md-3 mb-10">
                                                            <div class="game-button ddt-game-border margin-center text-center "
                                                                 data-game-server="ddt_s45">
                                                                <div class="game_status  pull-left">
                                                                    <div class="status s1"></div>
                                                                </div><span class="server_font"><a onclick="" href="{{route('view-play-game', $server->ServerID)}}">{{$server->ServerName}}</a></span>
                                                            </div>
                                                        </div>
                                                        @break
                                                        @case(2)
                                                        <div class="col-md-3 mb-10">
                                                            <div class="game-button ddt-game-border margin-center text-center "
                                                                 data-game-server="ddt_s45">
                                                                <div class="game_status  pull-left">
                                                                    <div class="status s4"></div>
                                                                </div><span class="server_font"><a onclick="" href="#">{{$server->ServerName}}</a></span>
                                                            </div>
                                                        </div>
                                                        @break
                                                    @endswitch
                                                @endforeach
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </section>
@endsection


