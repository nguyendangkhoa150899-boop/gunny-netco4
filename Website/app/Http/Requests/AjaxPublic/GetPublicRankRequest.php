<?php

namespace App\Http\Requests\AjaxPublic;

use Illuminate\Foundation\Http\FormRequest;

class GetPublicRankRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'server_id' => 'required',
            'type'  =>'required|numeric|min:1|max:20'
        ];
    }
}
