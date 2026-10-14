@extends('layout.app')

@section('content')
    @include('home_banner')
    <aside id="tops">
        <div class="content-container">
            <div class="frame-content">
                <h3>{{ $event->name }}</h3>
                <p>{{ $event->description }}</p>
                <ul class="nav nav-tabs" id="myTab" role="tablist">
                    @foreach ($topRacing as $i => $top)
                        <li class="nav-item">
                            <a class="nav-link
                            @if ($i == 0)
                                active
                            @endif" id="top_{{ $top['id'] }}-tab" data-toggle="tab" href="#top_{{ $top['id'] }}" role="tab" aria-controls="top_{{ $top['id'] }}" aria-selected="true">{{ $top['name'] }}</a>
                        </li>
                    @endforeach
                </ul>
                <div class="tab-content" id="myTabContent">
                    @foreach ($topRacing as $i => $top)
                        <div class="tab-pane fade
                        @if ($i == 0)
                            show active
                        @endif" id="top_{{ $top['id'] }}" role="tabpanel" aria-labelledby="top_{{ $top['id'] }}-tab">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>Hạng</th>
                                        <th>Quà Ingame</th>
                                        <th>Số lượng</th>
                                        <th>Thuộc tính</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    @foreach ($top['awards'] as $rank => $awards)
                                        @foreach ($awards as $i => $award)
                                            <tr>
                                                @if ($i == 0)
                                                    <td rowspan="{{ count($awards) }}">Top {{ $rank }}</td>
                                                @endif
                                                <td>{{ $award->Item->Name }}</td>
                                                <td>{{ $award->count }}</td>
                                                <td>
                                                    <div class="item-hover-pop">
                                                        {!! $award->Item->ResourceImageColumn() !!}
                                                        @include('item_popup', ['item' => $award->Item])
                                                    </div>
                                                </td>
                                            </tr>
                                        @endforeach
                                    @endforeach
                                </tbody>
                            </table>
                        </div>
                    @endforeach
                </div>
            </div>
        </div>
    </aside>
@endsection

@section ('custom_footer_js')
    <script>
        $(document).ready(function () {
            $(".nav-tabs[role=tablist] li.nav-item a").click(function (e) {
                e.preventDefault();
                $(".nav-tabs[role=tablist] li.nav-item a").removeClass('active');
                $(this).addClass('active');
                var ref = $(this).attr('href');
                $(".tab-content > .tab-pane").removeClass('active').removeClass('show');
                $(ref).addClass('show').addClass('active');
            })
        })
    </script>
@endsection
