<?php

namespace App\Http\Requests;

use App\Http\Requests\Request;
use Illuminate\Foundation\Http\FormRequest;

class PveRequest extends FormRequest
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
            'ID' => 'required|numeric',
            'Name' => 'required',
            'Type' => 'required|numeric',
            'LevelLimits' => 'required|numeric',
            'Pic' => 'required',
            'Description' => 'nullable',
            'SimpleGameScript' => 'nullable',
            'NormalGameScript' => 'nullable',
            'HardGameScript' => 'nullable',
            'TerrorGameScript' => 'nullable',
            'Ordering' => 'required',
            'AdviceTips' => 'nullable',
            'BossFightNeedMoney' => 'nullable',
            'FightPower' => 'nullable',
            'Disabled' => 'required',
            'CanOpenBoss' => 'required',
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
