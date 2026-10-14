<nav id="menu">

    <ul class="container">
      <li>
        <a href="{{route('home')}}">TRANG CHỦ</a>
      </li>
      <li>
        <a href="{{route('view-account')}}">TÀI KHOẢN</a>
      </li>
      <li>
        <a href="{{route('view-account').'?type=recharge'}}">NẠP TIỀN</a>
      </li>
      <li>
        <a href="{{route('view-account').'?type=convertCoin'}}">CHUYỂN XU</a>
      </li>
      <li>
        <a target="_blank" href="{{$config['fanpage_url']}}">FANPAGE</a>
      </li>
      <li>
        <a target="_blank" href="{{$config['group_url']}}">GROUP</a>
      </li>
    </ul>
  </nav>
