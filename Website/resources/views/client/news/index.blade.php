@extends('client.master')

@section('content')

    <section class="">
        <section>
            <div class="banner"><img src="/assets/img/ban01.png"></div>
            <div class="box single">
                <div class="share animElement slide-top">
                    <div class="date">
                        <span class="d"></span>
                    </div>
                    <a href="#facebook"><i class="icon-facebook"></i></a>
                    <a href="#whatsapp"><i class="icon-whatsapp"></i></a>
                    <a href="#twitter"><i class="icon-twitter"></i></a>
                    <a href="#pinterest"><i class="icon-pinterest"></i></a>
                </div>
                <div class="content animElement slide-top">
                    <div class="title">{{$news->Title}}</div>
                    <p dir="ltr">
                    {!! $news->Content !!}
                </div>
            </div>

        </section>
    </section>

@endsection

