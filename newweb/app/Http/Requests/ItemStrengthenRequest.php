<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ItemStrengthenRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        // only allow updates if the user is logged in
        return backpack_auth()->check() && backpack_user()->hasRole('Game Masters');
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            // 'name' => 'required|min:5|max:255'
        ];
        // return [
        //     'StrengthenLevel' => 'required|numeric',
        //     'Rock' => 'required|numeric',
        //     'Random' => 'required|numeric',
        //     'Rock1' => 'required|numeric',
        //     'Rock2' => 'required|numeric',
        //     'Rock3' => 'required|numeric',
        //     'StoneLevelMin' => 'required|numeric',
        // ];
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
