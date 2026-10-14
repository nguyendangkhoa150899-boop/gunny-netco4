<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class QuestGoodsCreateRequest extends FormRequest
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
            'QuestID' => 'required|numeric',
            'RewardItemID' => 'required',
            'IsSelect' => 'required',
            'RewardItemValid' => 'required|numeric',
            'RewardItemCount' => 'required|numeric',
            'StrengthenLevel' => 'nullable',
            'AttackCompose' => 'nullable',
            'DefendCompose' => 'nullable',
            'AgilityCompose' => 'nullable',
            'LuckCompose' => 'nullable',
            'IsCount' => 'nullable',
            'IsBind' => 'nullable',
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
