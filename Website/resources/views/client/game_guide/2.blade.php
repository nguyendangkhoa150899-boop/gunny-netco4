@extends('client.master')

@section('content')

<section class="">
                        <section>
                            <div class="card">
                                <h1 class="card--title">HƯỚNG DẪN</h1>
                                <div class="card--inner">

                                    <p>
                                        <strong>1. Hướng dẫn nhanh</strong>
                                    </p>
                                    <p>Đo <strong>khoảng cách giữa người chơi và mục tiêu</strong> &gt; Xác định<strong>
                                            góc bắn</strong> &gt; Xác định<strong> lực bắn</strong>.</p>
                                    <p>
                                        <strong>2. Hướng dẫn chi tiết</strong>
                                    </p>
                                    <p>Người chơi cần đo khoảng cách của mình đến mục tiêu là bao nhiêu để căn góc và sử
                                        dụng lực chính xác. Ở dưới màn hình Gunny Origin có hiển thị thước kẻ màu vàng
                                        có độ dài là 10 cự ly.</p>
                                    <p class="img"><img class="lazy" title="Cự ly trong Gunny Origin"
                                            src="https://cdn.tgdd.vn//GameApp/-1//cacch-ban-Gunny-Origin-1-800x451.jpg"
                                            alt="Cự ly trong Gunny Origin" width="800" height="451"
                                            data-src="https://cdn.tgdd.vn//GameApp/-1//cacch-ban-Gunny-Origin-1-800x451.jpg"
                                            style="display: block; opacity: 1;"></p>
                                    <p>Để đo khoảng cách, bạn hãy kéo màn hình để nhân vật nằm ở mép màn hình, sau đó
                                        đếm khoảng cách giữa nhân vật và mục tiêu.</p>
                                    <p class="img"><img class="lazy" title="Cách đo khoảng cách cự ly"
                                            src="https://cdn.tgdd.vn//GameApp/-1//cacch-ban-Gunny-Origin-2-800x451.jpg"
                                            alt="Cách đo khoảng cách cự ly" width="800" height="451"
                                            data-src="https://cdn.tgdd.vn//GameApp/-1//cacch-ban-Gunny-Origin-2-800x451.jpg"
                                            style="display: block; opacity: 1;"></p>
                                    <p><strong> Bước 2: Xác định góc bắn</strong></p>
                                    <p>Bạn dễ dàng điều chỉnh góc bắn trong game bằng nút điều khiển ở góc trái phía
                                        dưới màn hình.</p>
                                    <p class="img"><img class="lazy" title="Cách điều chỉnh góc bắn"
                                            src="https://cdn.tgdd.vn//GameApp/-1//cacch-ban-Gunny-Origin-3-800x466.jpg"
                                            alt="Cách điều chỉnh góc bắn" width="800" height="466"
                                            data-src="https://cdn.tgdd.vn//GameApp/-1//cacch-ban-Gunny-Origin-3-800x466.jpg"
                                            style="display: block; opacity: 1;"></p>
                                    <p>Mỗi một góc bắn và khoảng cách đối với mục tiêu, người chơi cần điều chỉnh lực
                                        bắn phù hợp để bắn trúng kẻ địch. Bạn hãy nhấn vào biểu tượng bảng lực để xem và
                                        điều chỉnh lực bắn phù hợp nhé.</p>
                                    <p class="img"><img class="lazy" title="Cách xem Bảng lực"
                                            src="https://cdn.tgdd.vn//GameApp/-1//cacch-ban-Gunny-Origin-4-800x466.jpg"
                                            alt="Cách xem Bảng lực" width="800" height="466"
                                            data-src="https://cdn.tgdd.vn//GameApp/-1//cacch-ban-Gunny-Origin-4-800x466.jpg"
                                            style="display: block; opacity: 1;"></p>
                                    <p><strong>Ví dụ về góc bắn:</strong></p>
                                    <p><strong>Góc 20 độ</strong>: phù hợp cho địa hình bằng phẳng, ít ảnh hưởng bởi
                                        gió. Áp dụng cho các vũ khí như túi vũ khí, phi tiêu, rương trị liệu, lu gạch,
                                        pháo, giỏi trái cây.</p>
                                    <p>Tuy nhiên nếu gió to hoặc khoảng cách lớn, thì sẽ có độ lệch chút xíu. Bạn chỉ
                                        nên sử dụng góc bắn này với khoảng cách 10 trở lại. Sau đó, sử dụng bảng góc để
                                        kết hợp chính xác cực ly và lực bắn.</p>
                                    <div>
                                        <table style="border-collapse: collapse; width: 100%;" border="1">
                                            <tbody>
                                                <tr>
                                                    <td style="width: 25%; text-align: center;"><strong>Cự ly</strong>
                                                    </td>
                                                    <td style="width: 25%; text-align: center;"><strong>Lực</strong>
                                                    </td>
                                                    <td style="width: 25%; text-align: center;"><strong>Cự ly</strong>
                                                    </td>
                                                    <td style="width: 25%; text-align: center;"><strong>Lực</strong>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 25%; text-align: center;">1</td>
                                                    <td style="width: 25%; text-align: center;">10</td>
                                                    <td style="width: 25%; text-align: center;">11</td>
                                                    <td style="width: 25%; text-align: center;">57</td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 25%; text-align: center;">2</td>
                                                    <td style="width: 25%; text-align: center;">19</td>
                                                    <td style="width: 25%; text-align: center;">12</td>
                                                    <td style="width: 25%; text-align: center;">60</td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 25%; text-align: center;">3</td>
                                                    <td style="width: 25%; text-align: center;">25</td>
                                                    <td style="width: 25%; text-align: center;">13</td>
                                                    <td style="width: 25%; text-align: center;">63</td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 25%; text-align: center;">4</td>
                                                    <td style="width: 25%; text-align: center;">30</td>
                                                    <td style="width: 25%; text-align: center;">14</td>
                                                    <td style="width: 25%; text-align: center;">66</td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 25%; text-align: center;">5</td>
                                                    <td style="width: 25%; text-align: center;">36</td>
                                                    <td style="width: 25%; text-align: center;">15</td>
                                                    <td style="width: 25%; text-align: center;">69</td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 25%; text-align: center;">6</td>
                                                    <td style="width: 25%; text-align: center;">40</td>
                                                    <td style="width: 25%; text-align: center;">16</td>
                                                    <td style="width: 25%; text-align: center;">72</td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 25%; text-align: center;">7</td>
                                                    <td style="width: 25%; text-align: center;">44</td>
                                                    <td style="width: 25%; text-align: center;">17</td>
                                                    <td style="width: 25%; text-align: center;">74</td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 25%; text-align: center;">8</td>
                                                    <td style="width: 25%; text-align: center;">48</td>
                                                    <td style="width: 25%; text-align: center;">18</td>
                                                    <td style="width: 25%; text-align: center;">76</td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 25%; text-align: center;">9</td>
                                                    <td style="width: 25%; text-align: center;">51</td>
                                                    <td style="width: 25%; text-align: center;">19</td>
                                                    <td style="width: 25%; text-align: center;">78</td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 25%; text-align: center;">10</td>
                                                    <td style="width: 25%; text-align: center;">54</td>
                                                    <td style="width: 25%; text-align: center;">20</td>
                                                    <td style="width: 25%; text-align: center;">80</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <p><strong>Góc 65 độ</strong>: phù hợp với nhiều loại vũ khí, khả năng bắn trúng mục
                                        tiêu cao, ít chịu ảnh hưởng địa hình và tầm cao. Vũ khí sử dụng như lu gạch,
                                        tivi tủ lạnh, sấm sét, lựu đạn.</p>
                                    <p>Nhược điểm là chịu ảnh hưởng của lớn bởi sức gió và yêu cầu canh lực bắn khá
                                        chính xác.</p>
                                    <div class="set_table">
                                        <table style="border-collapse: collapse; width: 100%;" border="1">
                                            <tbody>
                                                <tr>
                                                    <td style="width: 25%; text-align: center;"><strong>Cự ly</strong>
                                                    </td>
                                                    <td style="width: 25%; text-align: center;"><strong>Lực</strong>
                                                    </td>
                                                    <td style="width: 25%; text-align: center;"><strong>Cự ly</strong>
                                                    </td>
                                                    <td style="width: 25%; text-align: center;"><strong>Lực</strong>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 25%; text-align: center;">1</td>
                                                    <td style="width: 25%; text-align: center;">13</td>
                                                    <td style="width: 25%; text-align: center;">11</td>
                                                    <td style="width: 25%; text-align: center;">58</td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 25%; text-align: center;">2</td>
                                                    <td style="width: 25%; text-align: center;">20</td>
                                                    <td style="width: 25%; text-align: center;">12</td>
                                                    <td style="width: 25%; text-align: center;">61</td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 25%; text-align: center;">3</td>
                                                    <td style="width: 25%; text-align: center;">26</td>
                                                    <td style="width: 25%; text-align: center;">13</td>
                                                    <td style="width: 25%; text-align: center;">64</td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 25%; text-align: center;">4</td>
                                                    <td style="width: 25%; text-align: center;">31</td>
                                                    <td style="width: 25%; text-align: center;">14</td>
                                                    <td style="width: 25%; text-align: center;">67</td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 25%; text-align: center;">5</td>
                                                    <td style="width: 25%; text-align: center;">37</td>
                                                    <td style="width: 25%; text-align: center;">15</td>
                                                    <td style="width: 25%; text-align: center;">70</td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 25%; text-align: center;">6</td>
                                                    <td style="width: 25%; text-align: center;">41</td>
                                                    <td style="width: 25%; text-align: center;">16</td>
                                                    <td style="width: 25%; text-align: center;">73</td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 25%; text-align: center;">7</td>
                                                    <td style="width: 25%; text-align: center;">44</td>
                                                    <td style="width: 25%; text-align: center;">17</td>
                                                    <td style="width: 25%; text-align: center;">76</td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 25%; text-align: center;">8</td>
                                                    <td style="width: 25%; text-align: center;">48</td>
                                                    <td style="width: 25%; text-align: center;">18</td>
                                                    <td style="width: 25%; text-align: center;">79</td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 25%; text-align: center;">9</td>
                                                    <td style="width: 25%; text-align: center;">53</td>
                                                    <td style="width: 25%; text-align: center;">19</td>
                                                    <td style="width: 25%; text-align: center;">82</td>
                                                </tr>
                                                <tr>
                                                    <td style="width: 25%; text-align: center;">10</td>
                                                    <td style="width: 25%; text-align: center;">56</td>
                                                    <td style="width: 25%; text-align: center;">20</td>
                                                    <td style="width: 25%; text-align: center;">85</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <p><strong>Lưu ý:</strong> Khi bắn góc 65 độ có gió, bạn nên điều chỉnh góc bắn như
                                        sau:</p>
                                    <ul>
                                        <li>Chiều gió thuận: 65 + (sức gió x 2)</li>
                                        <li>Chiều gió ngược: 65&nbsp; - (sức gió x2)</li>
                                    </ul>
                                    <p>Bạn hãy nhìn vào biểu tượng ở phía trên màn hình để biết chiều gió và sức gió
                                        nhé.</p>
                                    <p class="img"><img class="lazy" title="Chiều và sức gió"
                                            src="https://cdn.tgdd.vn//GameApp/-1//cacch-ban-Gunny-Origin-5-800x466.jpg"
                                            alt="Chiều và sức gió" width="800" height="466"
                                            data-src="https://cdn.tgdd.vn//GameApp/-1//cacch-ban-Gunny-Origin-5-800x466.jpg"
                                            style="display: block; opacity: 1;"></p>
                                    <p class="titleOfImages"
                                        style="font-size: 15px; color: #777777; text-align: center;">Chiều và sức gió
                                    </p>

                                </div>
                            </div>
                        </section>
                    </section>

@endsection

