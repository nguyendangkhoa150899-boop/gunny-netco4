@php
    /**
    * @param $item: ShopGoods
    * @param $is_popup: boolean
    * @param $strengthen: integer (for future use)
    * @param $date: integer
    * @param $composes: string
    */
@endphp
<div class="item_popup">
    <div class="popup_container">
        <p class="item_name quality_{{ $item->Quality }}">{{ $item->Name }}</p>
        <div class="item_quality">
            <div class="item_quality_label">Phẩm chất</div>
            <div class="item_quality_value quality_{{ $item->Quality }}">{{ $item->QualityText() }}</div>
        </div>
        <div class="item_category">
            <div class="item_category_label">Loại</div>
            <div class="item_category_value">{{ $item->Category->Name }}</div>
        </div>
        @php
            /**
            * Vũ khí / vũ khí đặc biệt / áo / nón / vũ khí phụ
            */
            $labels = [
                7 => 'Sát thương',
                27 => 'Sát thương',
                1 => 'Hộ giáp',
                5 => 'Hộ giáp',
            ];
            //property3
            $label_17 = [
                31 => 'giảm thương',
                32 => 'Hồi phục'
            ];
        @endphp
        @if (in_array($item->CategoryID, [7, 27, 1, 5, 17, 31]))
            <div class="item_damage">
                <div class="item_damage_label">
                    @if ($item->CategoryID == 17 || $item->CategoryID == 31)
                        {{ $label_17[$item->Property3] }}
                    @else
                        {{ $labels[$item->CategoryID] }}
                    @endif
                </div>
                <div class="item_damage_value">{{ $item->Property7 }}
                    @if (!empty($strengthen))
                        +({{ caclStrengthenValue($strengthen, $item->Property7) }}
                    @endif
                </div>
            </div>
            @if ($item->CategoryID == 7 || $item->CategoryID == 27)
                <div class="item_angle">
                    <div class="item_angle_label">Góc độ</div>
                    <div class="item_angle_value">{{ $item->Property5 }}° ~ {{ $item->Property6 }}°</div>
                </div>
            @endif
        @endif
        @if ($item->Attack || $item->Defence || $item->Agility || $item->Luck)
            <div class="item_properties">
                <div class="item_properties_property">Công kích: {{ $item->Attack }}</div>
                <div class="item_properties_property">Phòng thủ: {{ $item->Defence }}</div>
                <div class="item_properties_property">Nhanh nhẹn: {{ $item->Agility }}</div>
                <div class="item_properties_property">May mắn: {{ $item->Luck }}</div>
            </div>
        @endif
        <div class="item_description">
            {{ $item->Description }}
        </div>
        <div class="item_valid_date
        @if (empty($date))
            forever
        @endif
        ">
            Hiệu lực {{ empty($date)?'vĩnh cửu':$date.' ngày' }}
        </div>
    </div>
</div>
