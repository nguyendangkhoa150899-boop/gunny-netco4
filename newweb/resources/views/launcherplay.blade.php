<html>
    <head>
        <title>GoGunLauncher Play</title>
        <style>
            body {
                margin: 0;
            }

            .swf-area {
                width: 100%;
                height: 100%;
            }

            #gameContent {
                max-height: calc(100% - 50px);
            }
        </style>
    </head>
    <body>
        <div class="swf-area">
            <script src="/js/jquery-3.6.0.min.js"></script>
            <script src="/js/swfobject.js"></script>
            <script>
                var swfPath = "/flash/Loading.swf";
                var flashvars = {
                    user: "<?=$username?>",
                    key: "<?=$keyrand?>",
                    v: "104",
                    rand: "92386938",
                    config: "<?=$configLink?>"
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
                @if (!$is_uc)
                    $(document).ready(function () {
                        $( window ).resize(function() {
                            var height = $(".swf-area").height();
                            if (height < 650) {
                                height = 650;
                            }
                            height -= 50;
                            var width = height * 5 / 3;
                            $("#gameContent").width(width);
                            $("#gameContent").height(height);
                        });
                    });
                @endif
            </script>
            <center>
                <div id="gameContent">
                    <p><a href="/GoGunLauncher.exe"><b>Vui lòng tải Launcher để chơi game.</b></a></p>
                </div>
                <div class="ruler">
                    <img src="/images/ruler.jpg" width="1000" height="50">
                </div>
            </center>
        </div>
    </body>
</html>
