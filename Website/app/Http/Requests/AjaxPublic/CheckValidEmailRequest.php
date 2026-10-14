<?php

namespace App\Http\Requests\AjaxPublic;

use Illuminate\Foundation\Http\FormRequest;

class CheckValidEmailRequest extends FormRequest
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
            'Fullname' => 'required|string|email|max:255|unique:sqlsrv_mem.Mem_Account',
        ];
    }
}
