<section class="box register">
    <div class="title-new">
        <h1 style="color: #c3332a">XÁC THỰC EMAIL</h1>
    </div>
    <div class="tabsContent">
        <div class="active biglist">
            <form id="createAccountForm" class="account">
                <label>Nhấn gửi mã sau đó kiểm tra Email của bạn (Vui lòng kiểm tra cả trong hộp thư spam)</label>
{{--                <label>- Mã xác thực đã được gửi đến Email của bạn (Vui lòng kiểm tra cả trong hộp thư spam)</label>--}}
                <label>
                    <span>Xác nhận Captcha</span> <br>
                    <div class="wrapper-captcha">
                        <input type="text" id="txtCaptcha" style="width:200px;" placeholder="Nhập chuỗi bên cạnh"
                               autocomplete="off">
                        <img id="captcha_img_src" src="{{captcha_src()}}"/>
                    </div>
                    <div id="regacc_txtcode_tooltip" class="error-check" style="display:none;">
                    </div>
                </label>
                <label class="errors-register-form" style="display: none;color: red"></label>

                <button class="button" id="verifyEmail" type="button"> <span class="icon"></span> XÁC NHẬN </button>
            </form>
        </div>
    </div>
</section>

