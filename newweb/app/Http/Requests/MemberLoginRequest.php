<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class MemberLoginRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        // only allow updates if the user is logged in
        $m = new \App\Member();
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
            'username' => 'required|min:5|max:255|not_regex:/ +/i',
            'password' => 'required|min:6|max:255',
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
            'username' => [
                'required' => 'Vui lòng nhập Tài khoản.',
                'min' => 'Tên tài khoản quá ngắn',
                'max' => 'Tên tài khoản quá dài',
                'not_regex' => 'Tên tài khoản không được chứa các ký tự khoảng trắng!',
            ],
            'password' => [
                'required' => 'Vui lòng nhập Mật khẩu.',
                'min' => 'Mật khẩu quá ngắn',
                'max' => 'Mật khẩu quá dài',
            ],
        ];
    }
}
