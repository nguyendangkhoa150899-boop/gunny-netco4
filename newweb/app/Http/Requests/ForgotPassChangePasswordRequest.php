<?php

namespace App\Http\Requests;

use App\Member;
use Illuminate\Foundation\Http\FormRequest;

class ForgotPassChangePasswordRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        // only allow updates if the user is logged in
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
            'password' => 'required|min:6|max:255',
            'repassword' => 'required|same:password',
            'captcha' => 'required|captcha'
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
            'password' => [
                'required' => 'Vui lòng nhập Mật khẩu mới.',
                'min' => 'Mật khẩu quá ngắn',
                'max' => 'Mật khẩu quá dài',
            ],
            'repassword' => [
                'required' => 'Vui lòng nhập Xác nhận mật khẩu.',
                'same' => 'Xác nhận mật khẩu không đúng',
            ],
            'captcha' => [
                'required' => 'Vui lòng nhập Captcha.',
                'captcha' => 'Sai captcha',
            ]
        ];
    }
}
