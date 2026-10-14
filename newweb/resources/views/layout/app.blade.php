@include('layout/head')
<body>
    <div class="loadingunready">
        <img src="/images/Bean Eater-0.5s-204px.svg" width="204">
    </div>
    <div class="overlay-loading">
        <img src="/images/Bean Eater-0.5s-204px.svg" width="204">
    </div>
    @yield('content')
    <footer>
        @include('layout.footer')
    </footer>
    <script>
        $(document).ready(function (){
            setTimeout(function () {
                $(".loadingunready").fadeOut();
            }, 1000);
        });
    </script>
    @yield('custom_footer_js')
</body>
</html>
