
    <div class="box mid section-display-newfeed">
        <div class="render01"></div>
        <div class="tabsAnchor">
            <a href="#All" id="all-news" class="newshome active">TẤT CẢ</a>
            <a href="#Announces" id="announ-news" class="newshome">THÔNG BÁO</a>
            <a href="#News" id="new-news" class="newshome">TIN TỨC</a>
            <a href="#Events" id="event-news" class="newshome">SỰ KIỆN</a>
        </div>
        <div class="tabsContent animElement zoom-in time-300 in-view">
            <div id="tabAll" class="active" style="display: inline-block;">
                <ul class="listtag" id="news2"></ul>
                <div id="loadingnews" style="display: none">
                    <img src="/assets/img/loader.gif">
                </div>

            </div>

            <a href="javascript:void(0);" id="loadMore" class="seeall">Xem thêm...</a>
        </div>
    </div>
    <div class="cards animElement slide-bottom time-300 in-view">
        <a href="https://download.com.vn/download/uc-browser-87467" target="_BLANK" class="right">
            <img src="/assets/img/taigame-10.png">
        </a>
        <a href="https://drive.google.com/drive/folders/1BQ-HdgVYIZ6suIWhVKsYRcOnMq0WM11p?usp=sharing" class="right" download="">
            <img src="/assets/img/taigame-09.png">
        </a>
    </div>

@push('js')
    <script type="text/javascript">
        $( document ).ready(function() {
            var page = 1;
            var stackNews = "";
            let fullAll = false;
            let fullAno = false;
            let fullNews = false;
            let fullEvent = false;

            loadNews(0, page);
            $("#all-news").click(function (){loadNews(0,1); clearStackNewsAndResetPage()});
            $("#announ-news").click(function (){loadNews(1,1); clearStackNewsAndResetPage()});
            $("#new-news").click(function (){loadNews(2,1); clearStackNewsAndResetPage()});
            $("#event-news").click(function (){loadNews(3,1); clearStackNewsAndResetPage()});

            function clearStackNewsAndResetPage(){
                stackNews = "";
                page = 1;
            }


            $("#loadMore").click(function (){
                page++;
                console.log(page);
                console.log(this)
                let type = 0;
                $('.newshome').each(function(){
                    if($(this).attr('class').includes("active")){
                        console.log();
                        switch ($(this).text().trim()){
                            case "TẤT CẢ":
                                type = 0;
                                break;
                            case "THÔNG BÁO":
                                type = 1;
                                break;
                            case "TIN TỨC":
                                type = 2;
                                break;
                            case "SỰ KIỆN":
                                type = 3;
                                break;
                        }
                    }
                });
                loadNews(type, page);
            });

            // function loadNews(type){
                {{--$("#news2").html('<center><img src="/assets/img/loader.gif" /></center>'),--}}
                {{--$("#loadingnews").html(""),--}}
                {{--$.ajax({--}}
                {{--    headers: {--}}
                {{--        'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')--}}
                {{--    },--}}
                {{--    url: "{{route('get-news')}}",--}}
                {{--    type: "post",--}}
                {{--    dateType: "json",--}}
                {{--    data: {--}}
                {{--        type: type--}}
                {{--    },--}}
                {{--    success: function(t) {--}}
                {{--        let typeBadge = "";--}}
                {{--        let color = "";--}}
                {{--        let data = t.data;--}}
                {{--        let str = "";--}}
                {{--        if(data.length <= 0){--}}
                {{--            str = "Hiện tại chưa có bài viết nào trong mục này.";--}}
                {{--            $("#news2").html(str);--}}
                {{--            return;--}}
                {{--        }--}}
                {{--        console.log(t);--}}
                {{--        data.map(e => {--}}
                {{--            switch (parseInt(e.Type)) {--}}
                {{--                case 1:--}}
                {{--                    typeBadge = "TB";--}}
                {{--                    color = "red";--}}
                {{--                    break;--}}
                {{--                case 2:--}}
                {{--                    typeBadge = "TT";--}}
                {{--                    color = "green";--}}
                {{--                    break;--}}
                {{--                case 3:--}}
                {{--                    typeBadge = "SK";--}}
                {{--                    color = "orange";--}}
                {{--                    break;--}}
                {{--                default:--}}
                {{--                    typeBadge = "TT";--}}
                {{--                    color = "green";--}}
                {{--                    break;--}}
                {{--            }--}}
                {{--            let id = e.NewsID;--}}
                {{--            str += `<li><a href="{{route('view-news-by-id')}}?id=${id}"><span class="tag ${color}">${typeBadge}</span> ${e.Title}</a></li>`;--}}
                {{--        });--}}
                {{--        $("#news2").html(str);--}}
                {{--    }--}}
                {{--})--}}
            // }

            function loadNews(type, page){
                $("#news2").html('<center><img src="/assets/img/loader.gif" /></center>'),
                    $.ajax({
                        headers: {
                            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
                        },
                        url: "{{route('get-news')}}?page=" + page,
                        type: "post",
                        dateType: "json",
                        data: {
                            type: type
                        },
                        success: function(t) {
                            console.log(t)
                            switch (type){
                                case 0:
                                    if(t.length <= 0 && !fullAll){
                                        t += "<li>Không còn bài viết nào trong mục này</li>";
                                        $("#news2").html(t);
                                        fullAll = true;
                                    }
                                    break;
                                case 1:
                                    if(t.length <= 0 && !fullAno){
                                        t += "<li>Không còn bài viết nào trong mục này</li>";
                                        $("#news2").html(t);
                                        fullAno = true;
                                    }
                                    break;
                                case 2:
                                    if(t.length <= 0 && !fullNews){
                                        t += "<li>Không còn bài viết nào trong mục này</li>";
                                        $("#news2").html(t);
                                        fullNews = true;
                                    }
                                    break;
                                case 3:
                                    if(t.length <= 0 && !fullEvent){
                                        t += "<li>Không còn bài viết nào trong mục này</li>";
                                        $("#news2").html(t);
                                        fullEvent = true;
                                    }
                                    break;
                            }
                            stackNews += t;
                            $("#news2").html(stackNews);
                        }
                    })
            }
        });

    </script>
@endpush
