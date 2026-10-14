<?php

namespace App\Http\Requests;

use App\Member;
use Illuminate\Foundation\Http\FormRequest;

class ForgotPassRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        // only allow updates if the user is not logged in
        $m = new Member();
        return !$m->isLoggedIn();
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'email' => 'required|email:dns,rfc',
            'captcha' => 'captcha',
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
            'captcha' => [
                'required' => 'Vui lòng nhập Captcha.',
                'captcha' => 'Sai captcha',
            ]
        ];
    }
}
