@include('layout/head')
<body>
<div class="loadingunready">
    <img src="/images/Bean Eater-0.5s-204px.svg" width="204">
</div>
<div class="overlay-loading">
    <img src="/images/Bean Eater-0.5s-204px.svg" width="204">
</div>
@include('home_banner')
<div id="news">
    <aside id="content">
        <div class="content-container">
            <div id="function_items">
                <ul>
                    @foreach ($articles as $article)
                        <li class="function">
                            <a href="/news/{{ $article->slug }}">{{ $article->title }}</a>
                        </li>
                    @endforeach
                </ul>
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
