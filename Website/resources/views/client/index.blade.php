@extends('client.master')

@section('content')
    <!-- Login Frm -->
    @include('client.related.slide')
    @include('client.related.news')
    {{-- LAUNCHER --}}

    @include('client.related.page-main-guide')
    @include('client.related.item')

    <section>
        @include('client.related.page-main-page-image')
    </section>
@endsection

