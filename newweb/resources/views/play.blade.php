@extends('layout.app')

@section('content')
    <?php
    echo env('FLASH_URL').'Loading.swf?user='.$username.'&key='.$keyrand.'&v=104&rand=92386938&config='.$configLink;
    die;
    ?>
    <div id="play">
        <div class="lachuoi"></div>
        <div class="nv1"></div>
        <div class="nv2"></div>
        <div class="mamxanh"></div>
        <div class="kien"></div>
        <div class="mntt"></div>
        <aside id="content">
            <div class="goc20"></div>
            <div class="goc30"></div>
            <div class="goc50"></div>
            <div class="goc65"></div>
            <div class="swf-area">
                <script src="/js/swfobject.js"></script>
                <script>

                    var swfPath = "{{ $flashUrl }}/{{ $flashFile }}";
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
                </script>
                <center><div id="gameContent">
                        <p><a href="/GoGunLauncher.exe"><b>Vui lòng tải Launcher để chơi game.</b></a></p>
                    </div></center>
            </div>
        </aside>
    </div>
@endsection

@section('custom_footer_js')
    <script>
        var error = {{ $error }};
        var message = '{{ $message }}';
        $(document).ready(function () {
            if (error && message) {
                setTimeout(function () {
                    alertify.alert("Lỗi", message);
                }, 1000);
            }
        });
    </script>
@endsection
