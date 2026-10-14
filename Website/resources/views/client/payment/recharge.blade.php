<script type="text/javascript">
    $(document).ready(function() {

        $('.tags').on('click', 'a', function(e) {
            //console.log(this);
            var val = $(this).attr('href').slice(1);
            $(this).parent().find('a').removeClass('selected');
            $(this).toggleClass('selected');
            if (val != "paypal" && val != "stripe" && val != "card" && val != "ex1") {
                $('#valor').val(val);
            }
            e.preventDefault();
        });
    });
</script>
<section class="box register">
    <div class="title-new">
        <h1 style="color: #c3332a">NẠP TIỀN</h1>
    </div>
    <div class="tabsContent">
        <div class="active biglist">
            <div class="tab">
                <!-- <button class="tablinks active" onclick="openPage(event, 'napthe')">NẠP THẺ</button> -->
                <button class="tablinks" onclick="openPage(event, 'napmomo')">NẠP MOMO</button>
                <button class="tablinks" onclick="openPage(event, 'napatm')">NẠP ATM</button>
            </div>

            <!-- <div id="napthe" class="tabcontent" style="display: block;">

                <div class="list-card-recharge">

                    <div class="tags">


                    </div>

                </div>
                <form id="rechargeForm" class="account">
  
                </form>
            </div> -->

                <div id="napmomo" class="tabcontent" style="display: block;">
                    <div class="card-body">
                            <img style="display: inherit;" class="img-thumbnail" onclick="setTypecard(7)"
                                 src="/assets/img/momo.jpg">
						<br>
                        Chuyển khoản MOMO tới số : <b>{{ $config['payment_momo_phone'] }}</b> <br>
                        Tên Tài Khoản : <b>{{ $config['payment_momo_author'] }}</b><br>
                        Nội dung : <b>{{ env('MOMO_COMMENT_PREFIX') }} {{ Auth::guard('member')->user()->Email }}</b><br>
                        <br>
						<b>
                            <font color="blue">Vui lòng kích hoạt 2FA để bảo về tài khoản.</font>
						<br />
						<br />
                        <b>
                            <font color="red">Vui lòng chuyển khoản đúng nội dung để hệ thống có thể kiểm tra nhanh nhất
                                ( &lt; 90 giây)</font>
						<br />
						<br />
						- Tỉ lệ nạp MoMo và ATM là 10:2.5 (10.000 VNĐ = 2.500 Coin).<br />
						- Coin nạp sử dụng trong > Mục <font color="red">"Chuyển xu"</font>.<br />

						- Nạp xong vui lòng chụp bill gửi vào FanPage để thông báo cho Admin add coin cho bạn.<br />
                        </b>
                    </div>
                </div>

                <div id="napatm" class="tabcontent" style="display: none;">
                    <div class="card-body">
						<div class="card-body">
                            <img style="display: inherit;" class="img-thumbnail" onclick="setTypecard(7)"
                                 src="/assets/img/atm.jpg">
						<br>
                        Chuyển khoản ATM tới: {{$config['payment_bank_account']}}<br/>  ({{$config['payment_bank_vendor']}} )<br />
                        Nội dung: <b>{{ env('BANK_COMMENT_PREFIX') }} {{Auth::guard('member')->user()->Email}}</b><br>
                        <br>
						<b>
                            <font color="blue">Vui lòng kích hoạt 2FA để bảo vệ tài khoản.</font>
						<br />
						<br />
                        <b>
						<br />
						<br />
						- Tỉ lệ nạp MoMo và ATM là 10:2.5 (10.000 VNĐ = 2.500 Coin).<br />
						- Coin nạp sử dụng trong > Mục <font color="red">"Chuyển xu"</font>.<br />

						- Nạp xong vui lòng chụp bill gửi vào FanPage để thông báo cho Admin add coin cho bạn.<br />
                        </b>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <script type="text/javascript">
        var typeCard = 0;

        function setTypecard(type) {
            typeCard = type;
        };
    </script>
</section>
