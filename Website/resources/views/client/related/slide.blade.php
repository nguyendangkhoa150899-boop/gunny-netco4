<section class='section-display-news'>
    <div class="slideshow-container animElement slide-left">
        @foreach($slides as $slide)
            <div class="mySlides fade">
                <a href="{{$slide->link}}" target="_blank">
                    <img src="/storage/{{$slide->image}}" style="width:100%">
                </a>
            </div>
        @endforeach
        <a class="prev" onclick="plusSlides(-1)">&#10094;</a>
        <a class="next" onclick="plusSlides(1)">&#10095;</a>
        <div class="dotList">
            @foreach($slides as $key => $slide)
            <span class="dot" onclick="currentSlide({{++ $key}})"></span>
            @endforeach
        </div>
    </div>
    <div class="slide-right-custom animElement slide-right">
        @foreach($slides as $key => $slide)
        <div class="item-right active"><a onclick="currentSlide({{++ $key}})">{{$slide->title}}</a></div>
        @endforeach
    </div>
</section>
