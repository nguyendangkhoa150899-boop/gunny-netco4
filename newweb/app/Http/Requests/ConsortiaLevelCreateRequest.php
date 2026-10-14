<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ConsortiaLevelCreateRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        // only allow updates if the user is logged in
        return backpack_auth()->check() && backpack_user()->can('gameManagement');
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'Level' => 'required|numeric',
            'Riches' => 'required|numeric',
            'Deduct' => 'required|numeric',
            'NeedGold' => 'required|numeric',
            'Count' => 'required|numeric',
            'StoreRiches' => 'required|numeric',
            'SmithRiches' => 'required|numeric',
            'ShopRiches' => 'required|numeric',
            'BufferRiches' => 'required|numeric',
            'KickMax' => 'required|numeric',
            'BossCount' => 'required|numeric',
        ];
    }

    /**
     * Get the validation attributes that apply to the request.
     *
     * @return array
     */
    public function attributes()
    {
        return [
            //
        ];
    }

    /**
     * Get the validation messages that apply to the request.
     *
     * @return array
     */
    public function messages()
    {
        return [
            //
        ];
    }
}
