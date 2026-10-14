<?php

namespace App\Http\Requests\Client\ForgotPassword;

use Illuminate\Foundation\Http\FormRequest;

class ResetPasswordRequest extends FormRequest
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
            'token' => 'required',
            'password' => 'required|min:6|confirmed|regex:/[a-z]/|regex:/[A-Z]/|regex:/[0-9]/|regex:/[@$!%*#?&]/',
            'password_confirmation' => 'required|min:6',
            'captcha' => 'required|captcha',
        ];
    }

    public function messages()
    {
        return [
            'captcha.captcha' => 'Mã captcha không chính xác, vui lòng nhập kết quả. Ví dụ: 10+1=11 thì bạn nhập 11 là được nhé !',
            'captcha.required' => 'Bạn chưa nhập captcha',
            'token.required' => 'Token Không hợp lệ',
            'password.required' => 'Bạn chưa nhập mật khẩu mới',
            'password.min' => 'Mật khẩu tối thiểu phải 6 ký tự trở lên',
            'password.regex' => 'Mật khẩu phải chứa số, kí tự, chữ hoa và chữ thường',
            'password.confirmed' => 'Mật khẩu xác nhận không khớp',
            'password_confirmation.required' => 'Bạn chưa nhập mật khẩu xác nhận',
            'password_confirmation.min' => 'Mật khẩu xác nhận tối thiểu phải 6 ký tự trở lên',
        ];
    }
}
