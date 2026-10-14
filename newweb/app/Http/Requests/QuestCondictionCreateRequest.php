<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class QuestCondictionCreateRequest extends FormRequest
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
            'CondictionID' => 'required|numeric',
            'CondictionType' => 'required|numeric',
            'CondictionTitle' => 'required',
            'Para1' => 'required|numeric',
            'Para2' => 'required|numeric',
            'isOpitional' => 'nullable',
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
