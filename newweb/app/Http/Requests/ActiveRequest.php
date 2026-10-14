<?php

namespace App\Http\Requests;

use App\Http\Requests\Request;
use Illuminate\Foundation\Http\FormRequest;

class ActiveRequest extends FormRequest
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
            'ActiveID' => 'required|numeric',
            'Title' => 'required|min:5|max:255',
            'StartDate' => 'required|date',
            'Type' => 'required|numeric|min:1|max:3',
            'Description' => 'nullable',
            'Content' => 'nullable',
            'AwardContent' => 'nullable',
            'ActionTimeContent' => 'nullable',
            'EndDate' => 'nullable',
            'IsOnly' => 'nullable',
            'CanGetCode' => 'nullable',
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
