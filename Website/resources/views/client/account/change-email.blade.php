<section class="box register">
    <div class="title-new">
        <h1 style="color: #c3332a">Thay đổi mật khẩu</h1>
    </div>
    <div class="tabsContent">
        <div class="active biglist">
            <form id="changeEmailFrm" class="account">
                @if($isVerified == true)
                <label>- Nhập captcha, sau đó nhấn gửi mã để nhận mã xác thực để thay đổi email, sau đó xác nhận tại đây</label>
                @endif
                <label>
                    <span>Email hiện tại</span>
                    <input type="text" id="txtCurrentEmail" value="{{$currentMail}}" readonly disabled>
                    <div id="usernameError" class="error-check" style="display:none;">
                        <div id="formtip_inner" class="error-check-mess"></div>
                    </div>
                </label>

                <label>
                    <span>Email mới</span>
                    <input id="txtNewEmail" type="email" placeholder="Địa chỉ email mới"
                           autocomplete="off" required="">
                    <div id="newEmailError" class="error-check" style="display:none;"></div>
                </label>
                @if($isVerified == true)
                <label>
                    <span>Mã xác thực từ email cũ</span>
                    <input id="txtCodeOldMail" type="number" placeholder="Mã xác thực từ địa chỉ email cũ"
                           autocomplete="off" required="">
                    <div id="newEmailError" class="error-check" style="display:none;"></div>
                </label>
                @endif
                <label>
                    <span>Xác nhận Captcha</span> <br>
                    <div class="wrapper-captcha">
                        <input type="text" id="txtCaptcha" style="width:200px;" placeholder="Nhập chuỗi bên cạnh"
                               autocomplete="off" required="">
                        <img id="captcha_img_src" src="{{captcha_src()}}"/>
                    </div>
                    <div id="regacc_txtcode_tooltip" class="error-check" style="display:none;">
                    </div>
                </label>
                <div class="button-functional-account">
                    <a id="changeEmailBtn" class="item"
                       style="background-color: rgb(245,98,0); border-color: rgb(250,83,0);">Thay đổi email
                    </a>
                    @if($isVerified == true)
                    <a id="sendChangeEmailCode" class="item"
                       style="background-color: rgb(245,98,0); border-color: rgb(250,83,0);">Gửi mã xác thực
                    </a>
                    @endif
                </div>
                <div class="errors-change-email-form" style="display: none;color: red"></div>
            </form>
        </div>
    </div>
</section>
