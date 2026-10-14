@extends('layout/news')

@section('content')
    <div class="frame-content">
        <h3>{{ $news->title }}</h3>
        {!! $news->content !!}
    </div>
@endsection
