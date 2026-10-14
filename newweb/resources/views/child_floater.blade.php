<div class="child-floater">
    <div class="discord">
        <img src="/images/discord.png" />
    </div>
    <div class="facebook">
        <img src="/images/facebook.png" />
    </div>
    <div class="choingay">
        <img src="/images/choingay.gif" alt="choingay">
    </div>
</div>
<script>
    var discord = '{{ \App\Models\Setting::get('discord') }}';
    var facebook = '{{ \App\Models\Setting::get('fanpage') }}';
    $(document).ready(function (){
        setTimeout(function () {
            $(".loadingunready").fadeOut();
        }, 1000);
        $('html, body').animate({
            scrollTop: $("#account").offset().top
        }, 500);

        $(".discord").click(function () {
            if (discord) {
                window.open(discord, '_blank');
            }
        });
        $(".facebook").click(function () {
            if (facebook) {
                window.open(facebook, '_blank');
            }
        });
        $(".choingay").click(function () {
            window.location.href = '/play/1001';
        });
    });
</script>
