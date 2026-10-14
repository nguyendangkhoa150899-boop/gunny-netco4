<div class="master-qr-info" id='master-qr-info'>
    <div class="block-sm">
        <img src="/assets/img/master-info-sm.jpg">
    </div>

    <div class="block-more">
        <div class="btn-close">
            <svg xmlns="http://www.w3.org/2000/svg" height="24" viewBox="0 -960 960 960" width="24"><path d="m256-200-56-56 224-224-224-224 56-56 224 224 224-224 56 56-224 224 224 224-56 56-224-224-224 224Z"/></svg>
        </div>
        <a href="#">
            <img src="/assets/img/master-info-more.jpg">
        </a>
    </div>
</div>

<script>
    let el_master_info = $('#master-qr-info');

    let btn_sm = $('#master-qr-info').find('.block-sm');
    let btn_more = $('#master-qr-info').find('.block-more');
    let btn_close = $('#master-qr-info').find('.btn-close');

    btn_sm.on('click', function () {
        if ($('#master-qr-info').hasClass("selected")) {
            // If it does, remove the class
            $('#master-qr-info').removeClass("selected");
        } else {
            // If it doesn't, add the class
            $('#master-qr-info').addClass("selected");
        }
    });

    btn_close.on('click', function () {
        $('#master-qr-info').removeClass("selected");
    });

</script>
