<?php

namespace App\Http\Requests\Client;

use Illuminate\Foundation\Http\FormRequest;

class ChangePasswordRequest extends FormRequest
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
            'oldPassword' => 'required|min:6',
            'password' => 'required|min:6|confirmed',
            'password_confirmation' => 'required|min:6|regex:/[a-z]/|regex:/[A-Z]/|regex:/[0-9]/|regex:/[@$!%*#?&]/',
            'captcha' => 'required|captcha',
        ];
    }

    public function messages()
    {
        return [
            'captcha.captcha' => 'Mã captcha không chính xác, vui lòng nhập kết quả. Ví dụ: 10+1=11 thì bạn nhập 11 là được nhé !',
            'captcha.required' => 'Bạn chưa nhập captcha',
            'oldPassword.required' => 'Bạn chưa nhập mật khẩu cũ',
            'oldPassword.min' => 'Mật khẩu cũ tối thiểu phải 6 ký tự trở lên',
            'password.required' => 'Bạn chưa nhập mật khẩu mới',
            'password.regex' => 'Mật khẩu phải chứa số, kí tự, chữ hoa và chữ thường',
            'password.min' => 'Mật khẩu mới tối thiểu phải 6 ký tự trở lên',
            'password.confirmed' => 'Mật khẩu xác nhận không khớp',
            'password_confirmation.required' => 'Bạn chưa nhập mật khẩu xác nhận',
        ];
    }
}
