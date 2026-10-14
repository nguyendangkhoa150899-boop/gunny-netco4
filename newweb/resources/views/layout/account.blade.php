@include('layout/head')
<body>
    <div class="loadingunready">
        <img src="/images/Bean Eater-0.5s-204px.svg" width="204">
    </div>
    <div class="overlay-loading">
        <img src="/images/Bean Eater-0.5s-204px.svg" width="204">
    </div>
    @include('home_banner')
    <div id="account">
        <aside id="content">
            <div class="content-container">
                <div id="function_items">
                    <div class="function">
                        <a href="/tai-khoan">Quản lý tài khoản</a>
                    </div>
                    <div class="function">
                        <a href="/tai-khoan/doi-mat-khau">Đổi mật khẩu</a>
                    </div>
                    <div class="function">
                        <a href="/tai-khoan/nap-coin">Nạp Coin</a>
                    </div>
                    <div class="function">
                        <a href="/tai-khoan/lich-su-nap-the">Lịch sử nạp thẻ</a>
                    </div>
                    <div class="function">
                        <a href="/tai-khoan/chuyen-xu">Chuyển xu</a>
                    </div>
                    <div class="function">
                        <a href="/tai-khoan/giftcode">Giftcode</a>
                    </div>
                    <div class="function">
                        <a href="/tai-khoan/doi-ten-nhan-vat">Đổi tên nhân vật</a>
                    </div>
                </div>
                <div class="realcontent">
                    <div class="frame">
                        @yield('content')
                    </div>
                </div>
            </div>
        </aside>
        @include('child_floater')
    </div>
    <footer>
        @include('layout.footer')
    </footer>
    @yield('custom_footer_js')
</body>
</html>
