<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class EventRewardGoodsRequest extends FormRequest
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
            'ActivityType' => 'required|numeric',
            'SubActivityType' => 'required|numeric',
            'TemplateId' => 'required',
            'StrengthLevel' => 'required',
            'AttackCompose' => 'required',
            'DefendCompose' => 'required',
            'LuckCompose' => 'required',
            'AgilityCompose' => 'required',
            'IsBind' => 'required',
            'ValidDate' => 'required',
            'Count' => 'required',
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
