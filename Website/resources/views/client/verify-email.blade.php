@extends('client.master')

@section('content')

    <section class="box register">
        <div class="title-new">
            <h1 style="color: #c3332a">Xác thực Email</h1>
        </div>
        <div class="tabsContent">
            <div class="active biglist animElement slide-left">
                <form class="detail-account">
                    <label>
                        @if($errors->any())
                            <span style="color: red;text-align: center">{{$errors->first()}}</span>
                        @endif
                    </label>

                    <label>
                        <span>{{ $success }}</span>
                    </label>
                </form>

            </div>
        </div>
    </section>







@endsection


